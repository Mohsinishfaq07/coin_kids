import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_controller.dart';
import 'package:coin_kids/pages/roles/parents/drawer/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app_assets.dart';
import '../../../../theme/color_theme.dart';
import '../../../../theme/text_theme.dart';

class ParentDrawer extends StatefulWidget {
  ParentDrawer();

  @override
  State<ParentDrawer> createState() => _ParentDrawerState();
}

class _ParentDrawerState extends State<ParentDrawer> {
  @override
  void initState() {
    super.initState();
   bottomNavigationBarContrller. loadAvatarFromPreferences();
  }

  final ToggleRowController toggleRowController =
      Get.put(ToggleRowController());
  final bottomNavigationBarContrller =
      Get.put(BottomNavigationbarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Light blue background
        body: Container(
      decoration: const BoxDecoration(
        gradient: AppColors.background,
      ),
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 46.h),
            child: SvgPicture.asset(
              AppAssets.cloudImageSvg,
              // height: 252.h,
              width: 360.w,
            ),
          ),
        ),
        StreamBuilder(
            stream:
                firestoreOperations.parentFirebaseFunctions.fetchParentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No data found.'));
              }

              Map<String, dynamic> data = snapshot.data!;
              firebaseAuthController.username.value = data['name'];
              firebaseAuthController.birthday.value = data['dob'];
              firebaseAuthController.selectedGender.value = data['gender'];
              return originalWidget(parentData: data);
            }),
      ]),
    ));
  }

  // after data fetched widget
  originalWidget({required Map<String, dynamic> parentData}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            // Header with profile information
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 54.h,
                  ),
                  // Stack(
                  //   alignment: Alignment.bottomRight,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () async {
                  //         await pickCustomAvatar();
                  //       },
                  //       child: SizedBox(
                  //         height: 100.h,
                  //         width: 100.w,
                  //         child: SvgPicture.asset(AppAssets.drawerIconSvg),
                  //       ),
                  //     ),
                  //     CircleAvatar(
                  //         radius: 15.r,
                  //         backgroundColor: const Color(0xFFFEC84B),
                  //         child: SvgPicture.asset(AppAssets.pencilIconSvg)),
                  //   ],
                  // ),

                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Pick an image and update the avatar
                          await bottomNavigationBarContrller. pickCustomAvatar();
                        },
                        child: Obx(() {
                          if (bottomNavigationBarContrller.customAvatarPath.value.isNotEmpty) {
                            // Show the selected image
                            return Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      FileImage(File(bottomNavigationBarContrller.customAvatarPath.value)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            // Show the default SVG
                            return SvgPicture.asset(
                              AppAssets.drawerIconSvg,
                              height: 100.h,
                              width: 100.w,
                            );
                          }
                        }),
                      ),
                      CircleAvatar(
                        radius: 15.r,
                        backgroundColor: const Color(0xFFFEC84B),
                        child: SvgPicture.asset(AppAssets.pencilIconSvg),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),
                  Text(
                    "${parentData['name']}",
                    style: AppTextStyle.headingLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        fontSize: 18.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            // My Profile Section
            _buildSectionHeader("My Profile", onEdit: () {
              Get.to(() => ParentUpdateProfileScreen(
                    parentData: parentData,
                  ));
            }),
            Container(
              width: 328.w,
              height: 156.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDFAFF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6.r,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileRow("Full name", "${parentData['name']}",
                        "assets/drawer_svgs/3p.svg"),
                    SizedBox(
                      height: 26.h,
                    ),
                    _buildProfileRow("Date of birth", "${parentData['dob']}",
                        "assets/drawer_svgs/calendar_month.svg"),
                    SizedBox(
                      height: 26.h,
                    ),
                    _buildProfileRow("Gender", "${parentData['gender']}",
                        "assets/drawer_svgs/wc.svg"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 23.h),

            // Personalization Section
            _buildSectionHeader("Personalization"),
            Container(
              width: 328.w,
              height: 125.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDFAFF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileRowWithArrow(
                        "Change Language", "assets/drawer_svgs/language.svg"),
                    SizedBox(
                      height: 31.h,
                    ),
                    _buildProfileRowWithArrow(
                        "Parent Zone Pin", "assets/drawer_svgs/password_2.svg"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 23.h),

            // Notifications Section
            _buildSectionHeader("Notifications"),
            Container(
              width: 328.w,
              height: 120.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDFAFF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleRow(
                      "Goal Achievement",
                      "assets/drawer_svgs/flag_check.svg",
                      toggleRowController.toggleValue, // Reactive state
                    ),
                    _buildToggleRow(
                      "Money Request",
                      "assets/drawer_svgs/euro.svg",
                      toggleRowController.toggleValue1, // Reactive state
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 23.h),

            // Others Section
            _buildSectionHeader("Others"),

            Container(
                width: 328.w,
                height: 170.h,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEDFAFF),
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 6,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProfileRowWithArrow(
                            "Share app", "assets/drawer_svgs/share.svg",
                            showArrow: false, iconSize: 24.sp),
                        SizedBox(
                          height: 31.h,
                        ),
                        _buildProfileRowWithArrow(
                            "Feedback", "assets/drawer_svgs/rate_review.svg",
                            showArrow: false, iconSize: 24.sp),
                        SizedBox(
                          height: 31.h,
                        ),
                        _buildProfileRowWithArrow(
                            "Privacy Policy", "assets/drawer_svgs/lock.svg",
                            showArrow: false, iconSize: 24.sp),
                      ]),
                )),

            SizedBox(height: 30.h),

            // Version
            Text(
              "Version 1.0.1",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  // Build section header
  Widget _buildSectionHeader(String title, {VoidCallback? onEdit}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Row(
                children: [
                  SvgPicture.asset(AppAssets.pencilIconSvg),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Build profile row (key-value pair)
  Widget _buildProfileRow(String title, String value, String iconPath) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath, // Path to your SVG asset
                color: Colors.purple,
                height: 20.h, // Adjust the size as needed
                width: 20.w, // Adjust the size as needed
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Build profile row with arrow
  Widget _buildProfileRowWithArrow(
    String title,
    String iconPath, {
    bool showArrow = true,
    double iconSize = 20.0, 
    VoidCallback? onTap, // New parameter for onTap callback
   }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath, // Path to your SVG asset
                  color: Colors.purple,
                  height: iconSize.h, // Use the passed size or default size
                  width: iconSize.w, // Use the passed size or default size
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: iconSize.sp, // Use the passed size or default size
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  // Build toggle row
  Widget _buildToggleRow(String title, String iconPath, RxBool toggleValue) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath, // Path to your SVG asset
                  color: Colors.purple,
                  height: 24.h, // Adjust the size as needed
                  width: 24.w, // Adjust the size as needed
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Obx(() => Switch(
                  value: toggleValue.value, // Use reactive value
                  onChanged: (newValue) {
                    toggleValue.value = newValue; // Update the value reactively
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.purple,
                  inactiveTrackColor: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}

class ToggleRowController extends GetxController {
  // Create an RxBool to manage the state of the Switch
  var toggleValue = true.obs;
  var toggleValue1 = true.obs;
}
