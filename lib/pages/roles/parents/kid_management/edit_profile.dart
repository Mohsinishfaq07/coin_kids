// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/components/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';

class EditProfileController extends GetxController {
  // RxString selectedGrade = 'Grade 1'.obs;
  // RxString updatedName = ''.obs;
  final String childAge;
  final String childName;

  EditProfileController({
    required this.childAge,
    required this.childName,
  });
  RxBool childUpdate = false.obs;
  Rx<TextEditingController> childAgeController = TextEditingController().obs;
  Rx<TextEditingController> childNameController = TextEditingController().obs;
  setValues({
    required String childAge,
    required String childName,
  }) {
    childAgeController.value.text = childAge.trim();
    childNameController.value.text = childName.trim();
    Get.log('updating controllers');
  }

  @override
  void onInit() {
    super.onInit();
    setValues(childAge: childAge, childName: childName);
  }
}

class EditProfile extends StatelessWidget {
  final String childId;
  final String childAge;
  final String childGrade;
  final String childAvatar;
  final String childName;
  const EditProfile(
      {super.key,
      required this.childId,
      required this.childAge,
      required this.childGrade,
      required this.childAvatar,
      required this.childName});

  @override
  Widget build(BuildContext context) {
    final AddChildController _controller = Get.put(AddChildController());
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
                // CustomTextField(
                //     titleText: "Age",
                //     hintText: "Your Age",
                //     onChanged: (val) {
                //       editProfileController.selectedAge.value = val.trim();
                //     }),
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
                // Obx(() => Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         GestureDetector(
                //           onTap: () async {
                //             await _controller.pickCustomAvatar();
                //           },
                //           child: Obx(() => Container(
                //                 decoration: BoxDecoration(
                //                     borderRadius:
                //                         const BorderRadius.all(Radius.circular(
                //                       30,
                //                     )),
                //                     border: Border.all(
                //                       color: Colors.purple,
                //                     )),
                //                 child: CircleAvatar(
                //                   radius: 30,
                //                   backgroundColor: Colors.transparent,
                //                   backgroundImage: _controller
                //                           .customAvatarPath.value.isEmpty
                //                       ? null
                //                       : FileImage(File(
                //                           _controller.customAvatarPath.value)),
                //                   child:
                //                       _controller.customAvatarPath.value.isEmpty
                //                           ? const Icon(
                //                               Icons.add,
                //                               size: 30,
                //                               color: Colors.purple,
                //                             )
                //                           : null,
                //                 ),
                //               )),
                //         ), // Predefined avatars
                //         // ...GridTileBar.builder(_controller.avatars.length, (index) {
                //         //   return GestureDetector(
                //         //     onTap: () => _controller.selectAvatar(index),
                //         //     child: CircleAvatar(
                //         //       radius: 30,
                //         //       backgroundColor:
                //         //           _controller.selectedAvatar.value == index
                //         //               ? Colors.purple
                //         //               : Colors.transparent,
                //         //       child: CircleAvatar(
                //         //         radius: 28,
                //         //         backgroundImage:
                //         //             AssetImage(_controller.avatars[index]),
                //         //       ),
                //         //     ),
                //         //   );
                //         // }),

                //         // Custom Avatar (Empty Circle with Camera Icon)
                //       ],
                //     )),
                // const Expanded(child: SizedBox()),
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
                      itemCount: _controller.avatars.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First item: Custom Avatar Picker
                          return Obx(
                            () => GestureDetector(
                              onTap: () async {
                                await _controller.pickCustomAvatar();
                                if (_controller
                                    .customAvatarPath.value.isNotEmpty) {
                                  Get.log(
                                      "Custom Avatar Path: ${_controller.customAvatarPath.value}");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
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
                                if (_controller
                                    .customAvatarPath.value.isNotEmpty) {
                                  Get.log(
                                      "Custom Avatar Path: ${_controller.selectedAvatarPath.value}");
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
                                          color: _controller
                                                      .selectedAvatar.value ==
                                                  avatarIndex
                                              ? Colors.purple
                                              : Colors.transparent,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: Image.asset(
                                        _controller.avatars[avatarIndex],
                                        height: 70
                                            .h, // Adjust the size of the avatar
                                        width: 70.w,
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
                                Get.snackbar('Alert', 'name is required');
                              } else {
                                final String avatarUrl =
                                    _controller.selectedAvatarPath.value.isEmpty
                                        ? _controller.customAvatarPath.value
                                        : _controller.selectedAvatarPath.value;

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
      Get.snackbar('Alert', 'Child info updated');
      editProfileController.childUpdate.value = false;
      Get.off(ParentBottomNavigationBar());
    } catch (e) {
      editProfileController.childUpdate.value = false;
      Get.log('kid update error:${e.toString()}');
    }
  }
}
