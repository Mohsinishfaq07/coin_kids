import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/screens/kid/goals/widgets/custom_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/color_theme.dart' show AppColors;

class GoalTimelineWidget extends GetView<KidGoalsController> {
  final GoalModel goal;

  const GoalTimelineWidget({
    required this.goal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<TimelineItem> items = [
      if (goal.status == GoalStatus.completed ||
          goal.status == GoalStatus.approved || goal.status == GoalStatus.rejected )
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
        child: Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: Center(
            child: SingleChildScrollView(
              child: CustomTimeline(items: items),
            ),
          ),
        ),
      ),
    );
  }
}
