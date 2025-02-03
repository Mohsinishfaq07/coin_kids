import 'dart:async';
import 'dart:io';

import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_close_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                    // Obx(
                    //   () {
                    //     return Stack(
                    //       children: [
                    //         Container(
                    //           height: 100.h,
                    //           width: 364.w,
                    //           decoration: BoxDecoration(
                    //             color: AppColors.iconOnPrimary,
                    //             borderRadius: BorderRadius.circular(30.r),
                    //           ),
                    //           child: kidGoalsController.goalImage.value.isEmpty
                    //               ? Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Center(
                    //                       child: GestureDetector(
                    //                         onTap: kidGoalsController
                    //                                 .isPickingImage.value
                    //                             ? null
                    //                             : () async {
                    //                                 await kidGoalsController
                    //                                     .pickImageFromCamera();
                    //                               },
                    //                         child: SvgPicture.asset(
                    //                           "assets/kidCameraIcon.svg",
                    //                           height: 30.h,
                    //                           width: 30.h,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 15.h,
                    //                     ),
                    //                     GestureDetector(
                    //                       onTap: () async {
                    //                         await kidGoalsController
                    //                             .pickCustomAvatar();
                    //                       },
                    //                       child: Container(
                    //                         width: 230.w,
                    //                         height: 32.h,
                    //                         clipBehavior: Clip.antiAlias,
                    //                         decoration: ShapeDecoration(
                    //                           color: const Color(0xFFFF9E29),
                    //                           shape: RoundedRectangleBorder(
                    //                             side: BorderSide(
                    //                               width: 2.22.w,
                    //                               color:
                    //                                   const Color(0xFFD67513),
                    //                             ),
                    //                             borderRadius:
                    //                                 BorderRadius.circular(20.r),
                    //                           ),
                    //                         ),
                    //                         child: Stack(
                    //                           children: [
                    //                             Positioned(
                    //                               left: 10.w,
                    //                               right: 1.w,
                    //                               top: 4.h,
                    //                               bottom: 3.h,
                    //                               child: Row(
                    //                                 children: [
                    //                                   Center(
                    //                                     child: Container(
                    //                                       decoration:
                    //                                           BoxDecoration(
                    //                                         color: Colors
                    //                                             .transparent, // Background color (optional)
                    //                                         boxShadow: [
                    //                                           BoxShadow(
                    //                                             color: Colors
                    //                                                 .black
                    //                                                 .withOpacity(
                    //                                                     0.2), // Shadow color
                    //                                             blurRadius:
                    //                                                 6, // Blur radius for the shadow
                    //                                             offset: const Offset(
                    //                                                 2,
                    //                                                 4), // Shadow position (x, y)
                    //                                           ),
                    //                                         ],
                    //                                         shape: BoxShape
                    //                                             .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                    //                                       ),
                    //                                       child:
                    //                                           SvgPicture.asset(
                    //                                         "assets/Add.svg",
                    //                                         fit: BoxFit.cover,
                    //                                         height: 10.h,
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                   SizedBox(
                    //                                     width: 8.w,
                    //                                   ),
                    //                                   Text(
                    //                                     "Add From Gallery",
                    //                                     style: AppTextStyle
                    //                                         .headingMedium
                    //                                         .copyWith(
                    //                                       color: AppColors
                    //                                           .textOnPrimary,
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                             Positioned(
                    //                               left: 1,
                    //                               top: 1.29,
                    //                               child: SvgPicture.asset(
                    //                                 'assets/add_icon.svg',
                    //                                 height: 7.h,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 )
                    //               : Padding(
                    //                   padding: EdgeInsets.all(10.0),
                    //                   child: Image.file(
                    //                       File(kidGoalsController
                    //                           .goalImage.value),
                    //                       fit: BoxFit.contain),
                    //                 ),
                    //         ),
                    //         if (kidGoalsController
                    //             .goalImage.value.isNotEmpty) ...[
                    //           Positioned(
                    //             right: 0.w,
                    //             top: 0.h,
                    //             child: KidCloseButton(
                    //               onTap: () {
                    //                 kidGoalsController.goalImage.value = '';
                    //               },
                    //             ),
                    //           )
                    //         ]
                    //       ],
                    //     );
                    //   },
                    // ),
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
                                          height: 30.h,
                                          width: 30.h,
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      GestureDetector(
                                        onTap: () async {
                                          await kidGoalsController
                                              .pickCustomAvatar();
                                        },
                                        child: Container(
                                          width: 230.w,
                                          height: 32.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF9E29),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Pick from Gallery",
                                              style: AppTextStyle.bodyLarge,
                                            ),
                                          ),
                                        ),
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
                                showToast("Please select an image");
                              } else {
                                try {
                                  await kidGoalsController.addKidGoal();
                                  Get.off(() => KidHomeScreen());
                                } on TimeoutException catch (e) {
                                  // Handle timeout here (e.g., show a message or retry logic)
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

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.iconPrimary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
