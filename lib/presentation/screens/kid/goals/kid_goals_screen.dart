import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../goals/widgets/goal_card.dart';
import 'new_goal/add_goal_name.dart';
import 'widgets/no_goals_widget.dart';

class KidGoalsScreen extends GetView<KidGoalsController> {
  final String currentKidId;

  const KidGoalsScreen({required this.currentKidId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.startListeningToGoals(currentKidId);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final int crossAxisCount = _calculateCrossAxisCount(screenWidth);
        final double cardWidth = (screenWidth - (crossAxisCount + 1) * 8.w) / crossAxisCount;
        final double cardHeight = cardWidth * 1.35;

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.goals.isEmpty) {
                    return const NoGoalsWidget();
                  }

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 4.h,
                      bottom: 20.h,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: cardWidth / cardHeight,
                    ),
                    itemCount: controller.goals.length,
                    itemBuilder: (context, index) {
                      final goal = controller.goals[index];
                      return GoalCard(goal: goal);
                    },
                  );
                }),
              ),
              // Add Goal Button
              Obx(() {
                return Visibility(
                  visible: controller.goals.isNotEmpty,
                  child: Positioned(
                    bottom: 8.h,
                    right: 16.w,
                    child: KidButton(
                      baseColor: AppColors.btnColorOrange,
                      text: 'Add Goal',
                      onTap: () => Get.to(() => AddGoalNameScreen()),
                      iconPath: Assets.icAdd,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    final double targetCardWidth = 180.w;
    int count = (screenWidth / targetCardWidth).floor();
    return count.clamp(2, 4);
  }
}
