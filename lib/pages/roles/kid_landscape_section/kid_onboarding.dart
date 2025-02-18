import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_done_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/orange_skip_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_screen.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/pages/roles/role_selection_screen.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class KidSectionOnboarding extends StatelessWidget {
  KidSectionOnboarding({super.key});
  final _addChildController = Get.put(AddChildController());

  @override
  Widget build(BuildContext context) {
    final KidsOnBoardingController kidOnboardingController =
        Get.put(KidsOnBoardingController());
    landscapeOrientation();
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
                  if (kidOnboardingController.spotLightIndex.value == 0) ...[
                    if (!kidOnboardingController.spotLightOn.value) ...[
                      SizedBox(
                        height: 16.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: kidBackButton(
                            onTap: () {
                              Get.to(RoleSelectionScreen());
                              kidOnboardingController.decreaseSpotLightIndex();
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
                                onChange: (value) {
                                  _addChildController.childName.value =
                                      value.trim();
                                }),
                            SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.03.h, // 5% of screen height
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GreenNextButton(
                                  showSuffix: true,
                                  onTap: () {
                                    if (_addChildController
                                        .childName.value.isEmpty) {
                                      ToastUtil.showToast(
                                          "Please enter your name"); // Show toast if empty
                                    } else {
                                      kidOnboardingController
                                          .increaseSpotLightIndex(index: 1);
                                    }
                                  },
                                  buttonText: 'Next',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                    if (kidOnboardingController.spotLightOn.value)
                      Flexible(
                          fit: FlexFit.loose,
                          child: SizedBox(
                            height: 20.h,
                          )),
                  ] else if (kidOnboardingController.spotLightIndex.value ==
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
                            kidOnboardingController.decreaseSpotLightIndex();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Center(
                      child: Text(
                        _addChildController.childName.value,
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
                            itemCount: kidOnboardingController.ageList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      kidOnboardingController
                                              .selectedAge.value =
                                          kidOnboardingController
                                              .ageList[index];

                                      // Store the same value in _addChildController.childAge
                                      _addChildController.childAge.value =
                                          kidOnboardingController
                                              .ageList[index];

                                      // Set the selected age in kidSectionOnboardingController
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: kidOnboardingController
                                                      .selectedAge.value ==
                                                  kidOnboardingController
                                                      .ageList[index]
                                              ? AppColors.textPrimary
                                              : AppColors.textOnPrimary,
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          border: Border.all(
                                            color: kidOnboardingController
                                                        .selectedAge.value ==
                                                    kidOnboardingController
                                                        .ageList[index]
                                                ? AppColors.textOnPrimary
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            kidOnboardingController
                                                .ageList[index],
                                            style: AppTextStyle.headingMedium
                                                .copyWith(
                                                    color: kidOnboardingController
                                                                .selectedAge
                                                                .value ==
                                                            kidOnboardingController
                                                                .ageList[index]
                                                        ? AppColors
                                                            .textOnPrimary
                                                        : AppColors
                                                            .textPrimary),
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
                          child: GreenNextButton(
                            onTap: () {
                              if (kidOnboardingController
                                  .selectedAge.value.isEmpty) {
                                ToastUtil.showToast(
                                    "Please enter your Age"); // Show toast if empty
                              } else {
                                kidOnboardingController.increaseSpotLightIndex(
                                    index: 2);
                              }
                            },
                            showSuffix: true,
                            buttonText: 'Next',
                          )),
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
                                      kidOnboardingController
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
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 26.w,
                                    mainAxisSpacing: 16.h,
                                  ),
                                  itemCount:
                                      kidOnboardingController.avatars.length,
                                  itemBuilder: (context, index) {
                                    final avatarIndex = index;

                                    return Obx(() => GestureDetector(
                                          onTap: () {
                                            _addChildController
                                                .selectAvatar(avatarIndex);
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 30.r,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                backgroundImage: AssetImage(
                                                    kidOnboardingController
                                                        .avatars[index]),
                                              ),
                                              if (_addChildController
                                                      .selectedAvatar.value ==
                                                  avatarIndex)
                                                Positioned(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60.r),
                                                        color: Colors.black38,
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 24
                                                          .sp, // Size of the check icon
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              )
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
                                OrangeSkipButton(
                                  onTap: () async {
                                    if (!firebaseAuthController
                                        .isNormalLoading.value) {
                                      firebaseAuthController
                                          .isNormalLoading.value = true;
                                      await firestoreOperations
                                          .parentFirebaseFunctions
                                          .addKidAndUpdateParent();
                                    }
                                    Get.off(() => KidHomeScreen());
                                  },
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 20.w, left: 20.w),
                                  child: GreenDoneButton(
                                    onTap: () async {
                                      if (_addChildController
                                              .selectedAvatar.value ==
                                          -1) {
                                        ToastUtil.showToast(
                                            "Please select an avatar");
                                        return;
                                      }
                                      if (!firebaseAuthController
                                          .isNormalLoading.value) {
                                        firebaseAuthController
                                            .isNormalLoading.value = true;
                                        await firestoreOperations
                                            .parentFirebaseFunctions
                                            .addKidAndUpdateParent();
                                      }
                                      Get.off(() => KidHomeScreen());
                                    },
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
