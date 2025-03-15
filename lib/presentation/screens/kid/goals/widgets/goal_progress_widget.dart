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
          SizedBox(height: 10.h),
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double sliderWidth = constraints.maxWidth - 12.w; // Adjust for padding

                    return Stack(clipBehavior: Clip.none, children: [
                      Obx(() {
                        return Positioned(
                          bottom: 2.h,
                          left: (controller.progressValue.value / 100) * sliderWidth, // Move indicator to thumb position
                          child: GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Enter Value"),
                                  content: TextField(
                                    controller: controller.textController,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (val) {
                                      controller.progressValue.value = double.tryParse(val) ?? 0.0;
                                      controller.textController.text = '';
                                      Get.back();
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        controller.progressValue.value = double.tryParse(controller.textController.text) ?? 0.0;
                                        controller.textController.text = '';
                                        Get.back();
                                      },
                                      child: Text("OK"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                  color: AppColors.buttonSecondary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.r),
                                  ),
                                  border: Border.all(color: AppColors.btnColorOrange, width: 2)),
                              child: Text(controller.progressValue.value.toMoneyFormat()),
                            ),
                          ),
                        );
                      }),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildProgressFlag(Assets.icGoalYellow),
                                _buildProgressFlag(Assets.icFlagBlue),
                                _buildProgressFlag(Assets.icFlagGreen),
                              ],
                            ),
                          ),
                          Obx(() {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 10.h,
                                activeTrackColor: AppColors.colorPrimary,
                                inactiveTrackColor: AppColors.colorPrimary.withValues(alpha: 0.2),
                                thumbColor: AppColors.btnColorOrange,
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
                              ),
                              child: Slider(
                                value: controller.progressValue.value,
                                min: 0,
                                max: goal.targetAmount,
                                onChanged: (value) => controller.updateProgress(value),
                              ),
                            );
                          }),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 15.h),
                                // Container(
                                //   padding: EdgeInsets.symmetric(horizontal: 8.w),
                                //   child: Text("€0"),
                                //   decoration: BoxDecoration(
                                //       color: AppColors.buttonSecondary,
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(50.r),
                                //       ),
                                //       border: Border.all(color: AppColors.btnColorOrange, width: 2)),
                                // ),
                                // Container(
                                //   padding: EdgeInsets.symmetric(horizontal: 4.w),
                                //   decoration: BoxDecoration(
                                //       color: AppColors.buttonSecondary,
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(50.r),
                                //       ),
                                //       border: Border.all(color: AppColors.btnColorOrange, width: 2)),
                                //   child: Text(goal.targetAmount.toMoneyFormat()),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]);
                  },
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
                          controller.screenMode.value = GoalSummaryScreenMode.edit;
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
                onTap: () => controller.saveProgress(goal.id!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressFlag(assetImage) {
    return SvgPicture.asset(
      assetImage,
      width: 28,
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
            Get.until((route) => route.settings.name == Routes.kidBase);
          },
          baseColor: AppColors.btnColorGreen,
          iconPath: Assets.icTick,
          iconPosition: IconPosition.left,
        ),
      ],
    );
  }
}
