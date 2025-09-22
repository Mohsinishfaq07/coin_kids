import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
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
  final GoalModel goal;
  const GoalProgressWidget(this.goal, {super.key});

  @override
  Widget build(BuildContext context) {
    // Do not reset progress here; avoid side-effects during rebuilds

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01.h,
              ),
              Center(
                child: Text(
                  'Goal Progress',
                  style: AppTextStyle.headingMedium,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Obx(
                    () {
                      final double sliderValue =
                          controller.progressValue.value > goal.targetAmount ? goal.targetAmount : controller.progressValue.value;

                      return Stack(
                        key: GlobalKeys.sliderKey,
                        clipBehavior: Clip.none,
                        children: [
                          SfSliderTheme(
                            data: SfSliderThemeData(
                              activeTrackHeight: 15.h,
                              inactiveTrackHeight: 15.h,
                              trackCornerRadius: 50.r,
                              activeTrackColor: AppColors.btnColorOrange,
                              inactiveTrackColor: AppColors.btnColorOrange.withValues(alpha: 0.2),
                              thumbColor: Colors.transparent,
                              thumbRadius: 15.r,
                            ),
                            child: SfSlider(
                              value: sliderValue,
                              min: 0,
                              max: goal.targetAmount,
                              interval: goal.targetAmount / 4,
                              stepSize: controller.progressStep,
                              tooltipTextFormatterCallback: (_, text) {
                                return double.parse(text).toMoneyFormat();
                              },
                              labelFormatterCallback: (_, text) {
                                return double.parse(text).toMoneyFormat();
                              },
                              onChanged: (value) async {
                                await controller.analytics
                                    .buttonClicked(AnalyticsEventNames.goalProgressSliderClicked, AnalyticsScreenNames.kidGoalsProgressScreen);

                                controller.updateProgress(value, goal);
                              },
                              showLabels: true,
                              showTicks: true,
                              enableTooltip: true,
                              showDividers: true,
                              shouldAlwaysShowTooltip: true,
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            belowTextStyle:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: MyFontWeight.semiBold.fontWeight),
                            baseColor: AppColors.btnColorGreen,
                            iconPath: Assets.icEdit,
                            onTap: () async {
                              await controller.analytics.buttonClicked(AnalyticsEventNames.goalProgressEditButtonClicked,
                                  AnalyticsScreenNames.kidGoalsProgressScreen, AnalyticsScreenNames.kidGoalsSummaryScreen);

                              if (goal.productUrl != null && goal.productUrl!.isNotEmpty) {
                                KidDialogWithCross.show(
                                  dismissible: true,
                                  emoji: Assets.emojiSad,
                                  title: "Cannot Edit",
                                  subtitle: "Market goals cannot be edited",
                                  buttons: [
                                    KidButton(
                                      text: "OK",
                                      onTap: () {
                                        Get.back();
                                      },
                                      baseColor: AppColors.btnColorGreen,
                                      iconPath: Assets.icTick,
                                      iconPosition: IconPosition.left,
                                    ),
                                  ],
                                );
                                return;
                              }
                              controller.screenMode.value = GoalSummaryScreenMode.edit;
                              controller.newGoal.value = goal;
                              controller.oldGoal.value = goal;
                              Get.toNamed(Routes.kidGoalSummary, arguments: false.obs);
                            },
                          ),
                          SizedBox(width: 40.w),
                          KidButton.iconWithTitle(
                              size: 50,
                              title: "Delete",
                              belowTextStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: MyFontWeight.semiBold.fontWeight),
                              baseColor: AppColors.critical,
                              iconPath: Assets.icBin,
                              onTap: () async {
                                await controller.analytics.buttonClicked(AnalyticsEventNames.goalProgressDeleteButtonClicked,
                                    AnalyticsScreenNames.kidGoalsProgressScreen, AnalyticsScreenNames.kidGoalsScreen);
                                _showDeleteDialog(context);
                              }),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      KidButton(
                        key: GlobalKeys.doneButtonKey,
                        text: 'Done',
                        baseColor: AppColors.btnColorGreen,
                        iconPath: Assets.icTick,
                        onTap: () async {
                          await controller.analytics
                              .buttonClicked(AnalyticsEventNames.goalProgressDoneButtonClicked, AnalyticsScreenNames.kidGoalsProgressScreen);

                          // Get the amount to be saved (difference between new and current saved amount)
                          double amountToSave = controller.progressValue.value - goal.savedAmount;

                          // Check if we have sufficient balance before proceeding
                          if (amountToSave > 0 && !await controller.hasEnoughBalance(amountToSave)) {
                            KidDialog.show(
                              dismissible: true,
                              emoji: Assets.emojiSad,
                              title: "Insufficient Funds",
                              subtitle: "You don't have enough money in your spending jar to save this amount.",
                              buttons: [
                                KidButton(
                                  text: "OK",
                                  onTap: () {
                                    Get.back();
                                  },
                                  baseColor: AppColors.btnColorGreen,
                                  iconPath: Assets.icTick,
                                  iconPosition: IconPosition.left,
                                ),
                              ],
                            );
                            return;
                          }

                          // Calculate percentage achieved
                          double progressPercentage = (controller.progressValue.value / goal.targetAmount) * 100;
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
                          await controller.saveProgress(goal.id!, rewardCoins: rewardCoins);
                          controller.progressValueController.clear();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(top: 105.h, left: 0.w, right: 0.w, child: AmountInputRow(key: ValueKey('amount-input-${goal.id}'), goal: goal)),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    KidDialogWithCross.show(
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

class AmountInputRow extends StatefulWidget {
  final GoalModel goal;
  const AmountInputRow({super.key, required this.goal});

  @override
  State<AmountInputRow> createState() => AmountInputRowState();
}

class AmountInputRowState extends State<AmountInputRow> {
    KidGoalsController kidGoalController = Get.find<KidGoalsController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        KidButton.iconOnly(
          size: 32.w,
          iconSize: 14.w,
          baseColor: AppColors.btnColorGreen,
          iconPath: Assets.icAdd,
          onTap: () async {
            await kidGoalController.analytics.buttonClicked(
              AnalyticsEventNames.goalPlusButtonClicked,
              AnalyticsScreenNames.kidGoalsProgressScreen,
            );
            final double amount = double.tryParse(kidGoalController.progressValueController.text) ?? 0;
            if (amount > 0) {
              // 1) Check available funds in spending jar
              final bool hasFunds = await kidGoalController.hasEnoughBalance(amount);
              if (!hasFunds) {
                Get.snackbar(
                  'Insufficient funds',
                  "You don't have enough money in your spending jar.",
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              // 2) Do not exceed remaining target (product price - saved)
              final double current = kidGoalController.progressValue.value;
              final double remaining = (widget.goal.targetAmount - current).clamp(0, widget.goal.targetAmount).toDouble();
              if (amount > remaining) {
                Get.snackbar(
                  'Excessive amount',
                  'Please enter an amount ≤ ${remaining.toStringAsFixed(2)}',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              final next = (current + amount).clamp(0, widget.goal.targetAmount).toDouble();
              kidGoalController.progressValue.value = next;
              // _controller.clear();
            }
          },
        ),
        SizedBox(width: 16.w),
        SizedBox(
          height: 40.h,
          width: 140.w,
          child: TextField(
            controller: kidGoalController.progressValueController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: AppTextStyle.headingMedium.copyWith(
              // 👈 yahan control hoga text ka size
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: "29.11",
              hintStyle: AppTextStyle.headingMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                fontSize: 16.sp,
              ),
              isDense: true, // ✅ yahan adjust karo
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),

              filled: true,
              fillColor: const Color(0xffffffff),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  color: const Color(0xFF848484),
                  width: 1.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  color: const Color(0xFF848484),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  color: AppColors.textPrimary,
                  width: 1.w,
                ),
              ),
            ),
            onSubmitted: (_) {
              // Only dismiss keyboard, do not mutate progress or clear text
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        SizedBox(width: 16.w),
        KidButton.iconOnly(
          size: 32.w,
          iconSize: 4.w,
          baseColor: AppColors.btnColorRed,
          iconPath: Assets.icMinus,
          onTap: () async {
            await kidGoalController.analytics.buttonClicked(
              AnalyticsEventNames.goalMinusButtonClicked,
              AnalyticsScreenNames.kidGoalsProgressScreen,
              AnalyticsScreenNames.kidGoalsScreen,
            );
            final double amount = double.tryParse(kidGoalController.progressValueController.text) ?? 0;
            if (amount > 0) {
              final double current = kidGoalController.progressValue.value;
              if (amount > current) {
                Get.snackbar(
                  'Excessive amount',
                  'You can decrease up to ${current.toStringAsFixed(2)} only.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              final next = (current - amount).clamp(0, widget.goal.targetAmount).toDouble();
              kidGoalController.progressValue.value = next;
              // _controller.clear();
            }
          },
        ),
      ],
    );
  }
}
