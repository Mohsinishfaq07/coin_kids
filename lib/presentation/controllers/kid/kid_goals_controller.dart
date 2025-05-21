import 'dart:async';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_summary_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KidGoalsController extends GetxController {
  final appBarController = Get.find<KidAppBarController>();
  final appState = Get.find<AppStateController>();
  final _goalService = Get.find<GoalService>();
  final _kidService = Get.find<KidService>();
  final _roleController = Get.find<RoleController>();
  final Rx<Offset?> pointerPosition = Rx<Offset?>(null);
  final analytics = Get.find<AnalyticsService>();
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
  StreamSubscription<KidModel?>? _kidSubscription;

  final RxBool showPointer = true.obs;

  final RxBool shouldResetAppBar = true.obs;

  // Future<void> checkTutorialState() async {
  //   final hasSeenTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenGoalsListInGoalScreenTutorial) ?? false;
  //   showPointer.value = !hasSeenTutorial;
  // }

  void switchToParentMode() {
    final isKidConnected = currentKid.value?.isConnected ?? false;
    if (!isKidConnected) {
      // final kidService = Get.find<KidService>();
      _kidService.updateKid(
        currentKid.value!.kidId,
        currentKid.value!.copyWith(isConnected: true),
      );
    }

    _roleController.switchToParentMode(true);
  }

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

  final Rx<GoalSummaryScreenMode> screenMode =
      Rx<GoalSummaryScreenMode>(GoalSummaryScreenMode.create);
  final RxString goalId = ''.obs;

  final RxDouble progressValue = 0.0.obs;
  final double progressStep = 0.01;

  Rx<KidModel?> currentKid = Rx<KidModel?>(null);

  @override
  void onClose() {
    _goalsSubscription?.cancel();
    _kidSubscription?.cancel();
    logScreenTime();

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
    if (isPickingImage.value) return; // Prevent multiple calls
    isPickingImage.value = true;
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
    } finally {
      isPickingImage.value = false;
    }
  }

  Future<void> pickImageFromCamera() async {
    if (isPickingImage.value) return; // Prevent multiple calls
    isPickingImage.value = true;

    try {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        Get.log("Path is: ${pickedImage.path}");
        setPhoto(pickedImage.path);
      } else {
        ToastUtil.showToast("No Image Selected");
      }
    } catch (e) {
      Get.log("Error picking image: $e");
    } finally {
      isPickingImage.value = false; // Reset flag
    }
  }

  Future<void> deleteGoal(String goalId) async {
    showLoadingDialog("Deleting Goal ...");
    try {
      // Get the current goal
      final goal = await _goalService.fetchGoalById(goalId);
      if (goal == null) {
        ToastUtil.showToast("Goal not found");
        Get.back();
        return;
      }

      // Get the current kid
      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      // Only refund if goal is completed and kid is connected
      if (goal.status == GoalStatus.completed && kid.isConnected ||
          goal.status == GoalStatus.inProgress && kid.isConnected) {
        // Calculate new spending jar balance by adding the goal's saved amount
        final newSpendingBalance =
            kid.wallet.spendingJar.balance + goal.savedAmount;

        // Update spending jar balance to refund the amount
        await _kidService.updateSpendingJar(kid.kidId, newSpendingBalance);
      }

      // Navigate back to base screen before deleting the goal
      Get.back(); // Close loading dialog
      Get.back(); // Close delete confirmation dialog
      Get.until((route) => route.settings.name == Routes.kidBase);

      // Delete the goal after navigation
      await _goalService.deleteGoal(goalId).timeout(Duration(seconds: 15),
          onTimeout: () {
        throw Exception("Request Timeout");
      });

      ToastUtil.showToast('Goal deleted successfully');
      appBarController
          .resetToDefault(); // Reset app bar after successful deletion
    } catch (e) {
      Get.log('Error deleting goal: $e');
      ToastUtil.showToast('Failed to delete goal');
      Get.back(); // Close loading dialog
    }
  }

  void startListeningToGoals(String kidId) {
    isLoading.value = true;

    // Start listening to kid data
    _kidSubscription = _kidService.streamKid(kidId).listen(
      (kidData) {
        currentKid.value = kidData;
      },
      onError: (error) {
        Get.log('Error fetching kid data: $error');
      },
    );

    _goalsSubscription = _goalService.streamUserGoals(kidId).listen(
      (goalsList) {
        // Sort goals based on priority:
        // 1. In-progress goals first
        // 2. Within in-progress, modified goals (with saved amount) first
        // 3. Then other goals (completed, approved, rejected)
        goalsList.sort((a, b) {
          // First priority: In-progress goals come first
          if (a.status == GoalStatus.inProgress &&
              b.status != GoalStatus.inProgress) {
            return -1;
          }
          if (a.status != GoalStatus.inProgress &&
              b.status == GoalStatus.inProgress) {
            return 1;
          }

          // Second priority: For in-progress goals, sort by modification
          if (a.status == GoalStatus.inProgress &&
              b.status == GoalStatus.inProgress) {
            if (a.savedAmount > 0 && b.savedAmount == 0) return -1;
            if (a.savedAmount == 0 && b.savedAmount > 0) return 1;
            return b.createdAt.compareTo(a.createdAt); // Then by creation date
          }

          // Third priority: For non-in-progress goals, sort by completion date
          if (a.status != GoalStatus.inProgress &&
              b.status != GoalStatus.inProgress) {
            final aDate = a.completedAt ?? a.createdAt;
            final bDate = b.completedAt ?? b.createdAt;
            return bDate.compareTo(aDate); // Most recent first
          }

          return 0;
        });

        goals.value = goalsList.toList();
        isLoading.value = false;
      },
      onError: (error) {
        Get.log('Error fetching goals: $error');
        isLoading.value = false;
      },
    );
  }

  Future<void> createNewGoal() async {
    showLoadingDialog("Creating Goal ...");

    try {
      final isFirstGoal = appState.currentKid.value!.coinKidsBalance == -1;
      final goal = newGoal.value.copyWith(
          userId: appState.currentKid.value!.kidId, createdAt: DateTime.now());

      // Store the goal title to identify it later
      final goalTitle = goal.title;

      // Pass isFirstGoal flag to createGoal
      await _goalService.createGoal(goal, isFirstGoal);

      // Handle first goal case with dialog
      // Get.back();

      // Reset the form
      resetNewGoal();

      // Reset app bar if needed
      // if (shouldResetAppBar.value) {
      //   appBarController.resetToDefault();
      // }

      // Wait a moment for the goal to be added to the database and streamed back
      await Future.delayed(Duration(milliseconds: 500));

      // Find the goal with the matching title in our goals list
      final createdGoal = goals.firstWhereOrNull((g) =>
          g.title == goalTitle &&
          g.targetAmount == goal.targetAmount &&
          g.createdAt.isAfter(DateTime.now().subtract(Duration(minutes: 1))));

      if (createdGoal != null) {
        KidDialog.show(
          emoji: Assets.icClap,
          title: 'Goal Created!',
          subtitle: 'The goal was added \n successfully',
          buttons: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                KidButton(
                  key: GlobalKeys.okButtonKey,
                  text: 'See Goal',
                  onTap: () async {
                    showPointer.value = false;
                    await SharedPreferencesHelper.saveBool(
                      SharedPreferencesHelper.hasSeenFirstGoalDialogTutorial,
                      true,
                    );

                    Get.offNamed(Routes.kidGoalDetailsScreen,
                        arguments: createdGoal.id);
                  },
                  baseColor: AppColors.btnColorGreen,
                ),
                Obx(() {
                  if (showPointer.value) {
                    return Positioned(
                      right: 0.w,
                      bottom: 0.h,
                      child: HandPointerOverlay(
                        targetKey: GlobalKeys.okButtonKey,
                        onTap: () async {
                          showPointer.value = false;
                          await SharedPreferencesHelper.saveBool(
                            SharedPreferencesHelper
                                .hasSeenFirstGoalDialogTutorial,
                            true,
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ],
        );
      } else {
        // Fallback if we can't find the goal
        Get.until((route) => route.settings.name == Routes.kidBase);
      }
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.until((route) => route.settings.name == Routes.kidBase);
      Get.log(e.toString(), isError: true);
    }
  }

  Future<void> updateGoal() async {
    try {
      if (oldGoal.value == newGoal.value) {
        return;
      }

      showLoadingDialog("Updating Goal...");
// update gol validation implemented if the amount goes less than target amount
      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      // Check if saved amount equals or exceeds new target amount
      if (oldGoal.value.savedAmount >= newGoal.value.targetAmount) {
        // Calculate excess amount if any
        final excessAmount =
            oldGoal.value.savedAmount - newGoal.value.targetAmount;

        // Create updated goal with completed status
        final updatedGoal = newGoal.value.copyWith(
          userId: kid.kidId,
          createdAt: DateTime.now(),
          savedAmount: newGoal.value.targetAmount,
          status: GoalStatus.completed,
          completedAt: DateTime.now(),
        );
        await _goalService.updateGoal(updatedGoal);

        if (excessAmount > 0) {
          // Return excess amount to spending jar
          final newSpendingBalance =
              kid.wallet.spendingJar.balance + excessAmount;
          await _kidService.updateSpendingJar(kid.kidId, newSpendingBalance);

          // Show success message
          ToastUtil.showToast(
              '${excessAmount.toMoneyFormat()}€ returned to spending jar');
        }

        // Show completion dialog
        showGoalCompletedDialog(newGoal.value.targetAmount);
      } else {
        // Normal update without completion
        final goal = newGoal.value.copyWith(
          userId: kid.kidId,
          createdAt: DateTime.now(),
        );
        await _goalService.updateGoal(goal);
        appBarController.resetToDefault();
      }

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
    final newValue =
        (progressValue.value + progressStep).clamp(0.0, goal.targetAmount);
    updateProgress(newValue);
  }

  void decrementProgress(GoalModel goal) {
    final newValue =
        (progressValue.value - progressStep).clamp(0.0, goal.targetAmount);
    updateProgress(newValue);
  }

  void updateProgress(double value, [GoalModel? goal]) {
    final kid = appState.currentKid.value;
    if (kid == null) return;

    // If goal is provided, ensure value doesn't exceed target amount
    if (goal != null && value > goal.targetAmount) {
      value = goal.targetAmount;
    }

    // Only update the progress value, no transfers or messages
    progressValue.value = value;
  }

  Future<void> saveProgress(String goalId, {int? rewardCoins}) async {
    try {
      showLoadingDialog("Updating Progress");

      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      // Get the current goal to compare values
      final goal = await _goalService.fetchGoalById(goalId);
      if (goal == null) {
        ToastUtil.showToast("Goal not found");
        Get.back();
        return;
      }

      // Calculate the difference in progress
      final difference = progressValue.value - goal.savedAmount;

      // If no change in progress, just return
      if (difference == 0) {
        Get.back();
        _showMilestoneDialog(
            "Don't Give Up!",
            "You haven't entered any amount yet. Every step counts toward your goal!",
            // 0,
            Assets.emojiSad);
        // Get.until((route) => route.settings.name == Routes.kidBase);
        // appBarController.resetToDefault();
        return;
      }

      // Check if we have enough spending balance when increasing progress
      if (difference > 0) {
        final spendingBalance = kid.wallet.spendingJar.balance;
        if (difference > spendingBalance) {
          Get.back();
          // ToastUtil.showToast("Not enough money in spending jar");
          _showMilestoneDialog(
              "Insufficient Funds",
              "Your Spending Jar doesn't have enough balance",
              // 0,
              Assets.emojiSad);

          return;
        }
      } else {
        //Get.back();
        // If decreasing progress, show how much will be returned
        final returnAmount = -difference; // Make positive for display
        // _showMilestoneDialog("Great Job!",
        //     '${returnAmount.toMoneyFormat()}€ returned to spending jar', 2, Assets.icClap);
        ToastUtil.showToast(
            '${returnAmount.toMoneyFormat()}€ will be returned to spending jar');
      }

      // Update the goal progress
      await _goalService.updateGoalProgressWithRewards(
          goalId, progressValue.value);

      // Update spending jar balance
      final newSpendingBalance = kid.wallet.spendingJar.balance - difference;
      await _kidService.updateSpendingJar(kid.kidId, newSpendingBalance);

      Get.back();

      // Show appropriate messages and dialogs based on progress change
      if (difference > 0) {
        // Handle increasing progress with milestones
        final percentage = (progressValue.value / goal.targetAmount) * 100;
        final oldPercentage = (goal.savedAmount / goal.targetAmount) * 100;

        if (percentage >= 100 && oldPercentage < 100) {
          showGoalCompletedDialog(goal.targetAmount);
        } else if (percentage >= 75 && oldPercentage < 75) {
          _showMilestoneDialog(
              "So Close!",
              "You're 75% closer to reaching your goal",
              //  3,
              Assets.icConfetti);
        } else if (percentage >= 50 && oldPercentage < 50) {
          _showMilestoneDialog(
              "Halfway There!",
              "Amazing work! Keep saving.",
              //2,
              Assets.icHappyStar);
        } else if (percentage >= 25 && oldPercentage < 25) {
          _showMilestoneDialog(
              "Great Job!",
              "You just reached your first milestone",
              //2,
              Assets.icClap);
        } else {
          _showMilestoneDialog(
              "Great Job!",
              "You are about to reached your first milestone",
              // 2,
              Assets.icClap);
          // Get.until((route) => route.settings.name == Routes.kidBase);
        }
      }
    } catch (e) {
      Get.log('Error saving progress: $e');
      ToastUtil.showToast('Failed to save progress');
      Get.until((route) => route.settings.name == Routes.kidBase);
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

  void _showMilestoneDialog(
      String title,
      String subtitle,
      //int coinKids,
      String emoji) {
    KidDialog.show(
      emoji: emoji,
      title: title,
      subtitle: subtitle,
      extraContent: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SvgPicture.asset(
          //   Assets.icCoinStar,
          //   width: 20.w,
          //   height: 20.w,
          // ),
          SizedBox(width: 4.w),
          // Text("+$coinKids CoinKids",
          //     style: AppTextStyle.bodyMedium.copyWith(color: Colors.white))
        ],
      ),
      buttons: [
        KidButton(
          text: 'Continue',
          onTap: () {
            Get.back();
            // appBarController.resetToDefault();
            // Get.until((route) => route.settings.name == Routes.kidBase);
          },
          baseColor: AppColors.btnColorGreen,
        ),
      ],
    );
  }

  void showGoalCompletedDialog(double amount) {
    KidDialog.show(
      emoji: Assets.icTrophy,
      title: 'You Did It!',
      subtitle:
          'Congratulations, ${appState.currentKid.value!.name}, You\'ve reached\nyour savings goal ${amount.toMoneyFormat()}',


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

  void handleExcessAmount(GoalModel goal, double excessAmount) async {
    try {
      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      showLoadingDialog("Updating Goal...");

      // Update the goal with target amount as saved amount
      final updatedGoal = goal.copyWith(
        savedAmount: goal.targetAmount,
        status: GoalStatus.completed,
        completedAt: DateTime.now(),
      );
      await _goalService.updateGoal(updatedGoal);

      // Return excess amount to spending jar
      final newSpendingBalance = kid.wallet.spendingJar.balance + excessAmount;
      await _kidService.updateSpendingJar(kid.kidId, newSpendingBalance);

      // Show success message

      ToastUtil.showToast(
          '${excessAmount.toMoneyFormat()}€ returned to spending jar');

      // Show completion dialog
      showGoalCompletedDialog(goal.targetAmount);

      Get.back(); // Close loading dialog
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.back();
      Get.log(e.toString(), isError: true);
    }
  }

  DateTime? _screenStartTime;
  @override
  void onInit() {
    super.onInit();
    _screenStartTime = DateTime.now();
    logScreenTime();
    appBarController.resetToDefault();
  }

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(
          AnalyticsScreenNames.kidGoalsScreen, durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.kidGoalsScreen,
    );
  }

  Future<bool> hasEnoughBalance(double amount) async {
    // Get the current kid
    final kid = appState.currentKid.value;
    if (kid == null) {
      return false;
    }
    
    // Get the current spending jar balance
    final spendingBalance = kid.wallet.spendingJar.balance;
    
    // Return true if we have enough balance
    return spendingBalance >= amount;
  }
}
