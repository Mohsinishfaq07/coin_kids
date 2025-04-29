import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../goals/widgets/goal_card.dart';
import 'widgets/no_goals_widget.dart';

class KidGoalsScreen extends GetView<KidGoalsController> {
  final String currentKidId;

  KidGoalsScreen({required this.currentKidId, super.key}) {
    _checkTutorialState();
  }

  final RxBool showPointer = true.obs;

  Future<void> _checkTutorialState() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenGoalsListTutorial) ?? false;
    showPointer.value = !hasSeenTutorial;
  }

  @override
  Widget build(BuildContext context) {
    controller.startListeningToGoals(currentKidId);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final int crossAxisCount = _calculateCrossAxisCount(screenWidth);
        final double cardWidth =
            (screenWidth - (crossAxisCount + 1) * 7.w) / crossAxisCount;
        final double cardHeight = cardWidth * 1.2.h;

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.goals.isEmpty  ) {
                    return NoGoalsWidget();
                  }

                  return Stack(
                    children: [
                      GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 4.h,
                          bottom: 20.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 6.w,
                          mainAxisSpacing: 8.h,
                          childAspectRatio: cardWidth / cardHeight,
                        ),
                        itemCount: controller.goals.length,
                        itemBuilder: (context, index) {
                          final goal = controller.goals[index];
                          return GoalCard(
                            key: index == 0 ? GlobalKeys.firstGoalKey : null,
                            goal: goal,
                            isConnected:
                                controller.currentKid.value?.isConnected ?? false,
                          );
                        },
                      ),
                      Obx(() {
                        if (controller.showPointer.value && controller.goals.isNotEmpty) {
                          return Positioned(
                            left: 80.w,
                             top: 20,
                             bottom: 10.h,
                            child: HandPointerOverlay(
                              targetKey: GlobalKeys.firstGoalKey,
                              onTap: () async {
                                controller.showPointer.value = false;
                                await SharedPreferencesHelper.saveBool(
                                  SharedPreferencesHelper.hasSeenGoalsListTutorial,
                                  true,
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
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
                      onTap: () => Get.toNamed(Routes.kidAddGoalName),
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
    final double targetCardWidth = 150.w;
    int count = (screenWidth / targetCardWidth).floor();
    return count.clamp(2, 5);
  }
}
