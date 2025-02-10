import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/custom_icon_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/goal_completed_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/slider_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/edit_goal.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/slider.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/save_goal_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GoalProgress extends StatelessWidget {
  RxBool isCompleted;
  final RxBool fromHome;
  final String goalId;
  GoalProgress({
    super.key,
    required this.goalId,
    required this.fromHome,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();

    final kidGoalController =
        Get.find<KidGoalsController>(); // Using Get.find to access controller

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                    color: AppColors.iconPrimary,
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Center(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('kids')
                              .where('parentId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, kidSnapshot) {
                            if (kidSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            if (!kidSnapshot.hasData ||
                                kidSnapshot.data!.docs.isEmpty) {
                              print(
                                  "[DEBUG] No kids found for parentId: ${FirebaseAuth.instance.currentUser!.uid}");
                              return Text("No Kids Found");
                            }

                            // ✅ Get the first kid's ID
                            final kidId = kidSnapshot.data!.docs.first.id;
                            print("[DEBUG] Found Kid: $kidId");

                            // 🔹 Now fetch goals for this kid
                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('goals')
                                  .where('kidId',
                                      isEqualTo:
                                          kidId) // Get goals for the retrieved kid
                                  .where('goalId',
                                      isEqualTo:
                                          goalId) // Match goalId from constructor
                                  .where('deleted',
                                      isEqualTo: false) // Exclude deleted goals
                                  //.orderBy('createdAt', descending: true) // 🔴 Removed for now (needs index)
                                  .limit(1) // Fetch only the latest goal
                                  .snapshots(),
                              builder: (context, goalSnapshot) {
                                print(
                                    "[DEBUG] Goal Snapshot: ${goalSnapshot.data?.docs.length}");

                                if (goalSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (!goalSnapshot.hasData ||
                                    goalSnapshot.data!.docs.isEmpty) {
                                  print(
                                      "[DEBUG] No Goal Found for kidId: $kidId and goalId: $goalId");
                                  return AddGoalWidget();
                                }

                                // ✅ Get the latest goal data safely
                                final goalDoc = goalSnapshot.data!.docs.first;
                                final goal =
                                    goalDoc.data() as Map<String, dynamic>;
                                final goalTitle = goal['name'] ?? "No Title";
                                final goalAmount = goal['amount'] ?? 0;

                                return FutureBuilder<File?>(
                                  future: kidGoalController
                                      .getImageFromPrefs(goalId),
                                  builder: (context, imageSnapshot) {
                                    if (imageSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    File? imageFile = imageSnapshot.data;
                                    return Stack(children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 26.w, top: 12.h),
                                        child: kidBackButton(
                                          onTap: () {
                                            Get.off(KidHomeScreen());
                                          },
                                        ),
                                      ),
                                      Center(
                                          child: GoalCard(
                                              goal: goal,
                                              imageFile: imageFile)),
                                    ]);
                                  },
                                );
                              },
                            );
                          }),
                    )),
                Obx(
                  () => Expanded(
                    flex: 1,
                    child: isCompleted.value == true
                        ? TimelineScreen()
                        : Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: AppColors.background,
                              image: DecorationImage(
                                image: AssetImage(
                                  AppAssets.kidSectionBG,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 6.h),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        SizedBox(),
                                        //coinLockedWidget(),
                                        SpendingCardContainer(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Goal Progress',
                                          style: AppTextStyle.headingMedium,
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            kidBackButton(
                                              buttonHeight: 26.h,
                                              buttonWidth: 26.h,
                                              backgroundColor:
                                                  AppColors.critical,
                                              borderColor: Colors.white,
                                              svgAsset: "assets/Minus.svg",
                                              iconColor: Colors.white,
                                              svgHeight: 40.h,
                                              onTap: () async {
                                                kidGoalController
                                                    .isMinus.value = true;
                                                final kidSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('kids')
                                                        .where('parentId',
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get();

                                                if (kidSnapshot.docs.isEmpty) {
                                                  print(
                                                      "[DEBUG] No kids found");
                                                  return;
                                                }

                                                final kidId =
                                                    kidSnapshot.docs.first.id;
                                                final goalSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('goals')
                                                        .where('kidId',
                                                            isEqualTo: kidId)
                                                        .where('goalId',
                                                            isEqualTo: goalId)
                                                        .get();
                                                if (goalSnapshot.docs.isEmpty) {
                                                  print(
                                                      "[DEBUG] No goal found");
                                                  return;
                                                }
                                                final goalDoc =
                                                    goalSnapshot.docs.first;
                                                final goalData = goalDoc.data();
                                                double currentAmount = goalData
                                                        .containsKey(
                                                            'currentAmount')
                                                    ? (goalData[
                                                            'currentAmount'] ??
                                                        0.0)
                                                    : 0.0;

                                                double currentSliderValue =
                                                    kidGoalController
                                                        .sliderValue.value;
                                                if (currentSliderValue == 0.0) {
                                                  currentSliderValue =
                                                      currentAmount;
                                                }
                                                double newSliderValue =
                                                    currentSliderValue - 0.25;
                                                kidGoalController.updateValue(
                                                    newSliderValue);
                                                print(
                                                    "[DEBUG] Slider incremented to: $newSliderValue");
                                              },
                                            ),
                                            SliderWidget(
                                              goalId: goalId,

                                              // Pass the required firestore operations
                                            ),
                                            kidBackButton(
                                              buttonHeight: 26.h,
                                              buttonWidth: 26.h,
                                              backgroundColor:
                                                  AppColors.currencyStroke,
                                              borderColor: Colors.white,
                                              svgAsset: "assets/Add.svg",
                                              iconColor: Colors.white,
                                              svgHeight: 40.h,
                                              onTap: () async {
                                                kidGoalController
                                                    .isMinus.value = false;
                                                final kidSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('kids')
                                                        .where('parentId',
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get();

                                                if (kidSnapshot.docs.isEmpty) {
                                                  print(
                                                      "[DEBUG] No kids found");
                                                  return;
                                                }

                                                final kidId =
                                                    kidSnapshot.docs.first.id;
                                                final goalSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('goals')
                                                        .where('kidId',
                                                            isEqualTo: kidId)
                                                        .where('goalId',
                                                            isEqualTo: goalId)
                                                        .get();
                                                if (goalSnapshot.docs.isEmpty) {
                                                  print(
                                                      "[DEBUG] No goal found");
                                                  return;
                                                }
                                                final goalDoc =
                                                    goalSnapshot.docs.first;
                                                final goalData = goalDoc.data();
                                                // double currentAmount = goalData
                                                //         .containsKey(
                                                //             'currentAmount')
                                                //     ? (goalData[
                                                //             'currentAmount'] ??
                                                //         0.0)
                                                //     : 0.0;
                                                double currentAmount = goalData
                                                        .containsKey(
                                                            'currentAmount')
                                                    ? (goalData['currentAmount']
                                                            is int
                                                        ? (goalData['currentAmount']
                                                                as int)
                                                            .toDouble() // Convert int to double
                                                        : (goalData[
                                                                'currentAmount'] ??
                                                            0.0))
                                                    : 0.0;

                                                double currentSliderValue =
                                                    kidGoalController
                                                        .sliderValue.value;
                                                if (currentSliderValue == 0.0) {
                                                  currentSliderValue =
                                                      currentAmount;
                                                }
                                                double newSliderValue =
                                                    currentSliderValue + 0.25;
                                                kidGoalController.updateValue(
                                                    newSliderValue);
                                                print(
                                                    "[DEBUG] Slider incremented to: $newSliderValue");
                                              },
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomIconButton(
                                                  iconPath:
                                                      "assets/pencil_svgrepo.com.svg",
                                                  label: 'Edit',
                                                  onTap: () => Get.to(EditGoal(
                                                        goalId: goalId,
                                                      ))),
                                              SizedBox(
                                                width: 36.w,
                                              ),
                                              CustomIconButton(
                                                iconPath: "assets/trash.svg",
                                                label: 'Delete',
                                                onTap: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 20.w),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GreenNextButton(
                                              showSuffix: true,
                                              width: 128.w,
                                              suffixSvg:
                                                  "assets/kidRoleIcons/kidTickButton.svg",
                                              onTap: () async {
                                                final kidSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('kids')
                                                        .where('parentId',
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get();

                                                if (kidSnapshot.docs.isEmpty) {
                                                  print(
                                                      "[DEBUG] No kids found");
                                                  return;
                                                }

                                                final kidId =
                                                    kidSnapshot.docs.first.id;
                                                final goalSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('goals')
                                                        .where('kidId',
                                                            isEqualTo: kidId)
                                                        .where('goalId',
                                                            isEqualTo: goalId)
                                                        .get();

                                                if (goalSnapshot.docs.isEmpty) {
                                                  print(
                                                      "[DEBUG] No goal found");
                                                  return;
                                                }

                                                final goalDoc =
                                                    goalSnapshot.docs.first;
                                                final goalData = goalDoc.data();

                                                // double currentAmount = goalData
                                                //         .containsKey(
                                                //             'currentAmount')
                                                //     ? (goalData[
                                                //             'currentAmount'] ??
                                                //         0.0)
                                                //     : 0.0;
                                                double currentAmount = goalData
                                                        .containsKey(
                                                            'currentAmount')
                                                    ? (goalData['currentAmount']
                                                            is int
                                                        ? (goalData['currentAmount']
                                                                as int)
                                                            .toDouble() // Convert int to double
                                                        : (goalData[
                                                                'currentAmount'] ??
                                                            0.0))
                                                    : 0.0;

                                                double sliderValue =
                                                    kidGoalController
                                                        .sliderValue.value;

                                                // Calculate only the newly added amount
                                                if (kidGoalController
                                                        .isMinus.value ==
                                                    true) {
                                                  double addedAmount =
                                                      currentAmount -
                                                          sliderValue;
                                                  kidGoalController
                                                      .GoalsTOSpending(
                                                    goalId: goalId,
                                                    kidId: kidId,
                                                    enteredAmount: addedAmount,
                                                  );
                                                  print(
                                                      "[DEBUG] Firestore updated with added amount: $addedAmount");
                                                } else {
                                                  double addedAmount =
                                                      sliderValue -
                                                          currentAmount;
                                                  if (addedAmount <= 0) {
                                                    ToastUtil.showToast(
                                                        "Please add or remove funds");
                                                    return;
                                                  }
                                                  kidGoalController
                                                      .SpendingTOGoals(
                                                    goalId: goalId,
                                                    kidId: kidId,
                                                    enteredAmount: addedAmount,
                                                  );
                                                  print(
                                                      "[DEBUG] Firestore updated with added amount: $addedAmount");
                                                }
                                                Get.offAll(KidHomeScreen());
                                              },
                                              buttonText: "Done",
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
