import 'dart:async';
import 'dart:io';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_progress.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../app_assets.dart';
import '../../../../../theme/color_theme.dart';
import '../../../../../theme/text_theme.dart';

class AddGoalImage extends StatelessWidget {
  const AddGoalImage({
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
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
                ),
                SizedBox(height: 16.h),
                Text(
                  'Add a Image for you Goal📸',
                  style: AppTextStyle.headingLarge,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100.h,
                      width: 120.w,
                    ),
                    Obx(() {
                      return Stack(
                        children: [
                          Container(
                            height: 100.h,
                            width: 364.w,
                            decoration: BoxDecoration(
                              color: AppColors.iconOnPrimary,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: kidGoalsController.goalImage.value.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await kidGoalsController
                                              .pickImageFromCamera();
                                        },
                                        child: SvgPicture.asset(
                                          "assets/kidCameraIcon.svg",
                                          height: 40.h,
                                          width: 40.h,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      GreenNextButton(
                                        onTap: () async {
                                          await kidGoalsController
                                              .pickFromGallery();
                                        },
                                        backgroundColor: Color(0xFFFF9E29),
                                        borderColor: Color(0xFFFF9E29),
                                        buttonText: 'Add From Gallery',
                                        width: 280.w,
                                        showPrefix: true,
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(30.r),
                                    child: Image.file(
                                      File(kidGoalsController.goalImage.value),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                          ),
                        ],
                      );
                    }),
                    Obx(() {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
                          child: GreenNextButton(
                            onTap: () async {
                              if (kidGoalsController.goalImage.value.isEmpty) {
                                kidGoalsController.goalImage.value = "";
                                kidGoalsController.goalName.value = "";
                                await kidGoalsController.addKidGoal();
                                String? goalId = await kidGoalsController
                                    .getGoalIdFromPrefs();
                                if (goalId != null && goalId.isNotEmpty) {
                                  Get.off(() => GoalProgress(
                                        isCompleted: false.obs,
                                        goalId: goalId,
                                        fromHome: false.obs,
                                        //  completed: false.obs,
                                      ));
                                } else {
                                  ToastUtil.showToast("Goal ID not found");
                                }
                                // showToast("Please select an image");
                              } else {
                                try {
                                  await kidGoalsController.addKidGoal();
                                  String? goalId = await kidGoalsController
                                      .getGoalIdFromPrefs();

                                  if (goalId != null && goalId.isNotEmpty) {
                                    Get.off(() => GoalProgress(
                                          isCompleted: false.obs,
                                          goalId: goalId,
                                          fromHome: false.obs,
                                          // completed: false.obs,
                                        ));
                                    kidGoalsController.goalImage.value = "";
                                    kidGoalsController.goalName.value = "";
                                  } else {
                                    ToastUtil.showToast("Goal ID not found");
                                  }
                                } on TimeoutException catch (e) {
                                  print("Firestore transaction timed out: $e");
                                }
                              }
                            },
                            buttonText:
                                kidGoalsController.goalImage.value.isNotEmpty
                                    ? 'save'
                                    : 'Skip',
                            backgroundColor:
                                kidGoalsController.goalImage.value.isNotEmpty
                                    ? Color(0xff19B859)
                                    : Color(0xffAB47BC),
                            borderColor:
                                kidGoalsController.goalImage.value.isNotEmpty
                                    ? Color(0xff19B859)
                                    : Color(0xffAB47BC),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
