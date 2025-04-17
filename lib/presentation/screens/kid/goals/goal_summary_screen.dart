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
  const GoalSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   //   extendBodyBehindAppBar: true,
      // appBar: KidAppBarComponent(
      //   onBackPressed: () => Get.back(),
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(

            children: [
              KidAppBarComponent(
                onBackPressed: () => Get.back(),
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSection(),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildFormSection(),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Obx(() {
      return Padding(
        padding:  EdgeInsets.all(12.h),
        child: Container(
          // height: 0.7.sh,
          // width: 0.3.sw,

          decoration: BoxDecoration(
            color: AppColors.iconOnPrimary,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.cardBorder, width: 2.w),
          ),
          child: controller.newGoal.value.photo == null ||
                  controller.newGoal.value.photo!.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: controller.pickImageFromCamera,
                        child: SvgPicture.asset(
                          Assets.icCamera,
                          height: 64.r,
                          width: 64.r,
                        ),
                      ),
                      SizedBox(height: 20.h),
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
                        borderRadius: BorderRadius.circular(12.r),
                        child: SizedBox(
                          width: 0.3.sw,
                          height: 0.46.sh,
                          child: controller.newGoal.value.photo!.startsWith("http") 
                              ? CachedNetworkImageWidget(
                                  imageUrl: controller.newGoal.value.photo!,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(controller.newGoal.value.photo!),
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                        right: -10,
                        top: -10,
                        child: KidButton.iconOnly(
                          onTap: () {
                            ToastUtil.showToast("Clicked");
                            controller.removePhoto();
                          },
                          baseColor: AppColors.btnColorOrange,
                          iconPath: Assets.icCross,
                          size: 30.w,
                          iconSize: 16.w,
                        ))
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 16.h),
        Text('Goal Name', style: AppTextStyle.headingSmall),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: KidTextField(
            hintText: controller.newGoal.value.title,
            onChange: (value) {
              // Remove initial spaces but keep other spaces
              String processedValue = value;
              while (processedValue.startsWith(' ')) {
                processedValue = processedValue.substring(1);
              }
              controller.setTitle(processedValue);
            },
          ),
        ),
        Text('Amount', style: AppTextStyle.headingSmall),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: KidTextField(
            maxlength: 8,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            hintText: controller.newGoal.value.targetAmount.toString(),
            onChange: (value) {
              controller.setAmount(double.tryParse(value) ?? 0.0);
            },
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
    // Validate goal name is not empty
    if (controller.newGoal.value.title.isEmpty) {
      ToastUtil.showToast("Goal name cannot be empty");
      return;
    }

    // Check if goal name starts with a space
    if (controller.newGoal.value.title.startsWith(' ')) {
      ToastUtil.showToast("Goal name cannot start with a space");
      return;
    }

    // Validate amount
    if (controller.newGoal.value.targetAmount < 0.01) {
      ToastUtil.showToast("Amount must be at least 0.01");
      return;
    }

    switch (controller.screenMode.value) {
      case GoalSummaryScreenMode.create:
        controller.createNewGoal();
        print("button called createNewGoal");
        break;
      case GoalSummaryScreenMode.edit:
        controller.updateGoal();
        print("button called updateGoal");
        break;
    }
  }
}
