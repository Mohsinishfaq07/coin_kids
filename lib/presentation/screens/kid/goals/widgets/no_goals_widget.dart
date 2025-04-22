import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/common/hand_pointer_overlay.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoGoalsWidget extends StatelessWidget {
  NoGoalsWidget({super.key}) {
    _checkTutorialState();
  }

  final GlobalKey _addGoalKey = GlobalKey();
  final RxBool showPointer = true.obs;

  Future<void> _checkTutorialState() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenNoGoalsTutorial) ?? false;
    showPointer.value = !hasSeenTutorial;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Text(
                      'Create a saving goal! 🎯',
                      style: AppTextStyle.headingLarge,
                    ),
                    SizedBox(height: 18.h),
                    KidButton(
                      key: _addGoalKey,
                      baseColor: AppColors.btnColorOrange,
                      text: 'Add new Goal',
                      iconPath: Assets.icAdd,
                      iconPosition: IconPosition.left,
                      onTap: () {
                        showPointer.value = false;
                        SharedPreferencesHelper.saveBool(
                          SharedPreferencesHelper.hasSeenNoGoalsTutorial,
                          true,
                        );
                        Get.toNamed(Routes.kidAddGoalName);
                      },
                    ),
                    SizedBox(height: 18.h),
                  ],
                ),
                Obx(() {
                  if (showPointer.value) {
                    return Positioned(
                      top: 60.h,
                      left: 60.w,
                      right: 0,
                      child: HandPointerOverlay(
                        targetKey: _addGoalKey,
                        onTap: () async {
                          showPointer.value = false;
                          await SharedPreferencesHelper.saveBool(
                            SharedPreferencesHelper.hasSeenNoGoalsTutorial,
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
          ),
        ],
      ),
    );
  }
}
