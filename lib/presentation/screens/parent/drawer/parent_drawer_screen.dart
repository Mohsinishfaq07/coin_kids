import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/share_utils.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:coin_kids/presentation/components/common/image_picker_bottom_sheet.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_drawer_controller.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/change_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ParentDrawer extends GetView<ParentDrawerController> {
  const ParentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParentAppBar(
        title: '',
        showBackButton: true,
        onBackPressed: () {
          Get.back();
        },
        actions: [
          TextButton(
            onPressed: () async {
              await controller.authService.signOut();
              Get.offAllNamed(Routes.signIn);
            },
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(
                AppTextStyle.headingSmall,
              ),
              foregroundColor: WidgetStateProperty.all(AppColors.notificationCritical),
            ),
            child: Text("Logout"),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 46.h),
                child: SvgPicture.asset(
                  Assets.parentBgCloud,
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
                          SizedBox(height: 10.h),
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
                                  child: SvgPicture.asset(Assets.icEdit),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Obx(() {
                            return Text(
                              controller.appState.currentParent.value?.name ?? "UnKnown",
                              style: AppTextStyle.headingLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 18.sp),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // My Profile Section
                    _buildSectionHeader("My Profile", onEdit: () {
                      Get.toNamed(Routes.parentEditProfile);
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                return _buildProfileRow(
                                  "Full name",
                                  controller.appState.currentParent.value?.name ?? "UnKnown",
                                  Assets.icPerson,
                                );
                              }),
                              SizedBox(height: 26.h),
                              Obx(() {
                                return _buildProfileRow(
                                  "Date of birth",
                                  controller.appState.currentParent.value?.dob == null || controller.appState.currentParent.value?.dob == 0
                                      ? "Not Specified"
                                      : DateFormat('d MMM, y').format(DateTime.fromMillisecondsSinceEpoch(controller.appState.currentParent.value?.dob ?? 0)),
                                  Assets.icCalender,
                                );
                              }),
                              SizedBox(height: 26.h),
                              Obx(() {
                                return _buildProfileRow(
                                  "Gender",
                                  controller.appState.currentParent.value?.gender ?? "Not Specified",
                                  Assets.icGender,
                                );
                              }),
                            ],
                          ),
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

                                onTap: () => Get.to(() => ChangeLanguage()),
                                "Languages (coming soon)", Assets.icGlobal, isComingSoon: true),
                            SizedBox(
                              height: 31.h,
                            ),
                            _buildProfileRowWithArrow("Parent Zone Pin", Assets.icPin, onTap: () {
                              Get.toNamed(Routes.parentChangePin);
                            }),
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
                                Assets.icFlag,
                                controller.goalAchievementSwitch,
                                () async {
                                  SharedPreferencesHelper.saveBool(SharedPreferencesHelper.goalAchievementNotificationEnabled, true);
                                },
                              );
                            }),
                            Obx(() {
                              return _buildToggleRow(
                                "Money Request",
                                Assets.icCurrency,
                                controller.moneyRequestSwitch,
                                () {
                                  SharedPreferencesHelper.saveBool(SharedPreferencesHelper.moneyRequestNotificationEnabled, true);
                                },
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
                            _buildProfileRowWithArrow(
                              "Share app",
                              Assets.icShare,
                              showArrow: false,
                              iconSize: 24.sp,
                              onTap: () async {
                                try {
                                  await ShareUtils.shareApp();
                                } catch (e) {
                                  ToastUtil.showToast(
                                    'Failed to share app',
                                    color: AppColors.notificationCritical,
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 31.h,
                            ),
                            _buildProfileRowWithArrow(
                              "Feedback",
                              Assets.icFeedback,
                              showArrow: false,
                              iconSize: 24.sp,
                              onTap: () async {
                                Get.toNamed(Routes.parentFeedback);
                              },
                            ),
                            SizedBox(
                              height: 31.h,
                            ),
                            _buildProfileRowWithArrow(
                              "Privacy Policy",
                              Assets.icLock,
                              showArrow: false,
                              iconSize: 24.sp,
                              onTap: () async {
                                try {
                                  await ShareUtils.openPrivacyPolicy();
                                } catch (e) {
                                  ToastUtil.showToast(
                                    'Failed to open privacy policy',
                                    color: AppColors.notificationCritical,
                                  );
                                }
                              },
                            ),
                          ]),
                        )),

                    SizedBox(height: 24.h),

                    // Version
                    Text(
                      "Version ${controller.appVersion}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            )
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
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp, fontWeight: FontWeight.w700),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.icEdit,
                    colorFilter: ColorFilter.mode(AppColors.iconPrimaryVariant, BlendMode.srcIn),
                  ),
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
                colorFilter: ColorFilter.mode(AppColors.colorPrimary, BlendMode.srcIn),
                height: 20.h, // Adjust the size as needed
                width: 20.w, // Adjust the size as needed
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                maxLines: 1,
                style: AppTextStyle.bodyLarge,
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
    VoidCallback? onTap,
    bool isComingSoon = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath, // Path to your SVG asset
              colorFilter: ColorFilter.mode(
                isComingSoon ? AppColors.iconDisabled : AppColors.colorPrimary,
                BlendMode.srcIn,
              ),
              height: iconSize.h, // Use the passed size or default size
              width: iconSize.w, // Use the passed size or default size
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bodyLarge.copyWith(
                  color: isComingSoon ? AppColors.iconDisabled : AppColors.textPrimary,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: iconSize.sp, // Use the passed size or default size
                color: isComingSoon ? AppColors.iconDisabled : AppColors.iconPrimaryVariant,
              ),
          ],
        ),
      ),
    );
  }

  // Build toggle row
  Widget _buildToggleRow(String title, String iconPath, RxBool toggleValue, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath, // Path to your SVG asset
              colorFilter: ColorFilter.mode(AppColors.colorPrimary, BlendMode.srcIn),
              height: 24.h, // Adjust the size as needed
              width: 24.w, // Adjust the size as needed
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16.w),
            Switch(
              value: toggleValue.value,
              // Use reactive value
              onChanged: (newValue) {
                toggleValue.value = newValue; // Update the value reactively
              },
              activeColor: Colors.white,
              activeTrackColor: AppColors.colorPrimary,
              inactiveTrackColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Obx(() {
      return CircleAvatarWidget(
        imagePath: controller.appState.currentParent.value?.imageUrl ?? "",
        imageType: ImageType.network,
        backgroundColor: AppColors.iconPrimary,
        size: 100.r,
      );
    });
  }
}
