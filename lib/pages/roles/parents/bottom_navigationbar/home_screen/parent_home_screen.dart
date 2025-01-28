import 'dart:io';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_screen.dart';
import 'package:coin_kids/pages/roles/parents/all_childs/all_children_page.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/roles/parents/drawer/parent_drawer.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/kid_profile_management_page.dart';
import 'package:coin_kids/theme/components/App_small_button.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../../theme/color_theme.dart';
import '../../../kid_landscape_section/common_funcitons.dart/common_funcitons.dart';

class ParentsHomeScreen extends StatefulWidget {
  const ParentsHomeScreen({super.key});

  @override
  State<ParentsHomeScreen> createState() => _ParentsHomeScreenState();
}

class _ParentsHomeScreenState extends State<ParentsHomeScreen> {
  final   parentController =
      Get.put(ParentController());

  final bottomNavigationBarController =
      Get.put(ParentNavigationBarController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      parentController.fetchParentDetails();
      parentController.fetchKids();
      bottomNavigationBarController.loadAvatarFromPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    PortraitOrientation();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.h,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor:
                Colors.transparent, // Make the status bar transparent
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
                    transition:
                        Transition.leftToRightWithFade, // Custom transition
                    duration:
                        const Duration(milliseconds: 300), // Animation duration
                  );
                },
                child: Obx(() {
                  if (bottomNavigationBarController
                      .customAvatarPath.value.isNotEmpty) {
                    // Show the selected image
                    return Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(File(bottomNavigationBarController
                              .customAvatarPath.value)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    // Show the default SVG
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
                  Obx(() => Text(
                        parentController.parentName.value,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 18.sp),
                      )),
                  Text("Welcome 👋",
                      style: Theme.of(context).textTheme.bodySmall)
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
              if (parentController.isLoading.value) {
                // Show loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (parentController.kidsList.isEmpty) {
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
                                side: BorderSide(
                                    width: 1.w, color: const Color(0xFFCBE4F3)),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              shadows: [
                                BoxShadow(
                                    color: const Color(0x0F000000),
                                    blurRadius: 6.r,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 0)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Almost There!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          color: CustomThemeData()
                                              .primaryButtonColor,
                                          fontSize: 18.sp)),
                              const SizedBox(height: 10),
                              Text("Starting by adding your first child.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: CustomThemeData()
                                              .primaryTextColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14.sp)),
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
                        itemCount: parentController.kidsList.length +
                            1, // Add 1 for "Add" circle at the end
                        itemBuilder: (context, index) {
                          if (index == parentController.kidsList.length) {
                            // Last item: Add circle
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (parentController
                                      .kidsList.isNotEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "You already have a child added.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor:
                                          AppColors.textHighlighted,
                                      textColor: Colors.white,
                                      fontSize: 16.sp,
                                    );
                                  } else {
                                    Get.to(() => AddChildScreen());
                                  }
                                },

// Navigate to add child screen
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.purple, width: 2),
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
                            final kid = parentController.kidsList[
                                index]; // Use index directly for kidsList

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => KidProfileManagementPage(
                                        childId: '${kid['id']}',
                                      ));
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: kid['avatar']
                                              .startsWith('/')
                                          ? FileImage(File(kid['avatar']))
                                          : (kid['avatar']
                                                      .startsWith('assets') &&
                                                  !kid['avatar']
                                                      .endsWith('.svg'))
                                              ? AssetImage(kid['avatar'])
                                              : kid['avatar'].startsWith('http')
                                                  ? NetworkImage(kid['avatar'])
                                                  : null,
                                      child: kid['avatar'].endsWith('.svg')
                                          ? SvgPicture.asset(
                                              kid['avatar'],
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      kid['name'] ?? 'No Name',
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
                                  Get.to(() => AllChildrenPage());
                                },
                                size: Size(183.w, 50.h),
                                text: "Quick Transfer",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Roboto",
                              ),
                          
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Send ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: CustomThemeData()
                                                    .primaryButtonColor,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                          text: 'or ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: CustomThemeData()
                                                      .secondaryTextColor,
                                                  fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text: 'remove ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: CustomThemeData()
                                                      .primaryButtonColor,
                                                  fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text:
                                              'money from your child\'s account',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: CustomThemeData()
                                                      .secondaryTextColor,
                                                  fontWeight: FontWeight.w600)),
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
              );
            },
          ),
        ));
  }
}


