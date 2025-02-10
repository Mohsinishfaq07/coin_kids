import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/pages/roles/parents/drawer/parent_drawer.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/edit_profile_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/components/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';

class UpdateKidProfile extends StatelessWidget {
  final String childId;
  final String childAge;
  final String childGrade;
  final String childAvatar;
  final String childName;
  const UpdateKidProfile(
      {super.key,
      required this.childId,
      required this.childAge,
      required this.childGrade,
      required this.childAvatar,
      required this.childName});

  @override
  Widget build(BuildContext context) {
    final AddChildController addChildController = Get.put(AddChildController());
    final EditProfileController editProfileController = Get.put(
        EditProfileController(childAge: childAge, childName: childName));

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Update Child Profile",
        showBackButton: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Child name',
                  style: TextStyle(
                    color: const Color(0xFF015486),
                    fontSize: 14.sp,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Obx(() {
                  return CustomTextField(
                      titleText: "Child name",
                      hintText: "Enter your child name",
                      controller:
                          editProfileController.childNameController.value,
                      onChanged: (val) {
                        editProfileController.childNameController.value.text =
                            val.trim();
                      });
                }),
                SizedBox(height: 28.h),
                Text(
                  'Age',
                  style: TextStyle(
                    color: Color(0xFF015486),
                    fontSize: 14.sp,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Obx(() {
                  return CustomTextField(
                    titleText: "Age",
                    hintText: "Enter child's age",
                    keyboardType: TextInputType.number,
                    controller: editProfileController.childAgeController.value,
                    onChanged: (value) {
                      editProfileController.childAgeController.value.text =
                          value.trim();
                    },
                  );
                }),
                SizedBox(height: 28.h),
                Text(
                  "Select Avatar",
                  style: TextStyle(
                    color: const Color(0xFF015486),
                    fontSize: 14.sp,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(6.w),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.42.h, // Specify a fixed height
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of items per row
                        crossAxisSpacing: 18, // Space between columns
                        mainAxisSpacing: 14, // Space between rows
                      ),
                      itemCount: addChildController.avatars.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First item: Custom Avatar Picker
                          return Obx(
                            () => GestureDetector(
                              onTap: () async {
                                showImageSourceBottomSheet(onCameraTap: () {
                                  Get.back(); // Close the bottom sheet
                                  //bottomNavigationBarController.pickFromCamera();
                                }, onGalleryTap: () async {
                                  if (addChildController
                                      .kidImagePath.value.isNotEmpty) {
                                    await addChildController.pickKidImage();
                                    Get.log(
                                        "Custom Avatar Path: ${addChildController.kidImagePath.value}");
                                  }
                                  // Close the bottom sheet

                                  Get.back();
                                  // bottomNavigationBarController.pickUpFromGallery();
                                });
                                // await addChildController.pickCustomAvatar();
                                // if (addChildController
                                //     .customAvatarPath.value.isNotEmpty) {
                                //   Get.log(
                                //       "Custom Avatar Path: ${addChildController.customAvatarPath.value}");
                                // }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: CircleAvatar(
                                  radius: 2,
                                  backgroundColor: Colors.purple,
                                  backgroundImage: addChildController
                                          .kidImagePath.value.isEmpty
                                      ? null
                                      : FileImage(File(addChildController
                                          .kidImagePath.value)),
                                  child: addChildController
                                          .kidImagePath.value.isEmpty
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
                                addChildController.selectAvatar(avatarIndex);
                                if (addChildController
                                    .kidImagePath.value.isNotEmpty) {
                                  Get.log(
                                      "Custom Avatar Path: ${addChildController.selectedAvatarPath.value}");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Avatar Image
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: addChildController
                                                      .selectedAvatar.value ==
                                                  avatarIndex
                                              ? Colors.purple
                                              : Colors.transparent,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: Image.asset(
                                        addChildController.avatars[avatarIndex],
                                        height: 70
                                            .h, // Adjust the size of the avatar
                                        width: 70.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    // Centered Check Icon (only when the avatar is selected)
                                    if (addChildController
                                            .selectedAvatar.value ==
                                        avatarIndex)
                                      Positioned(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.black38,
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size:
                                                24.sp, // Size of the check icon
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
                ),
                Center(
                  child: Obx(() {
                    return editProfileController.childUpdate.value
                        ? const CircularProgressIndicator()
                        : AppButton(
                            onPressed: () async {
                              if (editProfileController
                                  .childNameController.value.text.isEmpty) {
                                ToastUtil.showToast('name is required');
                              } else {
                                final String avatarUrl = addChildController
                                        .selectedAvatarPath.value.isEmpty
                                    ? addChildController.kidImagePath.value
                                    : addChildController
                                        .selectedAvatarPath.value;

                                updateChildData(
                                    childId: childId,
                                    name: editProfileController
                                        .childNameController.value.text,
                                    age: editProfileController
                                        .childAgeController.value.text,
                                    grade: 'Grade 1',
                                    avatarPath: avatarUrl);
                              }
                            },
                            text: 'Update Child',
                          );
                  }),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateChildData({
    required String childId,
    required String name,
    required String age,
    required String grade,
    required String avatarPath,
  }) async {
    final EditProfileController editProfileController =
        Get.put(EditProfileController(childAge: age, childName: name));
    editProfileController.childUpdate.value = true;
    Get.log('avatar path:$avatarPath');
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection('kids').doc(childId).set(
        {'grade': grade, 'name': name, 'age': age, 'avatar': avatarPath},
        SetOptions(merge: true),
      );
      ToastUtil.showToast('Child info updated');
      Get.off(ParentBottomNavigationBar());
      editProfileController.childUpdate.value = false;
    } catch (e) {
      editProfileController.childUpdate.value = false;
      Get.log('kid update error:${e.toString()}');
    }
  }
}
