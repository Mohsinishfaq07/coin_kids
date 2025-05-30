import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/add_child_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddChildScreen extends GetView<AddChildController> {
  final _formKey = GlobalKey<FormState>();
  final _ageNode = FocusNode();

  AddChildScreen({super.key});

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
      resizeToAvoidBottomInset: false,
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
            "Add child",
            style: AppTextStyle.appButton,
          ),
          onPressed: () async {
            if (controller.isLoading.value) return;

            if (_formKey.currentState?.validate() ?? false) {
              await controller.createKid(true);
              print("Child added successfully");
            }
          },
        ),
      ),
      appBar:  ParentAppBar(
        onBackPressed: ()async{
          await controller.analytics.logAddChildDiscard(AnalyticsScreenNames.parentAddKidScreen);
          Get.back();

        },
        showBackButton: true,
        title: "Add your child",
        centerTitle: false,
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: MediaQuery.of(context).size.height * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Child Name Field
                      ParentTextField(
                        textInputAction: TextInputAction.next,
                        maxLength: 8,
                        titleText: "Child name",
                        hintText: "Enter your child name",
                        onChanged: (value) => controller.childName.value = value.trim(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter child name';
                          }
                          return null;
                        },
                      ),
                      // SizedBox(height: MediaQuery.of(context).size.height *0.02.h),

                      // Child Age Field
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                        child: ParentTextField(
                          maxLength: 2,
                          titleText: "Age",
                          hintText: "Enter child's age",
                          focusNode: _ageNode,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => controller.childAge.value = value.trim(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter child age';
                            }

                            final intValue = int.tryParse(value);
                            if (intValue == null) {
                              return 'Please enter a valid number';
                            }

                            if (intValue < 3 || intValue > 14) {
                              return 'Age must be between 3 to 14 years';
                            }

                            return null;
                          },
                        ),
                      ),
                      // SizedBox(height: 19.h),
                      // SizedBox(height: MediaQuery.of(context).size.height *0.02.h),

                      // Avatar Selection Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select Avatar",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Avatar Selection
                      _buildAvatarGrid(context),

                      // Add Child Button
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
    FocusScope.of(context).unfocus();
    ImagePickerBottomSheet.show(
      onCameraTap: () => controller.pickImage(source: ImageSource.camera),
      onGalleryTap: () => controller.pickImage(source: ImageSource.gallery),
    );
  }

  Widget _buildAvatarGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAvatars.value) {
        return Center(
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
            // Camera/Gallery picker option
            return Obx(() => GestureDetector(
                  onTap: () => _showImagePicker(context),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.kidImagePath.value.isNotEmpty ? AppColors.colorPrimary : Colors.transparent,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                    child: controller.kidImagePath.value.isNotEmpty
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60.r),
                                child: Image.file(
                                  File(controller.kidImagePath.value),
                                  height: 60.w,
                                  width: 60.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (controller.selectedAvatar.value == -1)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60.r),
                                    color: Colors.black38,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: AppColors.iconPrimary,
                              borderRadius: BorderRadius.circular(60.r),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                  ),
                ));
          }

          // Predefined avatars
          final avatarIndex = index - 1;
          return Obx(
            () => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                controller.selectAvatar(avatarIndex);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedAvatar.value == avatarIndex ? AppColors.colorPrimary : Colors.transparent,
                    width: 2.w
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
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            color: AppColors.iconPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(60.r),
                          ),
                          child: Icon(
                            Icons.error_outline,
                            color: AppColors.iconPrimary,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                    if (controller.selectedAvatar.value == avatarIndex)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          color: Colors.black38,
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
            ),
          );
        },
      );
    });
  }
}
