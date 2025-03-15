import 'package:coin_kids/presentation/components/parent/empty_state.dart';
import 'package:coin_kids/presentation/components/parent/goal_list_item.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalsTabWidget extends GetView<KidProfileController> {
  const GoalsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () {
          if (controller.isGoalsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.goals.isEmpty) {
            return buildGoalsEmptyState(() {});
          }

          return ListView.builder(
            itemCount: controller.goals.length,
            itemBuilder: (context, index) {
              var goalData = controller.goals[index];

              return GoalListItem(
                goal: goalData,
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
