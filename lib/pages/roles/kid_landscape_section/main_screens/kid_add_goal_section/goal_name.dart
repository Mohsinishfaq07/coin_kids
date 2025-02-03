import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/add_goal_amount.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddGoalName extends StatelessWidget {
  AddGoalName({Key? key}) : super(key: key);

  final parentController = Get.put(ParentController());

  final kidGoalsController = Get.put(KidGoalsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Container(
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
              children: [
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: kidBackButton(
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                      SpendingCardContainer()
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'What are you saving for 🎯',
                  style: AppTextStyle.headingLarge,
                ),
                SizedBox(height: 20.h),
                KidCustomTextField(
                    keyboardType: TextInputType.name,
                    hintText: "e.g Electric Bike ",
                    onChange: (val) {
                      kidGoalsController.goalName.value = val;
                    }),
                Padding(
                    padding: EdgeInsets.only(right: 20.w, top: 16.h),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: GreenNextButton(
                            onTap: () async {
                              if (kidGoalsController.goalName.value.isEmpty) {
                                Fluttertoast.showToast(
                                  msg:
                                      'Goal Name Could Not be empty ', // Message to display
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: AppColors.textHighlighted,
                                  textColor: Colors.white,
                                  fontSize: 16.sp,
                                );
                              } else {
                                kidGoalsController.goalName.value;
                                // kidGoalsController.addKidGoal();
                                 Get.to(() => AddGoalAmount());
                              }
                            },
                            buttonText: 'Next'))),
              ],
            ),
          ),
        ));
  }
}
