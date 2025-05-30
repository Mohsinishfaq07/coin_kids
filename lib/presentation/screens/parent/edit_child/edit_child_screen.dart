import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/edit_child_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class EditChildScreen extends GetView<EditChildController> {
  final _formKey = GlobalKey<FormState>();
  final _ageNode = FocusNode();


  EditChildScreen({super.key});
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _ageNode,
          toolbarButtons: [
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: AppColors.colorPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 20.w,
          right: 20.w,
          top: 2.h,
        ),
        child: AppButton(
          size: Size(0.8.sw, 50),
          child: Text(
            "Save Changes",
            style: AppTextStyle.appButton,
          ),
          onPressed: () async {
            await controller.analytics.buttonClicked(AnalyticsEventNames.saveKidProfileClicked, AnalyticsScreenNames.kidProfileScreen,);

            if (controller.isLoading.value) return;

            if (_formKey.currentState?.validate() ?? false) {
              await controller.updateKid();
            }
          },
        ),
      ),

      appBar:  ParentAppBar(
        showBackButton: true,
        title: "Edit Profile",
        centerTitle: false,
        onBackPressed: ()async{
          Get.back();
          await controller.analytics.backPressClicked( AnalyticsScreenNames.kidProfileScreen);

        },
        
      ),
     
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: KeyboardActions(
            config: _buildConfig(context),

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
                        return ParentTextField(
                          maxLength: 8,
                          initialValue: controller.childName.value,
                          hintText: controller.childName.value,
                          onChanged: (value) =>
                              controller.childName.value = value.trim(),
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
                        return ParentTextField(
                          maxLength: 2,
                          initialValue: controller.childAge.value,
                          hintText: controller.childAge.value,
                          keyboardType: TextInputType.number,
                          inputFormatter: TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              if (newValue.text.isEmpty) {
                                return newValue;
                              }
                              if (RegExp(r'^[0-9]+$').hasMatch(newValue.text)) {
                                return newValue;
                              }
                              return oldValue;
                            },
                          ),
                          onChanged: (value) =>
                              controller.childAge.value = value.trim(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter child age';
                            }
                
                            final intValue = int.tryParse(value);
                            if (intValue == null) {
                              return 'Please enter a valid number';
                            }
                
                            if (intValue < 3 || intValue > 15) {
                              return 'Age must be between 3 to 15 years old';
                            }
                
                            return null;
                          },
                        );
                      }),
                      SizedBox(height: 19.h),
                
                      // Avatar Selection Title
                      Text(
                        "Select Avatar",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp),
                      ),
                      SizedBox(height: 12.h),
                
                      // Avatar Selection
                      _buildAvatarGrid(context),
                

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
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
        physics: const NeverScrollableScrollPhysics(),
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
              onTap: () {
                FocusScope.of(context).unfocus(); // Dismiss keyboard
                _showImagePicker(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isCustomImageSelected()
                        ? AppColors.colorPrimary
                        : Colors.transparent,
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
              onTap: () {
                FocusScope.of(context).unfocus(); // Dismiss keyboard
                controller.selectAvatar(avatarIndex);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedAvatar.value == avatarIndex
                        ? AppColors.colorPrimary
                        : Colors.transparent,
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
                        height: 60.w,
                        width: 60.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.buttonPrimary,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            _buildErrorWidget(),
                      ),
                    ),
                    if (controller.selectedAvatar.value == avatarIndex)
                      _buildSelectedOverlay(),
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
    return controller.kidImagePath.value.isNotEmpty ||
        (controller.originalAvatar.isNotEmpty &&
            controller.selectedAvatar.value == -1);
  }

  Widget _buildCustomAvatarWidget() {
    return Obx(() {
      // Show new picked image from local file
      if (controller.kidImagePath.value.isNotEmpty &&
          !controller.kidImagePath.value.startsWith('http')) {
        print(
            "Displaying local image from path: ${controller.kidImagePath.value}"); // Debug log
        return Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.r),
            border: Border.all(
              color: AppColors.colorPrimary,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(58.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(controller.kidImagePath.value),
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Show image from URL (either newly picked or existing)
      if ((controller.kidImagePath.value.startsWith('http') ||
          (controller.originalAvatar.isNotEmpty &&
              !controller.avatars.contains(controller.originalAvatar)))) {
        final String imageUrl = controller.kidImagePath.value.startsWith('http')
            ? controller.kidImagePath.value
            : controller.originalAvatar;

        return Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.r),
            border: Border.all(
              color: AppColors.colorPrimary,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(58.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.buttonPrimary,
                    ),
                  ),
                  errorWidget: (context, url, error) => _buildErrorWidget(),
                ),
                if (_isCustomImageSelected())
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
              ],
            ),
          ),
        );
      }

      // Show camera icon for picking new image
      return Container(
        width: 60.w,
        height: 60.h,
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
    });
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
        color: AppColors.iconPrimary.withValues(alpha: 0.1),
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
