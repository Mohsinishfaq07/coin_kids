import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/widgets/orientation_transition.dart';
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
  @override
  Widget build(BuildContext context) {
    return OrientationAwareBuilder(
      builder: (context, orientation) {
        return OrientationTransition(
          toPortrait: true,
          showInstruction: Get.arguments ?? false == true,
          child: orientation == Orientation.portrait ? _buildParentUI(context) : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildParentUI(BuildContext context) {
    print("Parent screen size: h = ${1.sh}, w = ${1.sw}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentIndex.value != 0) {
        controller.currentIndex.value = 0;
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 0) {
          controller.currentIndex.value = 0;
          return false;
        }
        bool shouldExit = await _showExitConfirmation(context);
        return shouldExit;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Obx(
            () => controller.screens[controller.currentIndex.value],
          ),
        ),
        bottomNavigationBar: Obx(() {
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
        }),
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
      color: index == 3
          ? null
          : isSelected
              ? AppColors.colorPrimary
              : Colors.grey,
    );

    Widget navItem = InkWell(
      onTap: () {
        if (index == 3) {
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
            icon,
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

    if (!controller.hasShownKidsZoneShowcase.value && !controller.hasAssignedGlobalKeyForShowcase.value && index == 3) {
      controller.hasAssignedGlobalKeyForShowcase.value = true;
      return Showcase(
        key: ShowcaseManager.parentToKidNavShowcaseKey,
        description: "Switch to Kids Zone to access children's features!",
        descriptionAlignment: Alignment.center,
        descriptionTextAlign: TextAlign.center,
        tooltipBackgroundColor: AppColors.colorPrimary,
        descTextStyle: AppTextStyle.headingSmall.copyWith(color: Colors.white),
        child: navItem,
        targetPadding: EdgeInsets.all(6.h),
        tooltipPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
      );
    }

    return navItem;
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
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
}
