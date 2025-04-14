import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/base/kid_onboarding_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidAvatarScreen extends GetView<KidOnboardingController> {
  const KidAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KidOnboardingBaseScreen(
      showBackButton: true,
      onBackPressed: () => controller.currentStep.value = OnboardingStep.age,
      title: 'Pick an avatar',
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left spacer (same width as button)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(width: 120.w),
          ),

          // Center GridView
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = 70.w;
                  final availableWidth = constraints.maxWidth;
                  final crossAxisCount = (availableWidth / (itemWidth + 16.w)).floor();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 1,
                    ),
                    itemCount: controller.avatars.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCameraOption();
                      }
                      return _buildAvatarOption(index - 1);
                    },
                  );
                },
              );
            }),
          ),
          // Right button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: KidButton(
              onTap: controller.completeOnboarding,
              text: 'Done',
              baseColor: AppColors.btnColorGreen,
              // width: 120.w,
              iconPath: Assets.icTick,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraOption() {
    return Obx(() {
      if (controller.customImagePath.isNotEmpty) {
        return GestureDetector(
          onTap: _showImagePicker,
          child: Container(
            height: 70.h,
            width: 70.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.colorPrimary,
                width: 2,
              ),
              image: DecorationImage(
                image: FileImage(File(controller.customImagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }

      return GestureDetector(
        onTap: _showImagePicker,
        child: Container(
          height: 70.h,
          width: 70.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.colorPrimary,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.camera_alt,
            size: 35.h,
            color: AppColors.colorPrimary,
          ),
        ),
      );
    });
  }

  Widget _buildAvatarOption(int index) {
    return Obx(() {
      final isSelected = controller.selectedAvatarIndex == index;
      return GestureDetector(
        onTap: () => controller.selectAvatar(index),
        child: Container(
          height: 70.h,
          width: 70.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.colorPrimary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: controller.avatars[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              if (isSelected)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 35.h,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  void _showImagePicker() {
    ImagePickerBottomSheet.show(
      onCameraTap: controller.takePicture,
      onGalleryTap: controller.pickFromGallery,
    );
  }
}
