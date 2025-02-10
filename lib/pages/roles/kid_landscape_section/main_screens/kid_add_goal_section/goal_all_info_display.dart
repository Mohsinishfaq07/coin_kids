import 'dart:io';

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

class KidGoalAllInfoDisplay extends StatelessWidget {
  const KidGoalAllInfoDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    KidGoalsController kidGoalsController = Get.put(KidGoalsController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            child: SvgPicture.asset(AppAssets.kidSectionBackIconSvg),
          ),
        ),
        actions: [SpendingCardContainer()],
      ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Add a Image for you Goal 📸',
                  style: AppTextStyle.headingLarge,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Obx(
                  () {
                    return Stack(
                      children: [
                        SizedBox(
                          width: 400.w,
                          height: 220.h,
                        ),
                        Container(
                          width: 364.w,
                          height: 204.h,
                          decoration: BoxDecoration(
                            color: AppColors.iconOnPrimary,
                            borderRadius: BorderRadius.circular(31.0),
                          ),
                          child: kidGoalsController.goalImage.value.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          kidGoalsController
                                              .pickImageFromCamera();
                                        },
                                        child: SvgPicture.asset(
                                          "assets/kidCameraIcon.svg",
                                          height: 65.h,
                                          width: 65.h,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    KidGoalAllInfoDisplayPickerButton(
                                        onTap: () async {
                                          await kidGoalsController
                                              .pickFromGallery();
                                        },
                                        color: Color(0xffE28424),
                                        buttonTitle: 'Add from Gallery',
                                        width: 215.w)
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Image.file(
                                    File(kidGoalsController.goalImage.value),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                        if (kidGoalsController.goalImage.value.isNotEmpty) ...[
                          Positioned(
                            right: 22.w,
                            top: 0.h,
                            child: GestureDetector(
                              onTap: () {
                                kidGoalsController.goalImage.value = '';
                              },
                              child: Container(
                                height: 44.09.w,
                                width: 44.09.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.buttonPrimary,
                                        width: 6.0),
                                    color: AppColors.buttonSecondary,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100.0),
                                    )),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppAssets.kidCrossIcons,
                                    height: 17.h,
                                    width: 17.w,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                Obx(() {
                  return GreenNextButton(
                    onTap: () {},
                    // color: kidGoalsController.goalImage.value.isNotEmpty
                    //     ? Color(0xff19B859)
                    //     : Color(0xffAB47BC),
                    buttonText: kidGoalsController.goalImage.value.isNotEmpty
                        ? 'Next'
                        : 'Skip',
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

KidGoalAllInfoDisplayPickerButton(
    {required Function() onTap,
    required Color color,
    required String buttonTitle,
    double? height,
    double? width}) {
  double _height = height ?? 42.h;
  double _width = width ?? 120.w;

  return Padding(
    padding: EdgeInsets.only(right: 20.w),
    child: Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: _width,
          height: _height,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.22.w, color: color),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20.w,
                right: 12.w,
                top: 4.h,
                bottom: 4.h,
                child: Row(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.transparent, // Background color (optional)
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              blurRadius: 10, // Blur radius for the shadow
                              offset:
                                  const Offset(2, 4), // Shadow position (x, y)
                            ),
                          ],
                          shape: BoxShape
                              .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                        ),
                        child: SvgPicture.asset(
                          AppAssets.kidPlusIcon,
                          height: 12.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      buttonTitle,
                      style: AppTextStyle.headingMedium.copyWith(
                          color: AppColors.textOnPrimary, fontSize: 22.sp),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 1,
                  top: 1.29,
                  child: Image.asset(
                    "assets/Button_shadow.png",
                    height: 10.h,
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}
