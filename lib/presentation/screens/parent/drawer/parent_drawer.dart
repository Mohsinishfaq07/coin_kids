import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
import 'package:coin_kids/presentation/controllers/parent/DrawerController.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/update_parent_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ParentDrawer extends GetView<ParentDrawerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              width: 360.w,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                // Header with profile information
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            await controller.authService.signOut();
                          },
                          child: Container(
                              width: 54.w,
                              height: 34.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: AppColors.textPrimary,
                              ),
                              margin: EdgeInsets.all(12.r),
                              child: const Center(
                                child: Icon(
                                  Icons.logout,
                                  color: AppColors.textOnPrimary,
                                ),
                              )),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _buildProfileImage(),
                          GestureDetector(
                            onTap: () async {
                              ImagePickerBottomSheet.show(
                                onCameraTap: () => controller.pickImage(source: ImageSource.camera),
                                onGalleryTap: () => controller.pickImage(source: ImageSource.gallery),
                              );
                            },
                            child: CircleAvatar(
                              radius: 15.r,
                              backgroundColor: const Color(0xFFFEC84B),
                              child: SvgPicture.asset(AppAssets.pencilIconSvg),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        controller.appState.currentParent.value!.name,
                        style: AppTextStyle.headingLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                // My Profile Section
                _buildSectionHeader("My Profile", onEdit: () {
                  Get.to(
                    () => UpdateParentProfile(),
                  );
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
                        _buildProfileRow("Full name", controller.appState.currentParent.value!.name, "assets/drawer_svgs/3p.svg"),
                        SizedBox(height: 26.h),
                        _buildProfileRow(
                          "Date of birth",
                          controller.appState.currentParent.value!.dob == 0
                              ? "Not Specified"
                              : DateFormat('d MMM, y').format(DateTime.fromMillisecondsSinceEpoch(controller.appState.currentParent.value!.dob)),
                          "assets/drawer_svgs/calendar_month.svg",
                        ),
                        SizedBox(height: 26.h),
                        _buildProfileRow("Gender", controller.appState.currentParent.value!.gender, "assets/drawer_svgs/wc.svg"),
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
                        _buildProfileRowWithArrow("Change Language", "assets/drawer_svgs/language.svg"),
                        SizedBox(
                          height: 31.h,
                        ),
                        _buildProfileRowWithArrow("Parent Zone Pin", "assets/drawer_svgs/password_2.svg"),
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
                        Obx(() {
                          return _buildToggleRow(
                            "Goal Achievement",
                            "assets/drawer_svgs/flag_check.svg",
                            controller.goalAchievementSwitch, // Reactive state
                          );
                        }),
                        Obx(() {
                          return _buildToggleRow(
                            "Money Request",
                            "assets/drawer_svgs/euro.svg",
                            controller.moneyRequestSwitch, // Reactive state
                          );
                        }),
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
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        _buildProfileRowWithArrow("Share app", "assets/drawer_svgs/share.svg", showArrow: false, iconSize: 24.sp),
                        SizedBox(
                          height: 31.h,
                        ),
                        _buildProfileRowWithArrow("Feedback", "assets/drawer_svgs/rate_review.svg", showArrow: false, iconSize: 24.sp),
                        SizedBox(
                          height: 31.h,
                        ),
                        _buildProfileRowWithArrow("Privacy Policy", "assets/drawer_svgs/lock.svg", showArrow: false, iconSize: 24.sp),
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
        )
      ]),
    ));
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
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp, fontWeight: FontWeight.w700),
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
              style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),
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
            Switch(
              value: toggleValue.value,
              // Use reactive value
              onChanged: (newValue) {
                toggleValue.value = newValue; // Update the value reactively
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.purple,
              inactiveTrackColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Obx(() {
      // First try to show local image
      if (controller.appState.currentParent.value!.imageUrl.isNotEmpty) {
        return Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(controller.appState.currentParent.value!.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        );
      } // Then try to show network image
      else {
        return SvgPicture.asset(
          AppAssets.drawerIconSvg,
          height: 100.h,
          width: 100.w,
        );
      }
    });
  }
}
