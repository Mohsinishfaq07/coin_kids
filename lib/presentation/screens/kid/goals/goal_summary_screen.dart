import 'dart:io';

import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/cached_network_image_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

enum GoalSummaryScreenMode {
  create, // Creating a new goal
  edit, // Editing existing goal
}

class GoalSummaryScreen extends GetView<KidGoalsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: KidAppBarComponent(
        onBackPressed: () => Get.back(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 0.35.sw,
              child: _buildImageSection(),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildFormSection(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 1.sh,
      width: 0.4.sw,
      child: Align(
        alignment: Alignment.center,
        child: Obx(() {
          return Container(
            height: 0.7.sh,
            width: 0.3.sw,
            decoration: BoxDecoration(
              color: AppColors.iconOnPrimary,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.colorPrimary, width: 2),
            ),
            child: controller.newGoal.value.photo == null || controller.newGoal.value.photo!.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
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
                          baseColor: Color(0xFFFF9E29),
                          text: 'Add Photo',
                          iconPath: Assets.icAdd,
                          iconPosition: IconPosition.left,
                        ),
                      ],
                    ),
                  )
                : Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: controller.newGoal.value.photo!.startsWith("https://")
                              ? CachedNetworkImageWidget(
                                  imageUrl: controller.newGoal.value.photo!,
                                  height: 0.5.sh,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
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
                              ToastUtil.showToast("Clicked");
                              controller.removePhoto();
                            },
                            baseColor: AppColors.btnColorOrange,
                            iconPath: Assets.icCross,
                            size: 30.w,
                            iconSize: 16.w,
                          ),
                          right: -10,
                          top: -10)
                    ],
                  ),
          );
        }),
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              Text('Goal Name', style: AppTextStyle.headingSmall),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: KidTextField(
                  hintText: controller.newGoal.value.title,
                  onChange: (value) => controller.newGoal.value.copyWith(title: value.trim()),
                ),
              ),
              Text('Amount', style: AppTextStyle.headingSmall),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: KidTextField(
                  keyboardType: TextInputType.number,
                  hintText: controller.newGoal.value.targetAmount.toString(),
                  onChange: (value) => controller.newGoal.value.copyWith(targetAmount: double.tryParse(value) ?? 0.0),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: KidButton(
            onTap: () => _handleButtonPress(),
            text: _getButtonText(),
            baseColor: AppColors.btnColorGreen,
            iconPath: Assets.icTick,
            iconPosition: IconPosition.left,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  String _getButtonText() {
    switch (controller.screenMode.value) {
      case GoalSummaryScreenMode.create:
        return 'Create Goal';
      case GoalSummaryScreenMode.edit:
        return 'Save Changes';
    }
  }

  void _handleButtonPress() {
    switch (controller.screenMode.value) {
      case GoalSummaryScreenMode.create:
        controller.createNewGoal();
        break;
      case GoalSummaryScreenMode.edit:
        controller.updateGoal();
        break;
    }
  }
}
