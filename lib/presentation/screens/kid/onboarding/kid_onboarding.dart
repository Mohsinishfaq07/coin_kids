// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:coin_kids/app_assets.dart';
// import 'package:coin_kids/core/utils/landscape_orientation.dart';
// import 'package:coin_kids/presentation/components/common/custom_show_case.dart';
// import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
// import 'package:coin_kids/presentation/components/kid/green_done_button.dart';
// import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
// import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
// import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
// import 'package:coin_kids/presentation/components/kid/orange_skip_button.dart';
// import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
// import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
// import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
// import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
// import 'package:coin_kids/core/theme/color_theme.dart';
// import 'package:coin_kids/core/theme/text_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// class KidSectionOnboarding extends GetView<KidsOnBoardingController> {
//   KidSectionOnboarding({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     landscapeOrientation();
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: AppColors.background,
//           image: DecorationImage(
//               image: AssetImage(
//                 AppAssets.kidSectionBG,
//               ),
//               fit: BoxFit.cover),
//         ),
//         child: Obx(() {
//           return SingleChildScrollView(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start, // Adjust as needed
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (controller.spotLightIndex.value == 0) ...[
//                     if (!controller.spotLightOn.value) ...[
//                       SizedBox(
//                         height: 16.h,
//                       ),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 20.w),
//                           child: kidBackButton(
//                             onTap: () {
//                               Get.to(RoleSelectionScreen());
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 6.h,
//                       ),
//                       Center(
//                         child: Text(
//                           'Welcome to CoinKids!',
//                           style: AppTextStyle.headingLarge,
//                         ),
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height *
//                             0.05.h, // 5% of screen height
//                       ),
//                       SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               "What's your name?",
//                               style: AppTextStyle.headingMedium,
//                             ),
//                             SizedBox(
//                               height: 6.h,
//                             ),
//                             // Replace the first showcase widget with:
//                             AppShowCaseWidget(
//                               showcaseKey: controller
//                                   .kidNameKey, // Changed from kidNameKey to textFieldKey
//                               description: "What's your name? ✍️",
//                               backgroundImage:
//                                   "assets/center_spot_light_background.png",
//                               tooltipPosition: TooltipPosition.top,
//                               disposeOnTap: false,
//                               disableDefaultTargetGestures: false,
//                               child: KidCustomTextField(
//                                 maxlength: 10,
//                                 keyboardType: TextInputType.name,
//                                 hintText: "Enter your name",
//                                 onChange: (value) => controller
//                                     .addChildController
//                                     .childName
//                                     .value = value.trim(),
//                               ),
//                             ),
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height *
//                                   0.03.h, // 5% of screen height
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(right: 20.w),
//                               child: Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: GreenNextButton(
//                                   showSuffix: true,
//                                   onTap: () {
//                                     if (controller.addChildController.childName
//                                         .value.isEmpty) {
//                                       ToastUtil.showToast(
//                                           "Please enter your name");
//                                     } else {
//                                       controller.increaseSpotLightIndex(
//                                           index: 1);
//                                       ShowCaseWidget.of(context).startShowCase([
//                                         controller.kidAgeKey,
//                                       ]);
//                                     }
//                                   },
//                                   buttonText: 'Next',
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                     if (controller.spotLightOn.value)
//                       Flexible(
//                           fit: FlexFit.loose,
//                           child: SizedBox(
//                             height: 20.h,
//                           )),
//                   ] else if (controller.spotLightIndex.value == 1) ...[
//                     SizedBox(
//                       height: 16.h,
//                     ),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 20.w),
//                         child: kidBackButton(
//                           onTap: () {
//                             controller.decreaseSpotLightIndex();
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 6.h,
//                     ),
//                     Center(
//                       child: Text(
//                         controller.addChildController.childName.value,
//                         style: AppTextStyle.headingLarge,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30.h,
//                     ),
//                     Text(
//                       "How old are you?",
//                       style: AppTextStyle.headingMedium,
//                     ),
//                     AppShowCaseWidget(
//                       showcaseKey: controller.kidAgeKey,
//                       description: "How old are you? 🎂",
//                       backgroundImage:
//                           "assets/center_spot_light_background.png",
//                       tooltipPosition: TooltipPosition.top,
//                       disposeOnTap: false,
//                       disableDefaultTargetGestures: false,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 130.w),
//                         child: SizedBox(
//                           height: 50.h,
//                           // width: double.infinity,
//                           child: ListView.builder(
//                               itemCount:
//                                   controller.addChildController.ageList.length,
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 return Obx(() {
//                                   return Align(
//                                     alignment: Alignment.center,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         controller.addChildController
//                                                 .selectedAge.value =
//                                             controller.addChildController
//                                                 .ageList[index];
//
//                                         // Store the same value in _addChildController.childAge
//                                         controller.addChildController.childAge
//                                                 .value =
//                                             controller.addChildController
//                                                 .ageList[index];
//
//                                         // Set the selected age in kidSectionOnboardingController
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(4.0),
//                                         child: Container(
//                                           height: 50,
//                                           width: 50,
//                                           decoration: BoxDecoration(
//                                             color: controller.addChildController
//                                                         .selectedAge.value ==
//                                                     controller
//                                                         .addChildController
//                                                         .ageList[index]
//                                                 ? AppColors.textPrimary
//                                                 : AppColors.textOnPrimary,
//                                             borderRadius:
//                                                 BorderRadius.circular(50.r),
//                                             border: Border.all(
//                                               color: controller
//                                                           .addChildController
//                                                           .selectedAge
//                                                           .value ==
//                                                       controller
//                                                           .addChildController
//                                                           .ageList[index]
//                                                   ? AppColors.textOnPrimary
//                                                   : AppColors.textPrimary,
//                                             ),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               controller.addChildController
//                                                   .ageList[index],
//                                               style: AppTextStyle.headingMedium.copyWith(
//                                                   color: controller
//                                                               .addChildController
//                                                               .selectedAge
//                                                               .value ==
//                                                           controller
//                                                               .addChildController
//                                                               .ageList[index]
//                                                       ? AppColors.textOnPrimary
//                                                       : AppColors.textPrimary),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 });
//                               }),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 20.w),
//                       child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: GreenNextButton(
//                             onTap: () {
//                               if (controller.addChildController.selectedAge
//                                   .value.isEmpty) {
//                                 ToastUtil.showToast("Please enter your Age");
//                               } else {
//                                 controller.increaseSpotLightIndex(index: 2);
//                                 ShowCaseWidget.of(context).startShowCase([
//                                   controller.kidavatarListKey,
//                                 ]);
//                               }
//                             },
//                             showSuffix: true,
//                             buttonText: 'Next',
//                           )),
//                     ),
//                   ] else ...[
//                     Stack(
//                       children: [
//                         // Grid and Text
//                         SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 height: 16.h,
//                               ),
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(left: 20.w),
//                                   child: kidBackButton(
//                                     onTap: () {
//                                       controller.decreaseSpotLightIndex();
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 "Pick an avatar that feels just like you 👨‍🎨👑🎭",
//                                 textAlign: TextAlign.center,
//                                 style: AppTextStyle.headingLarge,
//                               ),
//                               SizedBox(height: 10.h),
//                               AppShowCaseWidget(
//                                 showcaseKey: controller.kidavatarListKey,
//                                 description: "Choose an Avatar",
//                                 backgroundImage:
//                                     "assets/center_spot_light_background.png",
//                                 tooltipPosition: TooltipPosition.top,
//                                 disposeOnTap: false,
//                                 disableDefaultTargetGestures: false,
//                                 child: SizedBox(
//                                     height: 120.h,
//                                     width: 450.w,
//                                     child: _buildAvatarGrid(context)),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Buttons at the bottom
//                         Positioned(
//                           bottom: 0.h,
//                           left: 0.w,
//                           right: 0.w,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20.w),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 OrangeSkipButton(
//                                   onTap: () async {
//                                     if (!controller.isNormalLoading.value) {
//                                       controller.isNormalLoading.value = true;
//                                       controller.addChildController.createKid();
//                                     }
//                                     Get.off(() => KidHomeScreen());
//                                   },
//                                 ),
//                                 Padding(
//                                   padding:
//                                       EdgeInsets.only(right: 20.w, left: 20.w),
//                                   child: GreenDoneButton(
//                                     onTap: () async {
//                                       if (controller.selectedAvatar.value ==
//                                           -1) {
//                                         ToastUtil.showToast(
//                                             "Please select an avatar");
//                                         return;
//                                       }
//                                       if (!controller.isNormalLoading.value) {
//                                         controller.isNormalLoading.value = true;
//                                         await controller.addChildController
//                                             .createKid();
//                                         // await authController
//                                         //     .parentFirebaseFunctions
//                                         //     .addKidAndUpdateParent();
//                                       }
//                                       Get.off(() => KidHomeScreen());
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ]
//                 ]),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildAvatarGrid(BuildContext context) {
//     return Obx(() {
//       if (controller.addChildController.isLoadingAvatars.value) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//       return GridView.builder(
//         shrinkWrap: true,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           crossAxisSpacing: 16.w,
//           mainAxisSpacing: 16.h,
//         ),
//         itemCount: controller.addChildController.avatars.length + 1,
//         // +1 for camera option
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             // Camera/Gallery picker option
//             return Obx(() => GestureDetector(
//                   onTap: () => _showImagePicker(context),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: controller.addChildController.kidImagePath.value
//                                 .isNotEmpty
//                             ? Colors.purple
//                             : Colors.transparent,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(60.r),
//                     ),
//                     child: controller
//                             .addChildController.kidImagePath.value.isNotEmpty
//                         ? Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(60.r),
//                                 child: Image.file(
//                                   File(controller
//                                       .addChildController.kidImagePath.value),
//                                   height: 30.h,
//                                   width: 30.h,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               if (controller.selectedAvatar.value == -1)
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(60.r),
//                                     color: Colors.black38,
//                                   ),
//                                   child: Icon(
//                                     Icons.check,
//                                     color: Colors.white,
//                                     size: 24.sp,
//                                   ),
//                                 ),
//                             ],
//                           )
//                         : Container(
//                             decoration: BoxDecoration(
//                               color: AppColors.iconPrimary,
//                               borderRadius: BorderRadius.circular(60.r),
//                             ),
//                             child: Icon(
//                               Icons.add_a_photo,
//                               color: Colors.white,
//                               size: 24.sp,
//                             ),
//                           ),
//                   ),
//                 ));
//           }
//
//           // Predefined avatars
//           final avatarIndex = index - 1;
//           // In the predefined avatars section of _buildAvatarGrid
//           return Obx(
//             () => GestureDetector(
//               onTap: () {
//                 controller.addChildController.selectAvatar(avatarIndex);
//                 controller.selectedAvatar.value =
//                     avatarIndex.toString(); // Add this line
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: controller.addChildController.selectedAvatar.value ==
//                             avatarIndex
//                         ? Colors.purple
//                         : Colors.transparent,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(60.r),
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(60.r),
//                       child: CachedNetworkImage(
//                         imageUrl:
//                             controller.addChildController.avatars[avatarIndex],
//                         height: 30.h,
//                         width: 30.h,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: AppColors.buttonPrimary,
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           decoration: BoxDecoration(
//                             color: AppColors.iconPrimary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(60.r),
//                           ),
//                           child: Icon(
//                             Icons.error_outline,
//                             color: AppColors.iconPrimary,
//                             size: 24.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (controller.addChildController.selectedAvatar.value ==
//                         avatarIndex) // Updated this condition
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(60.r),
//                           color: Colors.black38,
//                         ),
//                         child: Icon(
//                           Icons.check,
//                           color: Colors.white,
//                           size: 24.sp,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   void _showImagePicker(BuildContext context) {
//     ImagePickerBottomSheet.show(
//       onCameraTap: () =>
//           controller.addChildController.pickImage(source: ImageSource.camera),
//       onGalleryTap: () =>
//           controller.addChildController.pickImage(source: ImageSource.gallery),
//     );
//   }
// }
