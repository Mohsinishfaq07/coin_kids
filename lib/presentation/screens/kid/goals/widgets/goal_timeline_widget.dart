import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:coin_kids/presentation/dialogs/kid/parent_pin_dialog.dart';
import 'package:coin_kids/presentation/screens/kid/goals/widgets/custom_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/color_theme.dart' show AppColors;

class GoalTimelineWidget extends GetView<KidGoalsController> {
  final GoalModel goal;

  const GoalTimelineWidget({
    required this.goal,
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    final List<TimelineItem> items = [
      if (goal.status == GoalStatus.completed ||
          goal.status == GoalStatus.approved ||
          goal.status == GoalStatus.rejected)
        TimelineItem(
          date: goal.completedAt.toString(),
          title: "Congratulations!",
          subtitle: "You completed your Goal",
          photo: Assets.icBadge,
          imageType: ImageType.asset,
          isCompleted: true,
        ),
      if (goal.status == GoalStatus.approved)
        TimelineItem(
          date: goal.completedAt.toString(),
          title: "Goal Approved!",
          subtitle: "Your parent has approved your goal",
          photo: controller.appState.currentParent.value?.imageUrl ?? "",
          imageType: ImageType.network,
          isCompleted: true,
        ),
      if (goal.status == GoalStatus.rejected)
        TimelineItem(
          date: goal.completedAt.toString(),
          title: "Goal Rejected",
          subtitle: "Your parent has rejected this goal",
          photo: controller.appState.currentParent.value?.imageUrl ?? "",
          imageType: ImageType.network,
          isCompleted: false,
          isRejected: true,
        ),
      if (goal.status == GoalStatus.completed)
        TimelineItem(
          date: "08/04",
          title: "Parents Review",
          subtitle: "Let your parent buy it for you",
          photo: controller.appState.currentParent.value?.imageUrl ?? "",
          imageType: ImageType.network,
        ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(
            image: AssetImage(Assets.kidBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTimeline(items: items),
                      SizedBox(
                        height: 10.h,
                      ),
                      if (goal.status == GoalStatus.completed)
                        KidButton(
                            onTap: () {
                             // controller.switchToParentMode();
                              ParentPinDialog.show(
                                onPinSubmit: (pin) async {
                                  // Make this async

                                  final birthYear = int.tryParse(pin);
                                  final currentYear = DateTime.now().year;
                                  final age = currentYear - birthYear!;
                                  if (age >= 21 && age <= 80) {
                                    // Update the PIN in parent state
                                    final updatedParent = controller.appState.currentParent.value?.copyWith(pin: pin);
                                    if (updatedParent != null) {
                                      controller.appState.currentParent.value = updatedParent;
                                      Get.back();
                                      controller.switchToParentMode();

                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Please enter a valid birth year (age must be between 21-80)",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }
                                },
                              );
                            },
                            baseColor: AppColors.buttonPrimary,
                            text: "Go to Parent Zone "),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24.h,
              right: 24.w,
              child: goal.status != GoalStatus.completed ? KidButton.iconWithTitle(
                size: 50,
                title: "Delete",
                belowTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,fontWeight: MyFontWeight.semiBold.fontWeight
                ),                  baseColor: AppColors.critical,
                iconPath: Assets.icBin,
                onTap: () => _showDeleteDialog(context),
              ) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
