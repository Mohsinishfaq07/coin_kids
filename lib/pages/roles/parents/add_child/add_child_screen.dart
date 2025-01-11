import 'dart:io';

import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/theme/components/AppButton.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../theme/color_theme.dart';

class AddChildScreen extends StatelessWidget {
  final AddChildController _controller = Get.put(AddChildController());

  AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        title: "Add your child",
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Child Name Field
                CustomTextField(
                  titleText: "Child name",
                  hintText: "Enter your child name",
                  onChanged: (value) =>
                      _controller.childName.value = value.trim(),
                ),
                SizedBox(height: 16.h),

                // Child Age Field
                CustomTextField(
                  titleText: "Age",
                  hintText: "Enter child's age",
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      _controller.childAge.value = value.trim(),
                ),
                SizedBox(height: 19.h),

                // Avatar Selection Title
                Text(
                  "Select Avatar",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: CustomThemeData().primaryTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp),
                ),
                SizedBox(height: 12.h),

                // Avatar Selection
                SizedBox(
                  height: 450.h,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of items per row
                      crossAxisSpacing: 26.w, // Space between columns
                      mainAxisSpacing: 16.h, // Space between rows
                    ),
                    itemCount: _controller.avatars.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // First item: Custom Avatar Picker
                        return Obx(
                          () => GestureDetector(
                            onTap: () async {
                              await _controller.pickCustomAvatar();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4.h),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundColor: Colors.purple,
                                backgroundImage: _controller
                                        .customAvatarPath.value.isEmpty
                                    ? null
                                    : FileImage(File(
                                        _controller.customAvatarPath.value)),
                                child:
                                    _controller.customAvatarPath.value.isEmpty
                                        ? Center(
                                            child: Image.asset(
                                              "assets/child_avatar_image_pngs/CameraIcon.png",
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Other items: Predefined Avatars
                        final avatarIndex =
                            index - 1; // Adjust index for predefined avatars
                        return Obx(
                          () => GestureDetector(
                            onTap: () {
                              _controller.selectAvatar(avatarIndex);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4.h),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Avatar Image
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            _controller.selectedAvatar.value ==
                                                    avatarIndex
                                                ? Colors.purple
                                                : Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(60.r),
                                    ),
                                    child: Image.asset(
                                      _controller.avatars[avatarIndex],
                                      height:
                                          60.h, // Adjust the size of the avatar
                                      width: 60.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  // Centered Check Icon (only when the avatar is selected)
                                  if (_controller.selectedAvatar.value ==
                                      avatarIndex)
                                    Positioned(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(60.r),
                                            color: Colors.black38,
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24.sp, // Size of the check icon
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

                // Add Child Button
                Center(
                    child: AppButton(
                  text: "Add Child",
                  onPressed: () async {
                    if (!firebaseAuthController.isNormalLoading.value) {
                      firebaseAuthController.isNormalLoading.value = true;
                      await firestoreOperations.parentFirebaseFunctions
                          .addChildAndUpdateParent();
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
