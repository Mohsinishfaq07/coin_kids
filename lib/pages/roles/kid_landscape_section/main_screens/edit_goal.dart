import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/save_goal_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../app_assets.dart';
import '../../../../../theme/color_theme.dart';
import '../../../../../theme/text_theme.dart';

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
    RxBool isLoading = false.obs;

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
                          kidGoalsController.goalImage.value = "";
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
                          Container(
                            height: 100.h,
                            width: 270.w,
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                color: AppColors.primaryLightColor
                                    .withOpacity(0.2),
                                border:
                                    Border.all(color: AppColors.buttonPrimary),
                                borderRadius: BorderRadius.circular(20.r)),
                            child: Center(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('kids')
                                    .where('parentId',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, kidSnapshot) {
                                  if (kidSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (!kidSnapshot.hasData ||
                                      kidSnapshot.data!.docs.isEmpty) {
                                    return const Text("No Kids Found");
                                  }

                                  final kidId = kidSnapshot.data!.docs.first.id;

                                  return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('goals')
                                          .where('kidId', isEqualTo: kidId)
                                          .where('goalId', isEqualTo: goalId)
                                          .where('deleted', isEqualTo: false)
                                          .limit(1)
                                          .snapshots(),
                                      builder: (context, goalSnapshot) {
                                        if (goalSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }

                                        if (!goalSnapshot.hasData ||
                                            goalSnapshot.data!.docs.isEmpty) {
                                          return AddGoalWidget();
                                        }

                                        return Obx(() {
                                          if (isLoading.value) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          // Instead of using FutureBuilder, directly use goalImage.value
                                          return Center(
                                            child: kidGoalsController
                                                    .goalImage.value.isNotEmpty
                                                ? Container(
                                                    height: 80.h,
                                                    width: 200.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: FileImage(File(
                                                            kidGoalsController
                                                                .goalImage
                                                                .value)), // Directly use goalImage.value
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                    ),
                                                  )
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await kidGoalsController
                                                                .pickImageFromCamera();
                                                          },
                                                          child:
                                                              SvgPicture.asset(
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
                                                            // This line is now unnecessary, as the UI will reactively update when goalImage.value changes.
                                                          },
                                                          backgroundColor:
                                                              Color(0xFFFF9E29),
                                                          borderColor:
                                                              Color(0xFFFF9E29),
                                                          buttonText:
                                                              'Add Photo',
                                                          width: 190.w,
                                                          showPrefix: true,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          );
                                        });
                                      });
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: -0,
                            right: -0,
                            child: GestureDetector(
                              onTap: () async {
                                isLoading.value =
                                    true; // Show loading while removing image
                                await kidGoalsController
                                    .removeImageFromPrefs(goalId);
                                kidGoalsController.goalImage.value = "";
                                isLoading.value =
                                    false; // Hide loading after image is removed
                              },
                              child: SvgPicture.asset(
                                AppAssets.crossSvg,
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
                                                hintText: goalAmount.toString(),
                                                onChange: (value) {
                                                  kidGoalsController.goalAmount
                                                      .value = double.tryParse(
                                                          value) ??
                                                      0.0; // ✅ Safe conversion with .value
                                                }),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: GreenNextButton(
                                              onTap: () async {
                                                final goalDocRef =
                                                    FirebaseFirestore.instance
                                                        .collection('goals')
                                                        .doc(goalId);
                                                await goalDocRef.update({
                                                  'name': kidGoalsController
                                                      .goalName
                                                      .value, // Use .value for RxString
                                                  'amount': kidGoalsController
                                                      .goalAmount
                                                      .value, // Use .value for RxDouble
                                                });

                                                String imagePath =
                                                    kidGoalsController
                                                        .goalImage.value;
                                                if (imagePath.isNotEmpty) {
                                                  File imageFile = File(
                                                      imagePath); // Convert the path to a File object
                                                  await kidGoalsController
                                                      .saveImageToPrefs(
                                                          goalId, imageFile);
                                                }

                                                Get.off(KidHomeScreen());
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
