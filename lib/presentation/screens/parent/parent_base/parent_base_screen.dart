import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/widgets/orientation_transition.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/main.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class ParentBaseScreen extends GetView<ParentBaseController> {
  ParentBaseScreen({super.key});

  final GlobalKey _kidZoneButtonShowcaseKey = GlobalKey();

  void _startShowcase(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasShownKidsZoneShowcase = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasShownKidsZoneShowcase) ?? false;
      if (!hasShownKidsZoneShowcase && controller.showKidsZoneShowcase.value == true) {
        ShowCaseWidget.of(context).startShowCase([_kidZoneButtonShowcaseKey]);
        await SharedPreferencesHelper.saveBool(SharedPreferencesHelper.hasShownKidsZoneShowcase, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Get.log("UI_TAG Parent Base");

    return OrientationAwareBuilder(
      builder: (context, orientation) {
        return OrientationTransition(
          toPortrait: true,
          showInstruction: Get.arguments ?? false == true,
          child: orientation == Orientation.portrait ? _buildParentUI(context) : _buildEmptyLandscapeUI(context),
        );
      },
    );
  }

  Widget _buildEmptyLandscapeUI(BuildContext context) {
    return PopScope(
      canPop: false, // Block default back behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await showExitConfirmation(context);
          if (shouldExit) Get.back();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.icRotatePortrait,
                  width: 100.w,
                  height: 100.w,
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Please rotate your device to portrait mode',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParentUI(BuildContext context) {
    return PopScope(
      canPop: false, // Block default back behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await showExitConfirmation(context);
          if (shouldExit) Get.back();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Obx(
            () => controller.screens[controller.currentIndex.value],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: ShowCaseWidget(
              onComplete: (index, key) {},
              builder: (context) {
                _startShowcase(context);

                return Obx(() {
                  return Visibility(
                    visible: controller.appState.hasKid.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            iconPath: Assets.icHome,
                            label: 'Home',
                            index: 0,
                          ),
                          _buildNavItem(
                            iconPath: Assets.icMessage,
                            label: 'Messages',
                            index: 1,
                          ),
                          _buildNavItem(
                            iconPath: Assets.icCart,
                            label: 'Shop',
                            index: 2,
                          ),
                          _buildNavItem(
                            iconPath: Assets.icCoinStar,
                            label: 'Kids Zone',
                            index: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    final isSelected = controller.currentIndex.value == index;
    final icon = SvgPicture.asset(
      iconPath,
      width: 24.w,
      height: 24.h,
      colorFilter: index == 3
          ? null
          : ColorFilter.mode(
              isSelected ? AppColors.colorPrimary : Colors.grey,
              BlendMode.srcIn,
            ),
    );

    Widget navItem = InkWell(
      onTap: () {
        if (index == 3) {
          SharedPreferencesHelper.saveBool(SharedPreferencesHelper.showKidsNotifications, true);
          controller.roleController.switchToKidMode(true);
        } else {
          controller.currentIndex.value = index;
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                icon,
                if (index == 1 && controller.messagesController.unreadNotificationsCount.value != 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(5.r))),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            controller.messagesController.unreadNotificationsCount.value > 9 ? "9+" : controller.messagesController.unreadNotificationsCount.value.toString(),
                            style: TextStyle(fontSize: 8.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textHighlighted : Colors.grey,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );

    if (index == 3) {
      return Showcase(
        key: _kidZoneButtonShowcaseKey,
        description: "Switch to Kids Zone to access children's features!",
        descriptionAlignment: Alignment.center,
        descriptionTextAlign: TextAlign.center,
        tooltipBackgroundColor: AppColors.colorPrimary,
        descTextStyle: AppTextStyle.headingSmall.copyWith(color: Colors.white),
        targetPadding: EdgeInsets.all(6.w),
        tooltipPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
        child: navItem,
      );
    }

    return navItem;
  }
}

Future<bool> showExitConfirmation(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 0.85.sw,
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.colorPrimary.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.colorPrimary.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 88.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.colorPrimary.withOpacity(0.2),
                        AppColors.colorPrimary.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.colorPrimary.withOpacity(0.3),
                        AppColors.colorPrimary.withOpacity(0.2),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                ClipOval(
                  child: Image.asset(
                    Assets.appIcon,
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Exit Application',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Are you sure you want to leave the application?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textPrimary.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: AppColors.colorPrimary.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'Stay',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.colorPrimary,
                          AppColors.colorPrimary.withOpacity(0.9),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.colorPrimary.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ) ?? false;
}
