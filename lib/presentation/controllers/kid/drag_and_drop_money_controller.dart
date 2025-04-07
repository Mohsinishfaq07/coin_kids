import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'jar_creation_controller.dart';

enum DragAndDropMode {
  jarCreation, // Creating new jar
  countMoney, // Counting existing jar money
  transferMoney, // Transfer between jars
}

class DragAndDropMoneyController extends GetxController {
  final appState = Get.find<AppStateController>();
  final jarCreationController = Get.find<JarCreationController>();
  final appBarController = Get.find<KidAppBarController>();
  final kidService = Get.find<KidService>();

  // Toggle between bills and coins
  final isShowingBills = true.obs;

  final Rx<Offset> jarOffset = Offset(0, 0).obs;
  final Rx<Offset> moneyOffset = Offset(0, 0).obs;

  // Current amount being added
  final totalValue = 0.0.obs;

  // Stack for undo functionality
  final addedAmounts = <double>[].obs;

  // Jar state
  final jarState = JarState.empty.obs;

  late final DragAndDropMode mode;
  late final double targetAmount;
  late final String sourceJarId;
  late final String targetJarId;

  // Add these variables
  final isFirstTime = true.obs;
  final isTutorialPlaying = false.obs;
  AnimationController? tutorialAnimationController;
  Animation<Offset>? dragAnimation;

  @override
  void onInit() {
    super.onInit();
    _initializeMode();
    // Check if it's first time from SharedPreferences
    checkFirstTime();
  }

  @override
  void onReady() {
    super.onReady();
    // Configure AppBar when the widget is ready
    appBarController.configureForAddMoney();

    cancelTitle.value = switch (mode) {
      DragAndDropMode.jarCreation => "Cancel Jar Creation?",
      DragAndDropMode.countMoney => "Cancel Counting?",
      DragAndDropMode.transferMoney => "Cancel Transfer",
    };
  }

  @override
  void onClose() {
    appBarController.resetToDefault();

    reset();
    super.onClose();
  }

  void _initializeMode() {
    mode = Get.arguments['mode'] as DragAndDropMode;

    switch (mode) {
      case DragAndDropMode.jarCreation:
        targetAmount = _roundToTwoDecimals(jarCreationController.amount.value);
        break;

      case DragAndDropMode.countMoney:
        final jarName = Get.arguments['jarId'] as String;
        if (jarName == Jars.spendingJar.name) {
          final jar = appState.currentKid.value?.wallet.spendingJar;
          targetAmount = _roundToTwoDecimals(jar?.balance ?? 0.0);
        } else {
          final jar = appState.currentKid.value?.wallet.savingJar;
          targetAmount = _roundToTwoDecimals(jar?.balance ?? 0.0);
        }
        break;

      case DragAndDropMode.transferMoney:
        sourceJarId = Get.arguments['sourceJarId'] as String;
        targetJarId = Get.arguments['targetJarId'] as String;
        targetAmount = _roundToTwoDecimals(Get.arguments['amount'] as double);
        break;
    }
  }

  final cancelTitle = ''.obs;

  Future<void> handleNextButton() async {
    switch (mode) {
      case DragAndDropMode.jarCreation:
        await _handleJarCreation();
        break;

      case DragAndDropMode.countMoney:
        _handleCountingComplete();
        break;

      case DragAndDropMode.transferMoney:
        await _handleTransfer();
        break;
    }
  }

  Future<void> _handleJarCreation() async {
    await createJar();
  }

  void _handleCountingComplete() {
    if (isComplete()) {
      Get.back();
      ToastUtil.showToast("Great job counting! 🎉");
    } else {
      ToastUtil.showToast(
          "Keep Counting! ${remainingAmount.toMoneyFormat()} is left");
    }
  }

