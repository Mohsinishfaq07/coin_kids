import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/edit_child_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditChildScreen extends GetView<EditChildController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        title: "Edit Profile",
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Child Name Field
                  Obx(() {
                    return CustomTextField(
                      maxLength: 8,
                      initialValue: controller.childName.value,
                      hintText: controller.childName.value,
                      onChanged: (value) => controller.childName.value = value.trim(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter child name';
                        }
                        return null;
                      },
                    );
                  }),
                  SizedBox(height: 16.h),

                  // Child Age Field
                  Obx(() {
                    return CustomTextField(
                      initialValue: controller.childAge.value,
                      hintText: controller.childAge.value,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.childAge.value = value.trim(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter child age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    );
                  }),
                  SizedBox(height: 19.h),

                  // Avatar Selection Title
                  Text(
                    "Select Avatar",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  SizedBox(height: 12.h),

                  // Avatar Selection
                  SizedBox(height: 450.h, child: _buildAvatarGrid(context)),

                  // Add Child Button
                  Center(
                    child: Obx(() => AppButton(
                          text: controller.isLoading.value ? "Updating Child..." : "Update Child",
                          onPressed: () async {
                            if (controller.isLoading.value) return;

                            if (_formKey.currentState?.validate() ?? false) {
                              await controller.updateKid();
                            }
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    ImagePickerBottomSheet.show(
      onCameraTap: () => controller.pickImage(source: ImageSource.camera),
      onGalleryTap: () => controller.pickImage(source: ImageSource.gallery),
    );
  }

  Widget _buildAvatarGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAvatars.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: controller.avatars.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Camera/Gallery picker or custom avatar display
            return GestureDetector(
              onTap: () => _showImagePicker(context),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isCustomImageSelected() ? Colors.purple : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(60.r),
                ),
                child: _buildCustomAvatarWidget(),
              ),
            );
          }

          // Predefined avatars
          final avatarIndex = index - 1;
          return Obx(
            () => GestureDetector(
              onTap: () => controller.selectAvatar(avatarIndex),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedAvatar.value == avatarIndex ? Colors.purple : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(60.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60.r),
                      child: CachedNetworkImage(
                        imageUrl: controller.avatars[avatarIndex],
                        height: 60.h,
                        width: 60.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.buttonPrimary,
                          ),
                        ),
                        errorWidget: (context, url, error) => _buildErrorWidget(),
                      ),
                    ),
                    if (controller.selectedAvatar.value == avatarIndex) _buildSelectedOverlay(),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  bool _isCustomImageSelected() {
    return controller.kidImagePath.value.isNotEmpty || (controller.originalAvatar.isNotEmpty && controller.selectedAvatar.value == -1);
  }

  Widget _buildCustomAvatarWidget() {
    // Show new picked image
    if (controller.kidImagePath.value.isNotEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60.r),
            child: Image.file(
              File(controller.kidImagePath.value),
              height: 60.h,
              width: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          if (_isCustomImageSelected()) _buildSelectedOverlay(),
        ],
      );
    }

    // Show existing custom avatar from network
    if (controller.originalAvatar.isNotEmpty && !controller.avatars.contains(controller.originalAvatar)) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60.r),
            child: CachedNetworkImage(
              imageUrl: controller.originalAvatar,
              height: 60.h,
              width: 60.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.buttonPrimary,
                ),
              ),
              errorWidget: (context, url, error) => _buildErrorWidget(),
            ),
          ),
          if (_isCustomImageSelected()) _buildSelectedOverlay(),
        ],
      );
    }

    // Show camera icon for picking new image
    return Container(
      decoration: BoxDecoration(
        color: AppColors.iconPrimary,
        borderRadius: BorderRadius.circular(60.r),
      ),
      child: Icon(
        Icons.add_a_photo,
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }

  Widget _buildSelectedOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        color: Colors.black38,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.iconPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(60.r),
      ),
      child: Icon(
        Icons.error_outline,
        color: AppColors.iconPrimary,
        size: 24.sp,
      ),
    );
  }
}
