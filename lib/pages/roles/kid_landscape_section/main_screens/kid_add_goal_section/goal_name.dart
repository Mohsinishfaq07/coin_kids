import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/add_goal_amount.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddGoalName extends StatelessWidget {
  const AddGoalName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    KidGoalsController kidGoalsController = Get.put(KidGoalsController());

    return Scaffold(
        extendBody: true,
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
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: kidBackButton(
                          onTap: () {
                            Get.back();
                            kidGoalsController.goalName.value = "";
                          },
                        ),
                      ),
                      SpendingCardContainer()
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'What are you saving for 🎯',
                    style: AppTextStyle.headingLarge,
                  ),
                  SizedBox(height: 20.h),
                  // TextField(
                  //   onChanged: (goalNameValue) {
                  //     kidGoalsController.goalName.value = goalNameValue;
                  //   },
                  // ),
                  KidCustomTextField(
                      // keyboardType: TextInputType.name,
                      hintText: "e.g Electric Bike ",
                      onChange: (val) {
                        kidGoalsController.goalName.value = val;
                      }),
                  Padding(
                      padding: EdgeInsets.only(right: 20.w, top: 16.h),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: GreenNextButton(
                              showSuffix: true,
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
                                  Get.to(() => AddGoalAmount());
                                }
                              },
                              buttonText: 'Next'))),
                ],
              ),
            ),
          ),
        ));
  }
}
