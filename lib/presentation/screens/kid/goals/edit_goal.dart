import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/utils/landscape_orientation.dart';
import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/screens/kid/goals/save_goal_widget.dart';
import 'package:coin_kids/presentation/components/kid/spending_card_container.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../app_assets.dart';
import '../../../../../core/theme/color_theme.dart';
import '../../../../../core/theme/text_theme.dart';

class EditGoal extends StatelessWidget {
  final String goalId;
  const EditGoal({
    required this.goalId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();

    KidGoalsController kidGoalsController = Get.find<KidGoalsController>();
    kidGoalsController.getImageFromPrefs(goalId);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.background,
            image: DecorationImage(
              image: AssetImage(AppAssets.kidSectionBG),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26.w),
                      child: kidBackButton(
                        onTap: () {
                          //kidGoalsController.goalImage.value = "";
                          kidGoalsController.isImageRemoved.value = false;
                          Get.back();
                        },
                      ),
                    ),
                    SpendingCardContainer()
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      color: AppColors.iconOnPrimary,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Stack(children: [
                          Obx(() {
                            if (kidGoalsController.goalImage.value.isNotEmpty) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(kidGoalsController.goalImage.value),
                                    height: 100.h,
                                    width: 270.w,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        kidGoalsController
                                                .isImageRemoved.value =
                                            true; // Mark image for removal
                                        kidGoalsController.goalImage.value =
                                            ""; // Clear preview
                                      },
                                      child: SvgPicture.asset(
                                        AppAssets.crossWithDoubleBorderSvg,
                                        width: 22.w,
                                        height: 22.h,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Center(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await kidGoalsController
                                            .pickImageFromCamera();
                                      },
                                      child: SvgPicture.asset(
                                        "assets/kidCameraIcon.svg",
                                        height: 30.h,
                                        width: 30.h,
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    GreenNextButton(
                                      onTap: () async {
                                        await kidGoalsController
                                            .pickFromGallery();
                                      },
                                      backgroundColor: Color(0xFFFF9E29),
                                      borderColor: Color(0xFFFF9E29),
                                      buttonText: 'Add Photo',
                                      width: 190.w,
                                      showPrefix: true,
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),

                          // FutureBuilder<File?>(
                          //   future:
                          //       kidGoalsController.getImageFromPrefs(goalId),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.waiting) {
                          //       return const CircularProgressIndicator(); // Loading state
                          //     }

                          //     if (snapshot.hasError) {
                          //       return Text('Error: ${snapshot.error}');
                          //     }

                          //     final file = snapshot.data;
                          //     if (file != null) {
                          //       return Image.file(
                          //         file,
                          //         height: 100.h,
                          //         width: 270.w,
                          //         fit: BoxFit.cover,
                          //       );
                          //     } else {
                          //       return Center(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             GestureDetector(
                          //               onTap: () async {
                          //                 await kidGoalsController
                          //                     .pickImageFromCamera();
                          //               },
                          //               child: SvgPicture.asset(
                          //                 "assets/kidCameraIcon.svg",
                          //                 height: 30.h,
                          //                 width: 30.h,
                          //               ),
                          //             ),
                          //             SizedBox(height: 15.h),
                          //             GreenNextButton(
                          //               onTap: () async {
                          //                 await kidGoalsController
                          //                     .pickFromGallery();
                          //                 // This line is now unnecessary, as the UI will reactively update when goalImage.value changes.
                          //               },
                          //               backgroundColor: Color(0xFFFF9E29),
                          //               borderColor: Color(0xFFFF9E29),
                          //               buttonText: 'Add Photo',
                          //               width: 190.w,
                          //               showPrefix: true,
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     }
                          //   },
                          // ),

                          Positioned(
                            top: -0,
                            right: -0,
                            child: GestureDetector(
                              onTap: () async {
                                kidGoalsController.isImageRemoved.value =
                                    true; // Mark the image as removed
                                kidGoalsController.goalImage.value = "";
                                //   isLoading.value =
                                //       true; // Show loading while removing image
                                //   await kidGoalsController
                                //       .removeImageFromPrefs(goalId);
                                //   kidGoalsController.goalImage.value = "";
                                //   isLoading.value =
                                //       false; // Hide loading after image is removed
                                //   Get.off(KidHomeScreen());
                              },
                              child: SvgPicture.asset(
                                AppAssets.crossWithDoubleBorderSvg,
                                width: 22.w,
                                height: 22.h,
                              ),
                            ),
                          )
                        ]),

                        ///textfield wala code

                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('kids')
                                .where('parentId',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, kidSnapshot) {
                              if (kidSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (!kidSnapshot.hasData ||
                                  kidSnapshot.data!.docs.isEmpty) {
                                print(
                                    "[DEBUG] No kids found for parentId: ${FirebaseAuth.instance.currentUser!.uid}");
                                return const Text("No Kids Found");
                              }

                              // ✅ Get the first kid's ID
                              final kidId = kidSnapshot.data!.docs.first.id;
                              print("[DEBUG] Found Kid: $kidId");

                              return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('goals')
                                      .where('kidId', isEqualTo: kidId)
                                      .where('goalId', isEqualTo: goalId)
                                      .where('deleted', isEqualTo: false)
                                      .limit(1)
                                      .snapshots(),
                                  builder: (context, goalSnapshot) {
                                    print(
                                        "[DEBUG] Goal Snapshot: ${goalSnapshot.data?.docs.length}");

                                    if (goalSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }

                                    if (!goalSnapshot.hasData ||
                                        goalSnapshot.data!.docs.isEmpty) {
                                      print(
                                          "[DEBUG] No Goal Found for kidId: $kidId and goalId: $goalId");
                                      return AddGoalWidget();
                                    }

                                    // ✅ Get the latest goal data safely
                                    final goalDoc =
                                        goalSnapshot.data!.docs.first;
                                    final goal =
                                        goalDoc.data() as Map<String, dynamic>;
                                    final goalTitle =
                                        goal['name'] ?? "No Title";
                                    final goalAmount = goal['amount'] ?? 0;

                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Goal Name',
                                              style: AppTextStyle.headingSmall),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h),
                                            child: KidCustomTextField(
                                              hintText: goalTitle.isEmpty
                                                  ? 'Goal Name'
                                                  : goalTitle, // ✅ Use directly
                                              onChange: (value) {
                                                kidGoalsController
                                                    .goalName.value = value;
                                                // ✅ Assign directly
                                              },
                                            ),
                                          ),
                                          Text('Amount',
                                              style: AppTextStyle.headingSmall),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h),
                                            child: KidCustomTextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                hintText: goalAmount.toString(),
                                                onChange: (value) {
                                                  kidGoalsController.goalAmount
                                                      .value = double.tryParse(
                                                          value) ??
                                                      0.0; // ✅ Safe conversion with .value
                                                }),
                                          ),
                                          // Align(
                                          //   alignment: Alignment.bottomRight,
                                          //   child: GreenNextButton(
                                          //     onTap: () async {
                                          //       final goalDocRef =
                                          //           FirebaseFirestore.instance
                                          //               .collection('goals')
                                          //               .doc(goalId);
                                          //       await goalDocRef.update({
                                          //         'name': kidGoalsController
                                          //             .goalName
                                          //             .value, // Use .value for RxString
                                          //         'amount': kidGoalsController
                                          //             .goalAmount
                                          //             .value, // Use .value for RxDouble
                                          //       });
                                          //       if (kidGoalsController
                                          //           .isImageRemoved.value) {
                                          //         await kidGoalsController
                                          //             .removeImageFromPrefs(
                                          //                 goalId);
                                          //       } else {
                                          //         // If not removed, save the image
                                          //         String imagePath =
                                          //             kidGoalsController
                                          //                 .goalImage.value;
                                          //         if (imagePath.isNotEmpty) {
                                          //           File imageFile =
                                          //               File(imagePath);
                                          //           await kidGoalsController
                                          //               .saveImageToPrefs(
                                          //                   goalId, imageFile);
                                          //         }
                                          //       }