  Future<void> _handleTransfer() async {
    showLoadingDialog('Transferring...');
    try {
      final currentKid = appState.currentKid.value;
      if (currentKid != null) {
        await kidService
            .transferBetweenJars(
          currentKid.kidId,
          sourceJarId,
          targetJarId,
          _roundToTwoDecimals(totalValue.value),
        )
            .timeout(Duration(seconds: 15), onTimeout: () {
          throw Exception("Timeout error, Check internet connection");
        });

        ToastUtil.showToast("Transfer complete! 🎉");
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    } finally {
      Get.until((route) => route.settings.name == Routes.kidBase);
    }
  }

  void toggleMoneyType() {
    isShowingBills.value = !isShowingBills.value;
  }

  bool canAddAmount(double amount) {
    final newTotal = totalValue.value + amount;
    return newTotal <= targetAmount;
    // const epsilon = 0.001;
    // return (newTotal - targetAmount).abs() < epsilon || newTotal < targetAmount;
  }

  Future<void> createJar() async {
    if (jarCreationController.jarType == Jars.spendingJar && !isComplete()) {
      ToastUtil.showToast("Enter all amount");
      return;
    }

    final kid = appState.currentKid.value;

    if (kid == null) {
      ToastUtil.showToast("Session Expired");
      Get.offAllNamed(Routes.signIn);
      return;
    }

    final spendingJar = kid!.wallet.spendingJar;
    final savingJar = kid.wallet.savingJar;

    try {
      showLoadingDialog("Creating Jar");
      if (jarCreationController.jarType == Jars.spendingJar) {
        if (isComplete()) {
          final finalBalance = _roundToTwoDecimals(
              spendingJar.balance + _roundToTwoDecimals(totalValue.value));
          Get.log('final Balance Spend $finalBalance');
          jarCreationController.kidService.updateSpendingJar(
              kid.kidId, finalBalance,
              color: jarCreationController
                  .colors[jarCreationController.selectedColorIndex.value]
                  .value);
        } else {
          ToastUtil.showToast("${remainingAmount.toMoneyFormat()} remaining");
        }
      } else {
        final roundedTotal = _roundToTwoDecimals(totalValue.value);
        Get.log('final Balance Total $roundedTotal');
        final finalBalance =
            _roundToTwoDecimals(savingJar.balance + roundedTotal);
        Get.log('final Balance Save $finalBalance');

        jarCreationController.kidService.updateSavingJar(
            kid.kidId, finalBalance,
            color: jarCreationController
                .colors[jarCreationController.selectedColorIndex.value].value);
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    } finally {
      Get.until((route) => route.settings.name == Routes.kidBase);
    }
  }

  // Helper method to round to 2 decimal places
  double _roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  Future<bool> tryAddAmount(double amount) async {
    final roundedAmount = _roundToTwoDecimals(amount);
    final newTotal = _roundToTwoDecimals(totalValue.value + roundedAmount);

    if (newTotal > _roundToTwoDecimals(targetAmount)) {
      await HapticFeedback.heavyImpact();
      Get.snackbar(
        'Cannot Add Amount',
        'You can only add ${_roundToTwoDecimals(remainingAmount).toStringAsFixed(2)}€',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    }

    totalValue.value = newTotal;
    addedAmounts.add(roundedAmount);
    updateJarState();
    await HapticFeedback.lightImpact();
    return true;
  }

  void updateJarState() {
    if (totalValue.value > 0) {
      jarState.value = JarState.filled;
    } else {
      jarState.value = JarState.empty;
    }
  }

  double get remainingAmount =>
      _roundToTwoDecimals(targetAmount - totalValue.value);

  // bool get isComplete => totalValue.value == targetAmount;
  bool isComplete() {
    return _roundToTwoDecimals(totalValue.value) ==
        _roundToTwoDecimals(targetAmount);
  }

  RxDouble spendingAmount = 0.0.obs; // Changed to RxDouble
  RxDouble savingAmount = 0.0.obs; // Changed to RxDouble
  var clickedIndex = 0.obs; // Observable for the text
  RxBool isJarFilled = false.obs;
  RxList<double> droppedNotes = <double>[].obs; // Changed to double
  RxString spendingJarColor = ''.obs;
  RxString savingJarColor = ''.obs;

  void resetJar() {
    droppedNotes.clear();
    totalValue.value = _roundToTwoDecimals(0.0); // Reset to 0.00
  }

  Future<void> undoLastAmount() async {
    if (addedAmounts.isNotEmpty) {
      final lastAmount = addedAmounts.last;
      totalValue.value = _roundToTwoDecimals(totalValue.value - lastAmount);
      addedAmounts.removeLast();
      updateJarState();
      await HapticFeedback.mediumImpact();
    } else {
      Get.snackbar(
        'Nothing to Undo',
        'No more actions to undo',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void reset() {
    totalValue.value = _roundToTwoDecimals(0.0); // Reset to 0.00
    addedAmounts.clear();
    updateJarState();
  }

  // Organize bills by rows for better layout control
  final List<List<MapEntry<String, double>>> billRows = [
    // Row 1: 10€, 5€
    [
      MapEntry(Assets.euroTen, 10.0),
      MapEntry(Assets.euroFive, 5.0),
    ],
    // Row 2: 50€, 20€
    [
      MapEntry(Assets.euroFifty, 50.0),
      MapEntry(Assets.euroTwenty, 20.0),
    ],
    // Row 3: 100€, 200€
    [
      MapEntry(Assets.euroTwoHundred, 200.0),
      MapEntry(Assets.euroHundred, 100.0),
    ],
  ];

  // Organize coins by rows
  final List<List<MapEntry<String, double>>> coinRows = [
    // Row 1: 2€, 1€ (larger coins)
    [
      MapEntry(Assets.euroTwo, 2.0),
      MapEntry(Assets.euroOne, 1.0),
    ],
    // Row 2: 50c, 20c, 10c
    [
      MapEntry(Assets.centFifty, 0.50),
      MapEntry(Assets.centTwenty, 0.20),
      MapEntry(Assets.centTen, 0.10),
    ],
    // Row 3: 5c, 2c, 1c
    [
      MapEntry(Assets.centFive, 0.05),
      MapEntry(Assets.centTwo, 0.02),
      MapEntry(Assets.centOne, 0.01),
    ],
  ];

  // Remove old maps as they're now organized in rows
  Map<String, double> get billsList =>
      Map.fromEntries(billRows.expand((row) => row).toList());

  Map<String, double> get coinsList =>
      Map.fromEntries(coinRows.expand((row) => row).toList());

  String get screenTitle {
    switch (mode) {
      case DragAndDropMode.jarCreation:
        return "Add money";
      case DragAndDropMode.countMoney:
        return "Count your money";
      case DragAndDropMode.transferMoney:
        return "Transfer money";
    }
  }

  String get nextButtonText {
    switch (mode) {
      case DragAndDropMode.jarCreation:
        return "Create Jar";
      case DragAndDropMode.countMoney:
        return "Done";
      case DragAndDropMode.transferMoney:
        return "Transfer";
    }
  }

  Future<void> checkFirstTime() async {
    isFirstTime.value =
        SharedPreferencesHelper.getBool('drag_drop_tutorial_shown') ?? true;
    if (isFirstTime.value) {
      // Small delay to ensure screen is built
      await Future.delayed(const Duration(milliseconds: 500));
      showTutorial();
    }
  }

  void showTutorial() {
    isTutorialPlaying.value = true;
  }

  void endTutorial() async {
    isTutorialPlaying.value = false;
    await SharedPreferencesHelper.saveBool('drag_drop_tutorial_shown', false);
    isFirstTime.value = false;
  }
}
