import 'dart:io';

import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/utils/portrait_orientation.dart';
import 'package:coin_kids/presentation/components/common/App_small_button.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:coin_kids/presentation/screens/parent/add_child/add_child_screen.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/parent_drawer_screen.dart';
import 'package:coin_kids/presentation/screens/parent/kids_profile/kid_profile_screen.dart';
import 'package:coin_kids/presentation/screens/parent/transfer/quick_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParentsHomeScreen extends GetView<ParentHomeController> {
  @override
  Widget build(BuildContext context) {
    PortraitOrientation();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.h,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
          backgroundColor: const Color(0xFFCAF0FF),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    ParentDrawer(),
                    transition: Transition.leftToRightWithFade,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                child: Obx(() {
                  if (controller.appState.currentParent.value != null && controller.appState.currentParent.value!.imageUrl.isNotEmpty) {
                    return Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(controller.appState.currentParent.value!.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return SvgPicture.asset(
                      AppAssets.drawerIconSvg,
                      height: 40.h,
                      width: 40.w,
                    );
                  }
                }),
              ),
              SizedBox(width: 7.5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Text(
                      controller.appState.currentParent.value?.name ?? "Null",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
                    );
                  }),
                  Text("Welcome 👋", style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                // Show loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.kidsList.isEmpty) {
                // No kids available
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 51.h,
                            bottom: 81.h,
                          ),
                          child: SvgPicture.asset(
                            AppAssets.appLogoSvg,
                            height: 50.h,
                          ),
                        ),
                        Container(
                          height: 177.h,
                          width: 328.w,
                          decoration: ShapeDecoration(
                              color: const Color(0xFFEDFAFF),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              shadows: [BoxShadow(color: const Color(0x0F000000), blurRadius: 6.r, offset: const Offset(0, 0), spreadRadius: 0)]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Almost There!", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: CustomThemeData().primaryButtonColor, fontSize: 18.sp)),
                              const SizedBox(height: 10),
                              Text("Starting by adding your first child.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontWeight: FontWeight.w800, fontSize: 14.sp)),
                              SizedBox(height: 26.h),
                              AppSmallButton(
                                onPressed: () {
                                  Get.to(() => AddChildScreen());
                                },
                                text: 'Add child',
                              )
                              // CustomButton(

                              //     width: 150.w,
                              //     text: 'Add Child',
                              //     onPressed: () {
                              //       Get.to(() => AddChildScreen());
                              //     }
                              //     //controller.navigateToAddChild,
                              //     ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Display list of kids
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Image.asset(
                          "assets/logo.png", // Ensure the image is in the 'assets' folder and added to pubspec.yaml
                          height: 50,
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Family Profiles ',
                            style: TextStyle(
                              color: const Color(0xFF015486),
                              fontSize: 14.sp,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                      SizedBox(
                        height: 150, // Set a fixed height for the horizontal list
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.kidsList.length + 1, // Add 1 for "Add" circle at the end
                          itemBuilder: (context, index) {
                            if (index == controller.kidsList.length) {
                              // Last item: Add circle
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.kidsList.isNotEmpty) {
                                      ToastUtil.showToast("You have already added a child");
                                    } else {
                                      Get.to(() => AddChildScreen());
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.purple, width: 2),
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(14.0),
                                          child: Icon(
                                            Icons.add, // Add icon
                                            color: AppColors.buttonPrimary,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Add Member\n(Coming soon)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13.sp,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 1.38,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              // Other items: Display kids' data
                              final kid = controller.kidsList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => KidProfileScreen());
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: kid.avatar.startsWith('/')
                                            ? FileImage(File(kid.avatar))
                                            : (kid.avatar.startsWith('assets') && !kid.avatar.endsWith('.svg'))
                                                ? AssetImage(kid.avatar)
                                                : kid.avatar.startsWith('http')
                                                    ? NetworkImage(kid.avatar)
                                                    : null,
                                        child: kid.avatar.endsWith('.svg')
                                            ? SvgPicture.asset(
                                                kid.avatar,
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        kid.name,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13.sp,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w600,
                                          height: 1.38,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: Container(
                            height: 200.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFCBE5F4),
                                ),
                                color: const Color(0xFFEDFAFF),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppSmallButton(
                                  onPressed: () {
                                    Get.to(() => QuickTransferPage());
                                  },
                                  size: Size(183.w, 50.h),
                                  text: "Quick Transfer",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Send ',
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().primaryButtonColor, fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(text: 'or ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600)),
                                        TextSpan(text: 'remove ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().primaryButtonColor, fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: 'money from your child\'s account',
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
