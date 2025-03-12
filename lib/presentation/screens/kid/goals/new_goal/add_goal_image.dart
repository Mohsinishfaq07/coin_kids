import 'dart:io';

import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddGoalImageScreen extends GetView<KidGoalsController> {
  const AddGoalImageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: KidAppBarComponent(
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(image: AssetImage(Assets.kidBg), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            Text(
              'Add a Image for you Goal📸',
              style: AppTextStyle.headingLarge,
            ),
            Expanded(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 152.w,
                    ),
                    Obx(
                      () {
                        return Container(
                          width: 0.4.sw,
                          height: 0.6.sh,
                          decoration: BoxDecoration(
                            color: AppColors.iconOnPrimary,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: controller.newGoal.value.photo == null || controller.newGoal.value.photo!.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.icCamera,
                                      height: 40.h,
                                      width: 40.h,
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
                                          fit: BoxFit.contain,
                                          height: 0.5.sh,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: KidButton.iconOnly(
                                        onTap: () {
                                          controller.removePhoto();
                                        },
                                        baseColor: AppColors.btnColorOrange,
                                        iconPath: Assets.icCross,
                                        size: 30.w,
                                        iconSize: 16.w,
                                      ),
                                      right: 0,
                                    )
                                  ],
                                ),
                        );
                      },
                    ),
                    Obx(
                      () {
                        return Padding(
                          padding: EdgeInsets.only(right: 24.w, bottom: 6.h),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: KidButton(
                              onTap: () async {
                                controller.screenMode.value = GoalSummaryScreenMode.create;
                                Get.to(() => GoalSummaryScreen());
                              },
                              baseColor: controller.newGoal.value.photo != null || controller.newGoal.value.photo!.isNotEmpty ? AppColors.btnColorGreen : AppColors.btnColorOrange,
                              text: controller.newGoal.value.photo != null || controller.newGoal.value.photo!.isNotEmpty ? 'Next' : 'Skip',
                              iconPath: Assets.icNext,
                              iconPosition: IconPosition.right,
                            ),
                          ),
                        );
                      },
                    )
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
