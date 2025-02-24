import 'dart:async';
import 'dart:ui' as ui;

import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/utils/landscape_orientation.dart';
import 'package:coin_kids/firebase/firebase_authentication/authentication_controller.dart';
import 'package:coin_kids/presentation/components/common/custom_show_case.dart';
import 'package:coin_kids/presentation/components/kid/green_done_button.dart';
import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/components/kid/orange_skip_button.dart';

import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/add_child_controller.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class KidSectionOnboarding extends StatelessWidget {
  KidSectionOnboarding({super.key});

  final _addChildController = Get.put(AddChildController());
  final KidsOnBoardingController kidOnboardingController =
      Get.put(KidsOnBoardingController());

  final authController = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();
    return Scaffold(
      extendBodyBehindAppBar: false,
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
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "What's your name?",
                              style: AppTextStyle.headingMedium,
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            AppShowCaseWidget(
                              showcaseKey: kidOnboardingController.textFieldKey,
                              description: "What's your name? ✍️",
                              backgroundImage: "assets/center_spot_light_background.png", // Custom background
                              onTargetClick: () {
                                kidOnboardingController.spotLightOn.value = false;
                                if (_addChildController.childName.value.isNotEmpty) {
                                  kidOnboardingController.increaseSpotLightIndex(index: 1);
                                }
                              },
                              child: KidCustomTextField(
                                  maxlength: 10,
                                  hintText: "Enter your name",
                                  onChange: (value) {
                                    _addChildController.childName.value =
                                        value.trim();
                                  }),
                            ),
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
                    AppShowCaseWidget(
                      showcaseKey: kidOnboardingController.ageListKey,
                      description: "What's your name? ✍️",
                      backgroundImage: "assets/center_spot_light_background.png", // Custom background
                      onTargetClick: () {
                        if (_addChildController.childAge.value.isNotEmpty) {
                          kidOnboardingController.increaseSpotLightIndex(index: 2);
                        }
                      },

                      child: Padding(
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
                                                                      .ageList[
                                                                  index]
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
                    ),
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
                                    index: 1);
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
                              Showcase(
                                key: kidOnboardingController.avatarListKey,
                                description: 'Choose an avatar',
                                overlayColor: Colors.black.withOpacity(0.5),
                                overlayOpacity: 0.5,
                                targetShapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tooltipBackgroundColor: AppColors.textHighlighted,                                descTextStyle: AppTextStyle.headingMedium.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                                tooltipPadding: EdgeInsets.all(8.w),
                                child: SizedBox(
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
                                                                  .circular(
                                                                      60.r),
                                                          color: Colors.black38,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white)),
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
                                    if (!authController
                                        .isNormalLoading.value) {
                                      authController
                                          .isNormalLoading.value = true;
                                      // await authController
                                      //     .parentFirebaseFunctions
                                      //     .addKidAndUpdateParent();
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
                                      if (!authController
                                          .isNormalLoading.value) {
                                        authController
                                            .isNormalLoading.value = true;
                                        // await authController
                                        //     .parentFirebaseFunctions
                                        //     .addKidAndUpdateParent();
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

/// Custom Tooltip Decoration with Background Image
class CustomTooltipDecoration extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect.deflate(1), Radius.circular(10)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) async {
    final paint = Paint();

    final ui.Image image = await loadImage("assets/background_image.png");

    paint.shader = ImageShader(
      image,
      TileMode.clamp,
      TileMode.clamp,
      Matrix4.identity().storage,
    );

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)), paint);
  }

  @override
  ShapeBorder scale(double t) => this;

  /// Helper function to load an image asynchronously
  Future<ui.Image> loadImage(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final Uint8List bytes = data.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) => completer.complete(img));
    return completer.future;
  }
}
