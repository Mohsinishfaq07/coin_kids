
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class KidTransferController extends GetxController {
  final appState = Get.find<AppStateController>();
  final appBarController = Get.find<KidAppBarController>();
  final RxBool showPointer = true.obs;
  final Rx<Offset?> pointerPosition = Rx<Offset?>(null);


  @override
  void onInit() {
    super.onInit();
    _checkTransferTutorialState();
  }

  Future<void> _checkTransferTutorialState() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenSpendingToSavingTutorial) ?? false;
    showPointer.value = !hasSeenTutorial;
  }

  Future<void> markTransferTutorialAsShown() async {
    await SharedPreferencesHelper.saveBool(SharedPreferencesHelper.hasSeenSpendingToSavingTutorial, true);
    showPointer.value = false;
  }

  @override
  void onReady() {
    appBarController.configureForTransfer();
    super.onReady();
  }

  void handleTransfer({
    required String sourceJar,
    required String targetJar,
    required double availableAmount,
  }) {
    if (availableAmount <= 0) {
      ToastUtil.showToast('Not enough funds in jar');
      return;
    }

    Get.toNamed(
      Routes.kidDragAndDrop,
      arguments: {
        'mode': DragAndDropMode.transferMoney,
        'sourceJarId': sourceJar,
        'targetJarId': targetJar,
        'amount': availableAmount,
      },
    );
  }

  @override
  void onClose() {
    appBarController.resetToDefault();
    super.onClose();
  }
}
