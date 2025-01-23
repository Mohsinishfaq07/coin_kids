import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/common_funcitons.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_page.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class KidSectionOnboarding extends StatelessWidget {
  const KidSectionOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final KidsOnBoardingController kidSectionOnboardingController =
        Get.put(KidsOnBoardingController());
    setOrientationAndStatusBar();
    return Scaffold(
      extendBodyBehindAppBar: false,
      // appBar: kidsAppBar(
      //     leadingWidget: Padding(
      //   padding: EdgeInsets.only(left: 20.w),
      //   child: kidBackButton(
      //     onTap: () {
      //       kidSectionOnboardingController.decreaseSpotLightIndex();
      //     },
      //   ),
      // )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(
              image: AssetImage(
                AppAssets.kidSectionBG,
              ),
              fit: BoxFit.cover),
        ),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Adjust as needed
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (kidSectionOnboardingController.spotLightIndex.value ==
                      0) ...[
                    if (!kidSectionOnboardingController.spotLightOn.value) ...[
                      SizedBox(
                        height: 16.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: kidBackButton(
                            onTap: () {
                              kidSectionOnboardingController
                                  .decreaseSpotLightIndex();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Center(
                        child: Text(
                          'Welcome to CoinKids!',
                          style: AppTextStyle.headingLarge,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.05.h, // 5% of screen height
                      ),
                      // SizedBox(
                      //   height: 40.h,
                      // ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "What’s your name?",
                              style: AppTextStyle.headingMedium,
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            KidCustomTextField(
                                hintText: "“Enter your name” e.g. Alex",
                                onChange: (val) {
                                  firebaseAuthController.username.value =
                                      val.trim();
                                }),
                            SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.03.h, // 5% of screen height
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    kidSectionOnboardingController
                                        .increaseSpotLightIndex(index: 1);
                                  },
                                  child: Container(
                                    width: 120.w,
                                    height: 32.h,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFF19B859),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 2.22.w,
                                            color: const Color(0xFF0E9454)),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
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
                                              Text(
                                                "Next",
                                                style: AppTextStyle
                                                    .headingMedium
                                                    .copyWith(
                                                        color: AppColors
                                                            .textOnPrimary,
                                                        fontSize: 22.sp),
                                              ),
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .transparent, // Background color (optional)
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.2), // Shadow color
                                                        blurRadius:
                                                            10, // Blur radius for the shadow
                                                        offset: const Offset(2,
                                                            4), // Shadow position (x, y)
                                                      ),
                                                    ],
                                                    shape: BoxShape
                                                        .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                                  ),
                                                  child: SvgPicture.asset(
                                                    "assets/arrorDirectionNoShadow.svg",
                                                    height: 12.h,
                                                  ),
                                                ),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (kidSectionOnboardingController.spotLightOn.value)
                      Flexible(
                          fit: FlexFit.loose,
                          child: SizedBox(
                            height: 20.h,
                          )),
                  ] else if (kidSectionOnboardingController
                          .spotLightIndex.value ==
                      1) ...[
                    // if (!kidSectionOnboardingController.spotLightOn.value) ...[
                    SizedBox(
                      height: 16.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: kidBackButton(
                          onTap: () {
                            kidSectionOnboardingController
                                .decreaseSpotLightIndex();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Center(
                      child: Text(
                        'Hi Nina,',
                        style: AppTextStyle.headingLarge,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "How old are you?",
                      style: AppTextStyle.headingMedium,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 130.w),
                      child: SizedBox(
                        height: 50.h,
                        // width: double.infinity,
                        child: ListView.builder(
                            itemCount:
                                kidSectionOnboardingController.ageList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      kidSectionOnboardingController
                                              .selectedAge.value =
                                          kidSectionOnboardingController
                                              .ageList[index];
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: kidSectionOnboardingController
                                                      .selectedAge.value ==
                                                  kidSectionOnboardingController
                                                      .ageList[index]
                                              ? AppColors.textPrimary
                                              : AppColors.textOnPrimary,
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          border: Border.all(
                                            color: kidSectionOnboardingController
                                                        .selectedAge.value ==
                                                    kidSectionOnboardingController
                                                        .ageList[index]
                                                ? AppColors.textOnPrimary
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            kidSectionOnboardingController
                                                .ageList[index],
                                            style: AppTextStyle.headingMedium.copyWith(
                                                color: kidSectionOnboardingController
                                                            .selectedAge
                                                            .value ==
                                                        kidSectionOnboardingController
                                                            .ageList[index]
                                                    ? AppColors.textOnPrimary
                                                    : AppColors.textPrimary),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }),
                      ),
                    ),
                    //],
                    // if (kidSectionOnboardingController.spotLightOn.value)

                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            kidSectionOnboardingController
                                .increaseSpotLightIndex(index: 2);
                          },
                          child: Container(
                            width: 120.w,
                            height: 32.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF19B859),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 2.22.w,
                                    color: const Color(0xFF0E9454)),
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
                                      Text(
                                        "Next",
                                        style: AppTextStyle.headingMedium
                                            .copyWith(
                                                color: AppColors.textOnPrimary,
                                                fontSize: 22.sp),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .transparent, // Background color (optional)
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color
                                                blurRadius:
                                                    10, // Blur radius for the shadow
                                                offset: const Offset(2,
                                                    4), // Shadow position (x, y)
                                              ),
                                            ],
                                            shape: BoxShape
                                                .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/arrorDirectionNoShadow.svg",
                                            fit: BoxFit.cover,
                                            height: 10.h,
                                          ),
                                        ),
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
                    ),
                  ] else ...[
                    Stack(
                      children: [
                        // Grid and Text
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 16.h,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: kidBackButton(
                                    onTap: () {
                                      kidSectionOnboardingController
                                          .decreaseSpotLightIndex();
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                "Pick an avatar that feels just like you 👨‍🎨👑🎭",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.headingLarge,
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                height: 120.h,
                                width: 440.w,
                                child: GridView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        5, // Number of avatars in one row
                                    crossAxisSpacing:
                                        26.w, // Space between columns
                                    mainAxisSpacing: 16.h, // Space between rows
                                  ),
                                  itemCount: kidSectionOnboardingController
                                      .avatars.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: CircleAvatar(
                                        radius: 30.r,
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: AssetImage(
                                            kidSectionOnboardingController
                                                .avatars[index]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Buttons at the bottom
                        Positioned(
                          bottom: 0.h,
                          left: 0.w,
                          right: 0.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const KidHomePage());
                                  },
                                  child: Container(
                                    width: 120.w,
                                    height: 32.h,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFF9E29),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 2.22.w,
                                          color: const Color(0xFFD67513),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
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
                                                    color: Colors
                                                        .transparent, // Background color (optional)
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.2), // Shadow color
                                                        blurRadius:
                                                            10, // Blur radius for the shadow
                                                        offset: const Offset(2,
                                                            4), // Shadow position (x, y)
                                                      ),
                                                    ],
                                                    shape: BoxShape
                                                        .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                                  ),
                                                  child: SvgPicture.asset(
                                                    AppAssets.kidCrossIcons,
                                                    fit: BoxFit.cover,
                                                    height: 12.h,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                "Skip",
                                                style: AppTextStyle
                                                    .headingMedium
                                                    .copyWith(
                                                        color: AppColors
                                                            .textOnPrimary,
                                                        fontSize: 22.sp),
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
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 20.w, left: 20.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => const KidHomePage());
                                    },
                                    child: Container(
                                      width: 120.w,
                                      height: 32.h,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF19B859),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 2.22.w,
                                              color: const Color(0xFF0E9454)),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
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
                                                Text(
                                                  "Next",
                                                  style: AppTextStyle
                                                      .headingMedium
                                                      .copyWith(
                                                          color: AppColors
                                                              .textOnPrimary,
                                                          fontSize: 22.sp),
                                                ),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .transparent, // Background color (optional)
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.2), // Shadow color
                                                          blurRadius:
                                                              10, // Blur radius for the shadow
                                                          offset: const Offset(
                                                              2,
                                                              4), // Shadow position (x, y)
                                                        ),
                                                      ],
                                                      shape: BoxShape
                                                          .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                                    ),
                                                    child: SvgPicture.asset(
                                                      "assets/arrorDirectionNoShadow.svg",
                                                      fit: BoxFit.cover,
                                                      height: 10.h,
                                                    ),
                                                  ),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ]),
          );
        }),
      ),
    );
  }
}
