import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/portrait_orientation.dart';
import 'package:coin_kids/presentation/controllers/common/role_selection_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class ParentBaseScreen extends GetView<ParentBaseController> {
  ParentBaseScreen({super.key});
  final RoleSelectionController roleSelectionController = Get.find<RoleSelectionController>();

  @override
  Widget build(BuildContext context) {
    PortraitOrientation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentIndex.value != 0) {
        controller.currentIndex.value = 0;
      }
    });

    return ShowCaseWidget(
      builder: (context) {
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
              if (controller.currentIndex.value == 0 && !controller.isShowcaseShown.value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ShowCaseWidget.of(context).startShowCase([controller.kidsZoneShowcaseKey]);
                  controller.isShowcaseShown.value = true;
                });
              }
              return Visibility(
                visible: controller.appState.hasKid.value,
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  elevation: 15,
                  currentIndex: controller.currentIndex.value,
                  onTap: (index) {
                    if (index == 3) {
                      roleSelectionController.finalizeRole(UserRole.CHILD);
                    } else {
                      controller.currentIndex.value = index;
                    }
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.textHighlighted,
                  unselectedItemColor: Colors.grey,
                  items: [
                    _buildNavBarItem(
                      iconPath: 'assets/home_icon.svg',
                      label: 'Home',
                      index: 0,
                    ),
                    _buildNavBarItem(
                      iconPath: 'assets/messages_icon.svg',
                      label: 'Messages',
                      index: 1,
                    ),
                    _buildNavBarItem(
                      iconPath: 'assets/cart_icon.svg',
                      label: 'Shop',
                      index: 2,
                    ),
                    _buildNavBarItem(
                      iconPath: 'assets/Coin.svg',
                      label: 'Kids Zone',
                      index: 3,
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: index == 3
          ? Showcase(
        tooltipBackgroundColor: AppColors.textHighlighted,
        descTextStyle:AppTextStyle.headingSmall.copyWith(color: Colors.white),
        key: controller.kidsZoneShowcaseKey,
        description: "Switch to Kids Zone to access children's features!",
        child: SvgPicture.asset(
          iconPath,
          width: 24.w,
          height: 24.h,
          color: null,
        ),
      )
          : SvgPicture.asset(
        iconPath,
        width: 24.w,
        height: 24.h,
        color: controller.currentIndex.value == index
            ? Colors.purple
            : Colors.grey,
      ),
      label: label,
    );
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
            Icon(Icons.exit_to_app,
                color: AppColors.textPrimary, size: 28.sp),
            SizedBox(width: 8.w),
            Text(
              'Exit App',
              style:
              TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