                                          //       Get.off(KidHomeScreen());
                                          //     },
                                          //     showSuffix: true,
                                          //     buttonText: 'Save',
                                          //     backgroundColor:
                                          //         Color(0xff19B859),
                                          //     borderColor: Color(0xff19B859),
                                          //   ),
                                          // ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: GreenNextButton(
                                              onTap: () async {
                                                final goalDocRef =
                                                    FirebaseFirestore.instance
                                                        .collection('goals')
                                                        .doc(goalId);

                                                // ✅ Create a dynamic map for updating only changed fields
                                                Map<String, dynamic>
                                                    updateData = {};

                                                // ✅ Only update name if it has changed
                                                if (kidGoalsController.goalName
                                                    .value.isNotEmpty) {
                                                  updateData['name'] =
                                                      kidGoalsController
                                                          .goalName.value;
                                                }

                                                // ✅ Only update amount if it has changed
                                                if (kidGoalsController
                                                        .goalAmount.value >
                                                    0) {
                                                  updateData['amount'] =
                                                      kidGoalsController
                                                          .goalAmount.value;
                                                }

                                                // ✅ Update only if there are changes
                                                if (updateData.isNotEmpty) {
                                                  await goalDocRef
                                                      .update(updateData);
                                                }
                                                if (kidGoalsController
                                                    .isImageRemoved.value) {
                                                  await kidGoalsController
                                                      .removeImageFromPrefs(
                                                          goalId);
                                                  kidGoalsController
                                                      .isImageRemoved
                                                      .value = false;
                                                } else {
                                                  String imagePath =
                                                      kidGoalsController
                                                          .goalImage.value;
                                                  if (imagePath.isNotEmpty) {
                                                    File imageFile =
                                                        File(imagePath);
                                                    await kidGoalsController
                                                        .saveImageToPrefs(
                                                            goalId, imageFile);
                                                  }

                                                  // ✅ Handle image separately
                                                  // if (kidGoalsController
                                                  //     .isImageRemoved.value) {
                                                  //   await kidGoalsController
                                                  //       .removeImageFromPrefs(
                                                  //           goalId);
                                                  // } else {
                                                  //   // If not removed, save the image only if it has changed
                                                  //   String imagePath =
                                                  //       kidGoalsController
                                                  //           .goalImage.value;
                                                  //   if (imagePath.isNotEmpty) {
                                                  //     File imageFile =
                                                  //         File(imagePath);
                                                  //     await kidGoalsController
                                                  //         .saveImageToPrefs(
                                                  //             goalId, imageFile);
                                                  //   }
                                                }

                                                Get.off(() => KidHomeScreen());
                                              },
                                              showSuffix: true,
                                              buttonText: 'Save',
                                              backgroundColor:
                                                  Color(0xff19B859),
                                              borderColor: Color(0xff19B859),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            })
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
