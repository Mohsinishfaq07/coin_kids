import 'dart:async';

import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
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
      status: GoalStatus.inProgress,
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
      status: GoalStatus.inProgress,
      createdAt: DateTime.now(),
    ),
  );

  final Rx<GoalSummaryScreenMode> screenMode = Rx<GoalSummaryScreenMode>(GoalSummaryScreenMode.create);
  final RxString goalId = ''.obs;

  final RxDouble progressValue = 0.0.obs;
  final double progressStep = 0.25;

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
        Get.log("Path is: ${pickedFile.path}");
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
      Get.log("Error picking image: $e");
    } finally {
      isPickingImage.value = false; // Reset flag
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _goalService.deleteGoal(goalId);
      Get.back();
    } catch (e) {
      Get.log('Error deleting goal: $e');
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
        Get.log('Error fetching goals: $error');
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
        final kidService = Get.find<KidService>();
        await kidService.updateCoinKidsBalance(appState.currentKid.value!.kidId, 0);

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
                Get.until((route) => route.settings.name == Routes.kidBase);
              },
              baseColor: AppColors.btnColorGreen,
            ),
          ],
        );

        resetNewGoal();

        return;
      }

      resetNewGoal();

      Get.until((route) => route.settings.name == Routes.kidBase);
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.back();
      Get.log(e.toString(), isError: true);
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

      Get.until((route) => route.settings.name == Routes.kidBase);
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.back();
      Get.log(e.toString(), isError: true);
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

  Future<void> saveProgress(String goalId) async {
    try {
      showLoadingDialog("Updating Progress");
      // Get the current goal to compare values
      final goal = goals.firstWhere((item) => item.id == goalId);

      // Get the current value from the slider
      final newAmount = progressValue.value;

      // If the value hasn't changed, do nothing
      if (newAmount == goal.savedAmount) {
        Get.back();
        return;
      }

      // Use the transaction method to update progress with rewards
      await _goalService.updateGoalProgressWithRewards(goalId, newAmount);

      Get.back();

      // Only show milestone dialogs if the amount is increasing
      if (newAmount > goal.savedAmount) {
        final percentage = (newAmount / goal.targetAmount) * 100;

        if (percentage >= 100 && goal.savedAmount < goal.targetAmount) {
          _showGoalCompletedDialog(goal.targetAmount);
        } else if (percentage >= 75 && (goal.savedAmount / goal.targetAmount) * 100 < 75) {
          _showMilestoneDialog("So Close!", "You're 75% closer to reaching your PS5", 3, Assets.icConfetti);
        } else if (percentage >= 50 && (goal.savedAmount / goal.targetAmount) * 100 < 50) {
          _showMilestoneDialog("Halfway There! ", "Amazing work! Keep saving.", 2, Assets.icHappyStar);
        } else if (percentage >= 25 && (goal.savedAmount / goal.targetAmount) * 100 < 25) {
          _showMilestoneDialog("Great Job!", "You just reach your first milestone", 2, Assets.icClap);
        }
      }
    } catch (e) {
      Get.log('Error saving progress: $e');
      ToastUtil.showExceptionToast(e);
    }
  }

  void resetNewGoal() {
    newGoal.value = GoalModel(
      userId: '',
      title: '',
      photo: '',
      targetAmount: 0,
      savedAmount: 0,
      status: GoalStatus.inProgress,
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
      status: GoalStatus.inProgress,
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
      subtitle: 'Congratulations, ${appState.currentKid.value!.name}, You\'ve reached\nyour savings goal ${amount.toMoneyFormat()}',
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
