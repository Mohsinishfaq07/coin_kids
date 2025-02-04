import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/edit_goal.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/slider.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GoalProgress extends StatelessWidget {
  final RxBool fromHome;
  final String goalId;
  GoalProgress({super.key, required this.goalId, required this.fromHome});

  final parentController = Get.put(ParentController());
  Stream<QuerySnapshot<Map<String, dynamic>>> _kidsStream() {
    return FirebaseFirestore.instance
        .collection('kids')
        .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots(); // Real-time updates
  }

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();

    final kidGoalController =
        Get.find<KidGoalsController>(); // Using Get.find to access controller
    final sliderController = Get.put(SliderController());

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
                                print("[DEBUG] Querying Firestore with:");
                                print("[DEBUG] kidId: $kidId");
                                print("[DEBUG] goalId: $goalId");
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
                                  return Text("No Goal Found");
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
                                            Get.to(KidHomeScreen());
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
                Expanded(
                  flex: 1,
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                SizedBox(
                                  width: 20.w,
                                ),
                                coinLockedWidget(),
                                SpendingCardContainer(),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      backgroundColor: AppColors.critical,
                                      borderColor: Colors.white,
                                      svgAsset: "assets/Minus.svg",
                                      iconColor: Colors.white,
                                      svgHeight: 40.h,
                                      onTap: () async {
                                        // Fetching the current user's kid(s)
                                        final kidSnapshot = await FirebaseFirestore
                                            .instance
                                            .collection('kids')
                                            .where('parentId',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .get(); // Using .get() instead of .snapshots() for async operation

                                        if (kidSnapshot.docs.isEmpty) {
                                          print(
                                              "[DEBUG] No kids found for parentId: ${FirebaseAuth.instance.currentUser!.uid}");
                                          return; // Return early if no kids found
                                        }

                                        // Get the first kid's ID
                                        final kidId = kidSnapshot.docs.first.id;
                                        print("[DEBUG] Found Kid: $kidId");

                                        // Get the current amount from the controller and ensure it's a valid double
                                        double enteredAmount =
                                            0.25; // Default value if parsing fails
                                        await firestoreOperations
                                            .parentFirebaseFunctions
                                            .SpendingTOGoals(
                                          kidId: kidId,
                                          enteredAmount: enteredAmount,
                                           // If save is false, you can update other fields or handle accordingly
                                        
                                        );
                                      },
                                    ),
                                    FutureBuilder<String?>(
                                      future: kidGoalController
                                          .getGoalIdFromPrefs(),
                                      builder: (context, goalIdSnapshot) {
                                        if (goalIdSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }

                                        final currentGoalId =
                                            goalIdSnapshot.data;
                                        if (currentGoalId == null) {
                                          return Text("No Goal ID Found");
                                        }

                                        return StreamBuilder<QuerySnapshot>(
                                          stream: _kidsStream(),
                                          builder: (context, kidSnapshot) {
                                            if (kidSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            if (!kidSnapshot.hasData ||
                                                kidSnapshot
                                                    .data!.docs.isEmpty) {
                                              return Text("No Kids Found");
                                            }

                                            final kidId =
                                                kidSnapshot.data!.docs.first.id;

                                            return StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('goals')
                                                  .where('kidId',
                                                      isEqualTo: kidId)
                                                  .where('goalId',
                                                      isEqualTo: currentGoalId)
                                                  .where('deleted',
                                                      isEqualTo: false)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                }

                                                if (!snapshot.hasData ||
                                                    snapshot
                                                        .data!.docs.isEmpty) {
                                                  return Text("No Data Found");
                                                }

                                                final goal = snapshot
                                                        .data!.docs.first
                                                        .data()
                                                    as Map<String, dynamic>?;
                                                final goalAmount =
                                                    goal?['amount'] ?? 0;

                                                // If goalAmount is zero or invalid, set a default value for max
                                                final maxAmount = goalAmount > 0
                                                    ? goalAmount.toDouble()
                                                    : 100.0;

                                                // Update the goal amount in the controller
                                                sliderController
                                                    .setGoalAmount(maxAmount);

                                                return SizedBox(
                                                  width: 320.w,
                                                  child: Obx(() => Slider(
                                                        autofocus: true,
                                                        allowedInteraction:
                                                            SliderInteraction
                                                                .slideThumb,
                                                        thumbColor: AppColors
                                                            .buttonPrimary,
                                                        activeColor: AppColors
                                                            .buttonPrimary,
                                                        inactiveColor: AppColors
                                                            .primaryLightColor,
                                                        divisions: 4,
                                                        value: sliderController
                                                            .sliderValue
                                                            .value, // Controlled value
                                                        label:
                                                            "${sliderController.sliderValue.value.toInt()}",
                                                        secondaryActiveColor:
                                                            Colors.red,
                                                        min: 0,
                                                        max: maxAmount,
                                                        onChanged:
                                                            (double value) {
                                                          sliderController
                                                              .updateValue(
                                                                  value); // Update state
                                                        },
                                                      )),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    kidBackButton(
                                      buttonHeight: 26.h,
                                      buttonWidth: 26.h,
                                      backgroundColor: AppColors.currencyStroke,
                                      borderColor: Colors.white,
                                      svgAsset: "assets/Add.svg",
                                      iconColor: Colors.white,
                                      svgHeight: 40.h,
                                      onTap: () async {
                                        // Fetching the current user's kid(s)
                                        final kidSnapshot = await FirebaseFirestore
                                            .instance
                                            .collection('kids')
                                            .where('parentId',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .get(); // Using .get() instead of .snapshots() for async operation

                                        if (kidSnapshot.docs.isEmpty) {
                                          print(
                                              "[DEBUG] No kids found for parentId: ${FirebaseAuth.instance.currentUser!.uid}");
                                          return; // Return early if no kids found
                                        }

                                        // Get the first kid's ID
                                        final kidId = kidSnapshot.docs.first.id;
                                        print("[DEBUG] Found Kid: $kidId");

                                        // Fetch the current spending amount from the kid's document
                                        final kidDoc = kidSnapshot.docs.first;
                                        final Map<String, dynamic> kidData =
                                            kidDoc.data()
                                                as Map<String, dynamic>;
                                        final Map<String, dynamic>
                                            spendingData =
                                            kidData.containsKey('spendings')
                                                ? kidData['spendings']
                                                    as Map<String, dynamic>
                                                : {};

                                        final double spendingAmount =
                                            (spendingData['amount'] ?? 0.0)
                                                .toDouble();

                                        // Check if the current spending is less than 0.25
                                        if (spendingAmount < 0.25) {
                                          // Show a toast message (Snackbar)
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Insufficient balance!"),
                                          ));
                                          return; // Return early without proceeding with the update if balance is insufficient
                                        }

                                        // Get the current amount from the controller and ensure it's a valid double
                                        double enteredAmount =
                                            0.25; // Default value if parsing fails

                                        // Now perform the update operation
                                        await firestoreOperations
                                            .parentFirebaseFunctions
                                            .updateKidSpending(
                                          kidId: kidId,
                                          enteredAmount: enteredAmount,
                                          save:
                                              false, // If save is false, you can update other fields or handle accordingly
                                          spendingJarColor:
                                              AppColors.textPrimary,
                                        );

                                        // Success message
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconButton(
                                          iconPath:
                                              "assets/pencil_svgrepo.com.svg",
                                          label: 'Edit',
                                          onTap: () => Get.to(EditGoal())),
                                      SizedBox(
                                        width: 36.w,
                                      ),
                                      CustomIconButton(
                                        iconPath: "assets/trash.svg",
                                        label: 'Delete',
                                        onTap: () {

                                         
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
 

  coinLockedWidget() {
    return SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            fit: StackFit.loose,
            children: [
              Positioned(
                top: 5.h,
                right: 6.w,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 18.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(4.r),
                      border:
                          Border.all(color: AppColors.textPrimary, width: 2.0),
                    ),
                    child: Text(
                      "5000",
                      style: AppTextStyle.headingMedium
                          .copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -4.w,
                top: 2.h,
                child: Container(
                  color: Colors.transparent,
                  height: 24.h,
                  // width: 80.w,
                  child: SvgPicture.asset(AppAssets.kidCoinIcon, height: 24.h),
                ),
              ),
              Container(
                height: 28.9.h,
                width: 120.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xff000000).withOpacity(0.46)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppAssets.kidLockIcon, height: 24.h),
          ),
        ],
      ),
    );
  }
}
