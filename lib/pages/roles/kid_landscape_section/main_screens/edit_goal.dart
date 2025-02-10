import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
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
                Stack(children: [
                  Container(
                      decoration: BoxDecoration(
                        color: AppColors.iconOnPrimary,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Container(
                          //   padding: EdgeInsets.all(30),
                          //   decoration: BoxDecoration(
                          //       border:
                          //           Border.all(color: AppColors.buttonPrimary),
                          //       borderRadius: BorderRadius.circular(20.r)),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       GestureDetector(
                          //         onTap: () async {
                          //           await kidGoalsController
                          //               .pickImageFromCamera();
                          //         },
                          //         child: SvgPicture.asset(
                          //           "assets/kidCameraIcon.svg",
                          //           height: 30.h,
                          //           width: 30.h,
                          //         ),
                          //       ),
                          //       SizedBox(height: 15.h),
                          //       GreenNextButton(
                          //         onTap: () async {
                          //           await kidGoalsController.pickFromGallery();
                          //         },
                          //         backgroundColor: Color(0xFFFF9E29),
                          //         borderColor: Color(0xFFFF9E29),
                          //         buttonText: 'Add Photo',
                          //         width: 190.w,
                          //         showPrefix: true,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Stack(children: [
                            Container(
                              height: 100.h,
                              width: 270.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryLightColor,
                                  border: Border.all(
                                      color: AppColors.buttonPrimary),
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
                                      print(
                                          "[DEBUG] No kids found for parentId: ${FirebaseAuth.instance.currentUser!.uid}");
                                      return const Text("No Kids Found");
                                    }

                                    // ✅ Get the first kid's ID
                                    final kidId =
                                        kidSnapshot.data!.docs.first.id;
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

                                        return FutureBuilder<File?>(
                                          future: kidGoalsController
                                              .getImageFromPrefs(goalId),
                                          builder: (context, imageSnapshot) {
                                            if (imageSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }
                                            File? imageFile =
                                                imageSnapshot.data;

                                            return Center(
                                              child: imageFile != null
                                                  ? Container(
                                                      height: 80.h,
                                                      width: 200.w,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: FileImage(
                                                              imageFile),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : Icon(Icons.image,
                                                      size: 60.h,
                                                      color: Colors.grey),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 20.h,
                                width: 20.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: AppColors.skipButton,
                                  borderRadius: BorderRadius.circular(
                                      30.r), // Rounded corners
                                  border: Border.all(
                                    width: 3.22.w,
                                    color: AppColors.iconPrimary,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 12.w,
                                      right: 12.w,
                                      top: 4.h,
                                      bottom: 2.h,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 10,
                                                offset: const Offset(2, 4),
                                              ),
                                            ],
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/kidRoleIcons/kidCrossButton.svg",

                                            // Uses default or user-provided SVG
                                            height: 30
                                                .h, // Use default height if not provided
                                            width: 30.w,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0.5,
                                      top: 0.29,
                                      child: Image.asset(
                                        "assets/Button_shadow.png",
                                        height: 8.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                          StreamBuilder<QuerySnapshot>(
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
                                      final goal = goalDoc.data()
                                          as Map<String, dynamic>;
                                      final goalTitle =
                                          goal['name'] ?? "No Title";
                                      final goalAmount = goal['amount'] ?? 0;

                                      return SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Goal Name',
                                                style:
                                                    AppTextStyle.headingSmall),
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
                                                style:
                                                    AppTextStyle.headingSmall),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 6.h),
                                              child: KidCustomTextField(
                                                  hintText:
                                                      goalAmount.toString(),
                                                  onChange: (value) {
                                                    kidGoalsController
                                                        .goalAmount
                                                        .value = double
                                                            .tryParse(value) ??
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
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
