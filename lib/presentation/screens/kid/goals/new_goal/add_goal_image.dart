import 'dart:io';

import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_summary_screen.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddGoalImageScreen extends GetView<KidGoalsController> {
  AddGoalImageScreen({super.key}) {
    _checkTutorialState();
  }
  void _calculatePointerPosition() {
    final RenderBox? renderBox = GlobalKeys.nextButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      // Calculate the position for the pointer (center-right of the arrow)
      final pointerX = position.dx + size.width - 30.w;
      final pointerY = position.dy + (size.height / 2) - 30.h;

      controller.pointerPosition.value = Offset(pointerX, pointerY);
    }
  }


  final RxBool showPointer = true.obs;

  Future<void> _checkTutorialState() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenGoalImageTutorial) ?? false;
    showPointer.value = !hasSeenTutorial;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePointerPosition();
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: 24.w,
          bottom: 24.w,
          left: 24.w,
        ),
        child: GestureDetector(
          onTap: () async {
            showPointer.value = false;
            await SharedPreferencesHelper.saveBool(
              SharedPreferencesHelper.hasSeenGoalImageTutorial,
              true,
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    return KidButton(
                      key:  GlobalKeys.nextButtonKey,
                      onTap: () async {
                        showPointer.value = false;
                        await SharedPreferencesHelper.saveBool(
                          SharedPreferencesHelper.hasSeenGoalImageTutorial,
                          true,
                        );
                        controller.screenMode.value = GoalSummaryScreenMode.create;
                        Get.toNamed(Routes.kidGoalSummary);
                      },
                      baseColor: controller.newGoal.value.photo != null || controller.newGoal.value.photo!.isNotEmpty ? AppColors.btnColorGreen : AppColors.btnColorOrange,
                      text: controller.newGoal.value.photo != null || controller.newGoal.value.photo!.isNotEmpty ? 'Next' : 'Skip',
                      iconPath: Assets.icNext,
                      iconPosition: IconPosition.right,
                    );
                  }),
                ],
              ),
              Obx(() {
                if (showPointer.value) {
                  return Positioned(
                    right: 6.w,
                    bottom: 0.h,
                    child: HandPointerOverlay(
                      targetKey: GlobalKeys.nextButtonKey,
                      onTap: () async {
                        showPointer.value = false;
                        await SharedPreferencesHelper.saveBool(
                          SharedPreferencesHelper.hasSeenGoalImageTutorial,
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
      ),
      appBar: KidAppBarComponent(
        onBackPressed: () {
          Get.back();
        },
      ),
      body: GestureDetector(
        onTap: () async {
          showPointer.value = false;
          await SharedPreferencesHelper.saveBool(
            SharedPreferencesHelper.hasSeenGoalImageTutorial,
            true,
          );
        },
        child: Stack(

          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.background,
                image: const DecorationImage(
                  image: AssetImage(Assets.kidBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenUtil().statusBarHeight + 60.h),
                    Center(
                      child: Text(
                        'Add a Image for you Goal📸',
                        style: AppTextStyle.headingLarge,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Obx(
                      () => Container(
                        constraints: BoxConstraints(maxWidth: 0.6.sw),
                        padding: REdgeInsets.symmetric(vertical: 24, horizontal: 48),
                        decoration: BoxDecoration(
                          color: AppColors.iconOnPrimary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: controller.newGoal.value.photo == null || controller.newGoal.value.photo!.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: controller.pickImageFromCamera,
                                    child: SvgPicture.asset(
                                      Assets.icCamera,
                                      height: 64.r,
                                      width: 64.r,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  KidButton(
                                    onTap: () async {
                                      await controller.pickFromGallery();
                                    },
                                    baseColor: AppColors.btnColorOrange,
                                    text: 'Add Photo',
                                    iconPath: Assets.icAdd,
                                    iconPosition: IconPosition.left,
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Image.file(
                                        File(controller.newGoal.value.photo!),
                                        fit: BoxFit.cover,
                                        height: 0.5.sh,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: KidButton.iconOnly(
                                      onTap: () {
                                        controller.removePhoto();
                                      },
                                      baseColor: AppColors.btnColorOrange,
                                      iconPath: Assets.icCross,
                                      size: 30.w,
                                      iconSize: 16.w,
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
