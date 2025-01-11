// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_dropdown.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';

class EditProfileController extends GetxController {
  RxString selectedAge = '1'.obs;
  RxString selectedGrade = 'Grade 1'.obs;
  RxString updatedName = ''.obs;
  RxBool childUpdate = false.obs;

  setValues({
    required String childAge,
    required String childGrade,
  }) {
    selectedAge.value = childAge;
    selectedGrade.value = childGrade;
    Get.log('values set: ${'${selectedAge.value} ${selectedGrade.value}'}');
  }
}

class EditProfile extends StatelessWidget {
  final String childId;
  final String childAge;
  final String childGrade;
  final String childAvatar;
  const EditProfile(
      {super.key,
      required this.childId,
      required this.childAge,
      required this.childGrade,
      required this.childAvatar});

  @override
  Widget build(BuildContext context) {
    final AddChildController _controller = Get.put(AddChildController());
    final EditProfileController editProfileController =
        Get.put(EditProfileController());
    editProfileController.setValues(childAge: childAge, childGrade: childGrade);
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                CustomTextField(
                    titleText: "Child name",
                    hintText: "Enter your child name",
                    onChanged: (val) {
                      editProfileController.updatedName.value = val;
                    }),
                SizedBox(height: 28.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          SizedBox(
                              width: 320.w,
                              child: Obx(() {
                                return customDropdown(
                                  context,
                                  options: [
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10',
                                    '11',
                                    '12',
                                    '13',
                                    '14',
                                    '15',
                                    '16',
                                    '17',
                                    '18',
                                    '19',
                                    '20',
                                    '21',
                                    '22',
                                    '23',
                                    '24',
                                    '25',
                                    '26',
                                    '27',
                                    '28',
                                    '29',
                                    '30'
                                  ],
                                  onChanged: (value) {
                                    Get.log('Selected: $value');
                                    editProfileController.selectedAge.value =
                                        value ?? '1';
                                  },
                                  selectedValue:
                                      editProfileController.selectedAge.value,
                                );
                              })),
                        ],
                      ),
                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       const Text('Grade'),
                      //       SizedBox(
                      //         width: MediaQuery.sizeOf(context).width / 2.5,
                      //         child: Obx(() {
                      //           return customDropdown(
                      //             context,
                      //             options: [
                      //               'Grade 1',
                      //               'Grade 2',
                      //               'Grade 3',
                      //               'Grade 4'
                      //             ],
                      //             onChanged: (value) {
                      //               Get.log('Selected: $value');
                      //               editProfileController.selectedGrade.value =
                      //                   value ?? 'Grade 1';
                      //             },
                      //             selectedValue:
                      //                 editProfileController.selectedGrade.value,
                      //           );
                      //         }),
                      //       ),
                      //     ],
                      //   )
                      // ],
                    ]),
                const SizedBox(height: 10),
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
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Image.asset(
                                        _controller.avatars[avatarIndex],
                                        height:
                                            70, // Adjust the size of the avatar
                                        width: 70,
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
                        : CustomButton(
                            text: "Update Child",
                            onPressed: () async {
                              if (editProfileController
                                  .updatedName.value.isEmpty) {
                                Get.snackbar('Alert', 'name is required');
                              } else {
                                updateChildData(
                                    childId: childId,
                                    name:
                                        editProfileController.updatedName.value,
                                    age:
                                        editProfileController.selectedAge.value,
                                    grade: editProfileController
                                        .selectedGrade.value);
                              }
                            },
                            textColor: Colors.black,
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
  }) async {
    final EditProfileController editProfileController =
        Get.put(EditProfileController());
    editProfileController.childUpdate.value = true;
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection('kids').doc(childId).set(
        {'grade': grade, 'name': name, 'age': age},
        SetOptions(merge: true),
      );
      Get.snackbar('Alert', 'Child info updated');
      editProfileController.childUpdate.value = false;
    } catch (e) {
      editProfileController.childUpdate.value = false;
      Get.log('kid update error:${e.toString()}');
    }
  }
}
