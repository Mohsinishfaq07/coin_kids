import 'dart:async';

import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KidGoalsController extends GetxController {
  final appBar = Get.find<KidAppBarController>();
  final appState = Get.find<AppStateController>();

  final TextEditingController textController = TextEditingController();

  var sliderValue = 0.0.obs; // .obs makes it reactive
  RxBool isMinus = false.obs;

  RxBool isLoading = false.obs;

  var isImageRemoved = false.obs;

  var goalCurrentAmount = 0.0.obs;
  final ImagePicker picker = ImagePicker();

  RxBool isPickingImage = false.obs; // Add flag
  var initialSliderValue = 0.0;

  final RxList<GoalModel> goals = <GoalModel>[].obs;

  // Stream subscription
  StreamSubscription<List<GoalModel>>? _goalsSubscription;

  final GoalService _goalService = Get.find<GoalService>();

  final Rx<GoalModel> oldGoal = Rx<GoalModel>(
    GoalModel(
      userId: '',
      title: '',
      photo: '',
      targetAmount: 0,
      savedAmount: 0,
      status: GoalStatus.in_progress,
      createdAt: DateTime.now(),
    ),
  );

  final Rx<GoalModel> newGoal = Rx<GoalModel>(
    GoalModel(
      userId: '',
      title: '',
      photo: '',
      targetAmount: 0,
      savedAmount: 0,
      status: GoalStatus.in_progress,
      createdAt: DateTime.now(),
    ),
  );

  final Rx<GoalSummaryScreenMode> screenMode = Rx<GoalSummaryScreenMode>(GoalSummaryScreenMode.create);
  final RxString goalId = ''.obs;

  final RxDouble progressValue = 0.0.obs;
  final double progressStep = 0.25;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _goalsSubscription?.cancel();
    super.onClose();
  }

  void setTitle(title) {
    newGoal.value = newGoal.value.copyWith(title: title);
    newGoal.refresh();
  }

  void setAmount(targetAmount) {
    newGoal.value = newGoal.value.copyWith(targetAmount: targetAmount);
    newGoal.refresh();
  }

  void setPhoto(photo) {
    newGoal.value = newGoal.value.copyWith(photo: photo);
    newGoal.refresh();
  }

  void removePhoto() {
    newGoal.value = newGoal.value.copyWith(photo: '');
    newGoal.refresh();
  }

  void setInitialSliderValue(double value) {
    initialSliderValue = value;
  }

  double getInitialSliderValue() {
    return initialSliderValue;
  }

  void setGoalCurrentAmount(double amount) {
    goalCurrentAmount.value = amount;
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        print("Path is: " + pickedFile.path);
        setPhoto(pickedFile.path);
      } else {
        ToastUtil.showToast("No Image Selected");
      }
    } catch (e) {
      ToastUtil.showToast("Failed to pick and save image: $e");
    }
  }

  Future<void> pickImageFromCamera() async {
    if (isPickingImage.value) return; // Prevent multiple calls
    isPickingImage.value = true;

    try {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        newGoal.value.copyWith(photo: pickedImage.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      isPickingImage.value = false; // Reset flag
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _goalService.deleteGoal(goalId);
      Get.back();
    } catch (e) {
      print('Error deleting goal: $e');
      Get.back();
    }
  }

  void startListeningToGoals(String kidId) {
    isLoading.value = true;

    _goalsSubscription = _goalService.streamUserGoals(kidId).listen(
      (goalsList) {
        goals.value = goalsList.where((goal) => goal.status != GoalStatus.deleted).toList();
        isLoading.value = false;
      },
      onError: (error) {
        print('Error fetching goals: $error');
        isLoading.value = false;
      },
    );
  }

  void createNewGoal() async {
    showLoadingDialog("Creating Goal ...");

    try {
      final goal = newGoal.value.copyWith(userId: appState.currentKid.value!.kidId, createdAt: DateTime.now());
      await _goalService.createGoal(goal);

      if (appState.currentKid.value!.coinKidsBalance == -1) {
        final _kidService = Get.find<KidService>();
        await _kidService.updateCoinKidsBalance(appState.currentKid.value!.kidId, 0);

        //Usage
        KidDialog.show(
          emoji: Assets.icCoinStar,
          title: 'WoW',
          subtitle: 'You unlock CoinKids bar and receive\nyour first Coinkids',
          extraContent: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Assets.icCoinStar,
                width: 20.w,
                height: 20.w,
              ),
              SizedBox(width: 4.w),
              Text("+2 CoinKids", style: AppTextStyle.bodyMedium.copyWith(color: Colors.white))
            ],
          ),
          buttons: [
            KidButton(
              text: 'Ok',
              onTap: () {
                Get.until((route) => route.settings.name == '/KidBaseScreen');
              },
              baseColor: AppColors.btnColorGreen,
            ),
          ],
        );

        resetNewGoal();

        return;
      }

      resetNewGoal();

      Get.until((route) => route.settings.name == '/KidBaseScreen');
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.back();
      print(e);
    }
  }

  void updateGoal() async {

    try {
      if (oldGoal.value == newGoal.value) {
        return;
      }

      showLoadingDialog("Updating Goal...");

      final goal = newGoal.value.copyWith(userId: appState.currentKid.value!.kidId, createdAt: DateTime.now());
      await _goalService.updateGoal(goal);

      resetNewGoal();
      resetOldGoal();

      Get.close(2);
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.back();
      print(e);
    }
  }

  void incrementProgress(GoalModel goal) {
    final newValue = (progressValue.value + progressStep).clamp(0.0, goal.targetAmount);
    updateProgress(newValue);
  }

  void decrementProgress(GoalModel goal) {
    final newValue = (progressValue.value - progressStep).clamp(0.0, goal.targetAmount);
    updateProgress(newValue);
  }

  void updateProgress(double value) {
    progressValue.value = value;
    textController.text = value.toMoneyFormat(showSymbol: false);
  }

  Future<void> saveProgress(GoalModel goal) async {
    final newAmount = double.parse(progressValue.value.toMoneyFormat(showSymbol: false));

    // If the value hasn't changed, do nothing
    if (newAmount == goal.savedAmount) {
      return;
    }

    final finalGoal = goals.firstWhere((item) {
      return item.id == goal.id;
    });

    // Calculate percentage of completion
    final targetAmount = finalGoal.targetAmount;
    final oldPercentage = (finalGoal.savedAmount / targetAmount) * 100;
    final newPercentage = (newAmount / targetAmount) * 100;

    print("oldPercentage $oldPercentage");
    print("newPercentage $newPercentage");

    showLoadingDialog("Saving Goal");
    try {
      await _goalService.updateSavedAmount(finalGoal.id!, newAmount).timeout(Duration(seconds: 15), onTimeout: () {
        throw Exception(TimeoutException);
      });
    } catch (e) {
      print('Error saving progress: $e');
      ToastUtil.showToast("No Internet Connection");
      return;
    } finally {
      Get.back();
    }

    if (oldPercentage < 100 && newPercentage >= 100) {
      _showGoalCompletedDialog(goal.targetAmount);
    } else if (oldPercentage < 75 && newPercentage >= 75) {
      _showMilestoneDialog("So Close!", "You're 75% closer to reaching your Goal", 6, Assets.icConfetti);
    } else if (oldPercentage < 50 && newPercentage >= 50) {
      _showMilestoneDialog("Halfway There!", "Amazing work! Keep saving", 4, Assets.icHappyStar);
    } else if (oldPercentage < 25 && newPercentage >= 25) {
      _showMilestoneDialog("Great Job!", "You just reach your first milestone", 2, Assets.icClap);
    }
  }

  void resetNewGoal() {
    newGoal.value = GoalModel(
      userId: '',
      title: '',
      photo: '',
      targetAmount: 0,
      savedAmount: 0,
      status: GoalStatus.in_progress,
      createdAt: DateTime.now(),
    );
  }

  void resetOldGoal() {
    oldGoal.value = GoalModel(
      userId: '',
      title: '',
      photo: '',
      targetAmount: 0,
      savedAmount: 0,
      status: GoalStatus.in_progress,
      createdAt: DateTime.now(),
    );
  }

  void _showMilestoneDialog(String title, String subtitle, int coinKids, String emoji) {
    KidDialog.show(
      emoji: emoji,
      title: title,
      subtitle: subtitle,
      extraContent: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.icCoinStar,
            width: 20.w,
            height: 20.w,
          ),
          SizedBox(width: 4.w),
          Text("+$coinKids CoinKids", style: AppTextStyle.bodyMedium.copyWith(color: Colors.white))
        ],
      ),
      buttons: [
        KidButton(
          text: 'Continue',
          onTap: () {
            Get.back();
          },
          baseColor: AppColors.btnColorGreen,
        ),
      ],
    );
  }

  void _showGoalCompletedDialog(double amount) {
    KidDialog.show(
      emoji: Assets.icTrophy,
      title: 'You Did It!',
      subtitle: 'Congratulations, Nina! You’ve reached\nyour savings goal ${amount.toMoneyFormat()}',
      extraContent: Column(
        children: [
          SizedBox(height: 8.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Assets.icCoinStar,
                width: 20.w,
                height: 20.w,
              ),
              SizedBox(width: 4.w),
              Text("+10 CoinKids", style: AppTextStyle.bodyMedium.copyWith(color: Colors.white))
            ],
          ),
        ],
      ),
      buttons: [
        KidButton(
          text: 'Awesome!',
          onTap: () {
            Get.back();
          },
          baseColor: AppColors.btnColorGreen,
          iconPath: Assets.icTick,
        ),
      ],
    );
  }
}
