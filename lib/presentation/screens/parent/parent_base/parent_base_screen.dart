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
    return OrientationAwareBuilder(
      builder: (context, orientation) {
        return OrientationTransition(
          toPortrait: true,
          showInstruction: Get.arguments ?? false == true,
          child: orientation == Orientation.portrait ? _buildParentUI(context, Get.width) : _buildParentUI(context, 360.0),
        );
      },
    );
  }

  Widget _buildParentUI(BuildContext context, screenWidth) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentIndex.value != 0) {
        controller.currentIndex.value = 0;
      }
    });

    return PopScope(
      canPop: false, // Block default back behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await showExitConfirmation(context);
          if (shouldExit) Get.back();
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth),
        child: Scaffold(
          body: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.background,
              ),
              child: Obx(
                () => controller.screens[controller.currentIndex.value],
              ),
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
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Row(
            children: [
              Icon(Icons.exit_to_app, color: AppColors.textPrimary, size: 28.sp),
              SizedBox(width: 8.w),
              Text(
                'Exit App',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to exit the application?',
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              child: Text(
                'Exit',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ) ??
      false;
}
