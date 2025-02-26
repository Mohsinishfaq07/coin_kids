import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/utils/landscape_orientation.dart';
import 'package:coin_kids/firebase/firebase_authentication/authentication_controller.dart';
import 'package:coin_kids/presentation/components/common/custom_show_case.dart';
import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:showcaseview/showcaseview.dart';

class KidSectionOnboarding extends GetView<AddChildController> {
  KidSectionOnboarding({super.key});

  // final _addChildController = Get.put(AddChildController());
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
                              backgroundImage:
                                  "assets/center_spot_light_background.png",
                              tooltipPosition: TooltipPosition.top,
                              disposeOnTap: false,
                              disableDefaultTargetGestures: false,
                              child: KidCustomTextField(
                                  maxlength: 10,
                                  keyboardType: TextInputType.name,
                                  hintText: "Enter your name",
                                  onChange: (value) => controller.childName.value = value.trim(),),
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
                                    if (controller
                                        .childName.value.isEmpty) {
                                      ToastUtil.showToast(
                                          "Please enter your name");
                                    } else {
                                      kidOnboardingController
                                          .increaseSpotLightIndex(index: 1);
                                      ShowCaseWidget.of(context).startShowCase([
                                        kidOnboardingController.ageListKey,
                                      ]);
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
                        controller.childName.value,
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
                      description: "How old are you? 🎂",
                      backgroundImage:
                      "assets/center_spot_light_background.png",
                      tooltipPosition: TooltipPosition.top,
                      disposeOnTap: false,
                      disableDefaultTargetGestures: false,
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
                                        controller.childAge.value =
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
                                ToastUtil.showToast("Please enter your Age");
                              } else {
                                kidOnboardingController.increaseSpotLightIndex(
                                    index: 2);
                                ShowCaseWidget.of(context).startShowCase([
                                  kidOnboardingController.avatarListKey,
                                ]);
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
                              // AppShowCaseWidget(
                              //   showcaseKey:
                              //       kidOnboardingController.avatarListKey,
                              //   description: "Choose an Avatar",
                              //   backgroundImage:
                              //   "assets/center_spot_light_background.png",
                              //   tooltipPosition: TooltipPosition.top,
                              //   disposeOnTap: false,
                              //   disableDefaultTargetGestures: false,
                              //   child: SizedBox(
                              //     height: 120.h,
                              //     width: 440.w,
                              //     child: GridView.builder(
                              //       padding:
                              //           EdgeInsets.symmetric(horizontal: 10.w),
                              //       gridDelegate:
                              //           SliverGridDelegateWithFixedCrossAxisCount(
                              //         crossAxisCount: 5,
                              //         crossAxisSpacing: 26.w,
                              //         mainAxisSpacing: 16.h,
                              //       ),
                              //       itemCount:
                              //           kidOnboardingController.avatars.length,
                              //       itemBuilder: (context, index) {
                              //         final avatarIndex = index;
                              //
                              //         return Obx(() => GestureDetector(
                              //               onTap: () {
                              //                 _addChildController
                              //                     .selectAvatar(avatarIndex);
                              //               },
                              //               child: Stack(
                              //                 alignment: Alignment.center,
                              //                 children: [
                              //                   CircleAvatar(
                              //                     radius: 30.r,
                              //                     backgroundColor:
                              //                         Colors.grey[200],
                              //                     backgroundImage: AssetImage(
                              //                         kidOnboardingController
                              //                             .avatars[index]),
                              //                   ),
                              //                   if (_addChildController
                              //                           .selectedAvatar.value ==
                              //                       avatarIndex)
                              //                     Positioned(
                              //                       child: Container(
                              //                         decoration: BoxDecoration(
                              //                             borderRadius:
                              //                                 BorderRadius
                              //                                     .circular(
                              //                                         60.r),
                              //                             color: Colors.black38,
                              //                             border: Border.all(
                              //                                 color: Colors
                              //                                     .white)),
                              //                         child: Icon(
                              //                           Icons.check,
                              //                           color: Colors.white,
                              //                           size: 24
                              //                               .sp, // Size of the check icon
                              //                         ),
                              //                       ),
                              //                     ),
                              //                 ],
                              //               ),
                              //             ));
                              //       },
                              //     ),
                              //   ),
                              // )
                              //
                              SizedBox(
                                  height: 120.h,
                                  width: 450.w, child: _buildAvatarGrid(context)),


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
                                    if (!authController.isNormalLoading.value) {
                                      authController.isNormalLoading.value =
                                          true;
                                      controller.createKid();
                                    }
                                    Get.off(() => KidHomeScreen());
                                  },
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 20.w, left: 20.w),
                                  child: GreenDoneButton(
                                    onTap: () async {
                                      if (controller
                                              .selectedAvatar.value ==
                                          -1) {
                                        ToastUtil.showToast(
                                            "Please select an avatar");
                                        return;
                                      }
                                      if (!authController
                                          .isNormalLoading.value) {
                                        authController.isNormalLoading.value =
                                            true;
                                        await controller.createKid();
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
  Widget _buildAvatarGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAvatars.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: controller.avatars.length + 1,
        // +1 for camera option
        itemBuilder: (context, index) {
          if (index == 0) {
            // Camera/Gallery picker option
            return Obx(() => GestureDetector(
              onTap: () => _showImagePicker(context),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.kidImagePath.value.isNotEmpty ? Colors.purple : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: controller.kidImagePath.value.isNotEmpty
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: Image.file(
                        File(controller.kidImagePath.value),
                        height: 30.h,
                        width: 30.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (controller.selectedAvatar.value == -1)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: Colors.black38,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                  ],
                )
                    : Container(
                  decoration: BoxDecoration(
                    color: AppColors.iconPrimary,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
            ));
          }

          // Predefined avatars
          final avatarIndex = index - 1;
          return Obx(
                () => GestureDetector(
              onTap: () => controller.selectAvatar(index - 1),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedAvatar.value == avatarIndex ? Colors.purple : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: Image.network(
                        controller.avatars[avatarIndex],
                        height: 30.h,
                        width: 30.h,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                            ),
                          );
                        },
                      ),
                    ),
                    if (controller.selectedAvatar.value == avatarIndex)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          color: Colors.black38,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 44.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
  void _showImagePicker(BuildContext context) {
    ImagePickerBottomSheet.show(
      onCameraTap: () => controller.pickKidImage(source: ImageSource.camera),
      onGalleryTap: () => controller.pickKidImage(source: ImageSource.gallery),
    );
  }
}

/// Custom Tooltip Decoration with Background Image
