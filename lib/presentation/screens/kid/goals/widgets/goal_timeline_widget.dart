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

  GoalTimelineWidget({
    required this.goal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<TimelineItem> items = [
      TimelineItem(
        date: goal.completedAt.toString(),
        title: "Congratulations!",
        subtitle: "You completed PlayStation 5",
        photo: Assets.icBadge,
        imageType: ImageType.asset,
        isCompleted: true,
      ),
      TimelineItem(
        date: "08/04",
        title: "Need Moms review",
        subtitle: "let's mom order it for you",
        photo: controller.appState.currentParent.value?.imageUrl ?? "",
        imageType: ImageType.network,
      ),
      TimelineItem(
        date: "10/04",
        title: "Expected delivery",
        subtitle: "Yohoo! you will get is soon",
        photo: Assets.icFlagGreen,
        imageType: ImageType.asset,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(
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
