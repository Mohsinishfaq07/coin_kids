import 'dart:io';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/add_child_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddChildScreen extends StatelessWidget {
  final AddChildController _addChildController = Get.put(AddChildController());
  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Child Name Field
                  CustomTextField(
                    maxLength: 8,
                    titleText: "Child name",
                    hintText: "Enter your child name",
                    onChanged: (value) => _addChildController.childName.value = value.trim(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter child name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Child Age Field
                  CustomTextField(
                    titleText: "Age",
                    hintText: "Enter child's age",
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _addChildController.childAge.value = value.trim(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter child age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 19.h),

                  // Avatar Selection Title
                  Text(
                    "Select Avatar",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: CustomThemeData().primaryTextColor, fontWeight: FontWeight.w700, fontSize: 14.sp),
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
                      itemCount: _addChildController.avatars.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First item: Custom Avatar Picker
                          return Obx(
                            () => GestureDetector(
                              onTap: () async {
                                await _addChildController.pickKidImage();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(4.h),
                                child: CircleAvatar(
                                  radius: 2,
                                  backgroundColor: Colors.purple,
                                  backgroundImage:
                                      _addChildController.kidImagePath.value.isEmpty ? null : FileImage(File(_addChildController.kidImagePath.value)),
                                  child: _addChildController.kidImagePath.value.isEmpty
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
                          final avatarIndex = index - 1; // Adjust index for predefined avatars
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                _addChildController.selectAvatar(avatarIndex);
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
                                          color: _addChildController.selectedAvatar.value == avatarIndex ? Colors.purple : Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.circular(60.r),
                                      ),
                                      child: Image.asset(
                                        _addChildController.avatars[avatarIndex],
                                        height: 60.h, // Adjust the size of the avatar
                                        width: 60.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    // Centered Check Icon (only when the avatar is selected)
                                    if (_addChildController.selectedAvatar.value == avatarIndex)
                                      Positioned(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(60.r),
                                              color: Colors.black38,
                                              border: Border.all(color: Colors.white)),
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
                    child: Obx(() => AppButton(
                          text: _addChildController.isLoading.value ? "Adding Child..." : "Add Child",
                          onPressed: () async {
                            final controller = Get.find<ParentBaseController>();
                            controller.showNavBar.value = true;

                            // if (_addChildController.isLoading.value) return;
                            //
                            // if (_formKey.currentState?.validate() ?? false) {
                            //   await _addChildController.createKid();
                            //
                            // }
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
}
