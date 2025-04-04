import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class GoalProgressWidget extends GetView<KidGoalsController> {
  const GoalProgressWidget(this.goal, {super.key});

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.progressValue.value = goal.savedAmount;
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),
          Center(
            child: Text(
              'Goal Progress',
              style: AppTextStyle.headingMedium,
            ),
          ),
          SizedBox(height: 16.h),
          // Slider with +/- buttons
          Row(
            children: [
              KidButton.iconOnly(
                size: 32.w,
                iconSize: 4.w,
                baseColor: AppColors.btnColorRed,
                iconPath: Assets.icMinus,
                onTap: () => controller.decrementProgress(goal),
              ),
              Expanded(
                child: Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 12.w),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       _buildProgressFlag(Assets.icGoalYellow),
                    //       _buildProgressFlag(Assets.icFlagBlue),
                    //       _buildProgressFlag(Assets.icFlagGreen),
                    //     ],
                    //   ),
                    // ),
                    Obx(
                      () {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SfSliderTheme(
                              data: SfSliderThemeData(
                                activeTrackHeight: 15.h,
                                inactiveTrackHeight: 15.h,
                                trackCornerRadius: 50.r,
                                activeTrackColor: AppColors.btnColorOrange,
                                inactiveTrackColor: AppColors.btnColorOrange
                                    .withValues(alpha: 0.2),
                                thumbColor: Colors.transparent,
                                thumbRadius: 15.r,
                              ),
                              child: SfSlider(
                                value: controller.progressValue.value,
                                min: 0,
                                max: goal.targetAmount,
                                interval: goal.targetAmount / 4,
                                stepSize: controller.progressStep,
                                showDividers: true,
                                shouldAlwaysShowTooltip: true,
                                tooltipTextFormatterCallback: (_, text) {
                                  return double.parse(text).toMoneyFormat();
                                },
                                labelFormatterCallback: (_, text) {
                                  return double.parse(text).toMoneyFormat();
                                },
                                onChanged: (value) =>
                                    controller.updateProgress(value),
                                showLabels: true,
                                showTicks: true,
                                enableTooltip: true,
                                thumbIcon: SvgPicture.asset(Assets.icCoinEuro),
                              ),
                            ),
                            Positioned(
                              left: 18.w,
                              right: 0,
                              top: -8.h,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.icGoalYellow,
                                      width: 24.w,
                                    ),
                                    SvgPicture.asset(
                                      Assets.icFlagBlue,
                                      width: 24.w,
                                    ),
                                    SvgPicture.asset(
                                      Assets.icFlagGreen,
                                      width: 24.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              KidButton.iconOnly(
                size: 32.w,
                iconSize: 14.w,
                baseColor: AppColors.btnColorGreen,
                iconPath: Assets.icAdd,
                onTap: () => controller.incrementProgress(goal),
              ),
            ],
          ),
          Spacer(),
          // Edit and Delete buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    children: <Widget>[
                      KidButton.iconWithTitle(
                        size: 50,
                        title: "Edit",
                        belowTextStyle: TextStyle(color: AppColors.textPrimary),
                        baseColor: AppColors.btnColorGreen,
                        iconPath: Assets.icEdit,
                        onTap: () {
                          if (goal.productUrl != null &&
                              goal.productUrl!.isNotEmpty) {
                            ToastUtil.showToast(
                                "Market goals cannot be edited");
                            return;
                          }
                          controller.screenMode.value =
                              GoalSummaryScreenMode.edit;
                          controller.newGoal.value = goal;
                          controller.oldGoal.value = goal;
                          Get.toNamed(Routes.kidGoalSummary);
                        },
                      ),
                      SizedBox(width: 40.w),
                      KidButton.iconWithTitle(
                        size: 50,
                        title: "Delete",
                        belowTextStyle: TextStyle(color: AppColors.textPrimary),
                        baseColor: AppColors.critical,
                        iconPath: Assets.icBin,
                        onTap: () => _showDeleteDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
              KidButton(
                text: 'Done',
                baseColor: AppColors.btnColorGreen,
                iconPath: Assets.icTick,
                // onTap: () => controller.saveProgress(goal.id!),
                onTap: () {
                  // Calculate percentage achieved
                  double progressPercentage =
                      (controller.progressValue.value / goal.targetAmount) *
                          100;
                  int rewardCoins = 0;

                  // Check milestones and assign rewards
                  if (progressPercentage >= 100) {
                    rewardCoins = 10; // 100% milestone
                  } else if (progressPercentage >= 75) {
                    rewardCoins = 3; // 75% milestone
                  } else if (progressPercentage >= 50) {
                    rewardCoins = 2; // 50% milestone
                  } else if (progressPercentage >= 25) {
                    rewardCoins = 2; // 25% milestone
                  }

                  // Save progress and award coins if milestone reached
                  controller.saveProgress(goal.id!, rewardCoins: rewardCoins);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    KidDialog.show(
      dismissible: true,
      emoji: Assets.icCoinStar,
      title: "Delete Goal?",
      subtitle: "Are you sure you want to delete this goal?",
      buttons: [
        KidButton(
          text: "No",
          onTap: () {
            Get.back();
          },
          baseColor: AppColors.btnColorOrange,
          iconPath: Assets.icCross,
          iconPosition: IconPosition.left,
        ),
        SizedBox(width: 16.w),
        KidButton(
          text: "Yes",
          onTap: () async {
            await controller.deleteGoal(goal.id!);
          },
          baseColor: AppColors.btnColorGreen,
          iconPath: Assets.icTick,
          iconPosition: IconPosition.left,
        ),
      ],
    );
  }
}
