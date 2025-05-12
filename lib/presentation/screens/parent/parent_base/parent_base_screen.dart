import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/widgets/orientation_transition.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/main.dart';
import 'package:coin_kids/presentation/components/parent/parent_exit_dialog.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class ParentBaseScreen extends GetView<ParentBaseController> {
  ParentBaseScreen({super.key});

  final GlobalKey _kidZoneButtonShowcaseKey = GlobalKey();
  final Rx<Offset> _kidZoneButtonOffset = Offset(0, 0).obs;
  bool _hasStartedShowcase = false; // Add this line

  // final RxBool isShowcaseVisible = false.obs;

  void _getWidgetCenter(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        Offset position = renderBox.localToGlobal(Offset.zero);
        Size size = renderBox.size;
        Offset center = position + Offset(size.width / 2, size.height / 2);
        _kidZoneButtonOffset.value = center;
      }
    });
  }

  void _startShowcase(BuildContext context) async {
    if (_hasStartedShowcase) return; // Don't run again
    _hasStartedShowcase = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasShownKidsZoneShowcase = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasShownKidsZoneShowcase) ?? false;
      if (!hasShownKidsZoneShowcase && controller.showKidsZoneShowcase.value == true) {
        _getWidgetCenter(_kidZoneButtonShowcaseKey);
        //    isShowcaseVisible.value = true; // show hand overlay
        ShowCaseWidget.of(context).startShowCase([_kidZoneButtonShowcaseKey]);
        await Future.delayed(Duration(seconds: 3)); // Optional auto-hide
        //    isShowcaseVisible.value = false;
        await SharedPreferencesHelper.saveBool(SharedPreferencesHelper.hasShownKidsZoneShowcase, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.log("UI_TAG Parent Base");
    bool shouldShowInstruction = false;
    if (Get.arguments != null && Get.arguments is bool) {
      shouldShowInstruction = Get.arguments as bool;
    }
    return OrientationAwareBuilder(
      builder: (context, orientation) {
        return OrientationTransition(
          toPortrait: true,
          showInstruction: shouldShowInstruction,
          // showInstruction: Get.arguments ?? false == true,
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
          bool shouldExit = await ParentExitDialog.show(context);
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
          bool shouldExit = await ParentExitDialog.show(context);
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
              disableBarrierInteraction: true,
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
                          SizedBox(
                            width: Get.width / 4,
                            child: _buildNavItem(
                              iconPath: Assets.icHome,
                              label: 'Home',
                              index: 0,
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 4,
                            child: _buildNavItem(
                              iconPath: Assets.icMessage,
                              label: 'Messages',
                              index: 1,
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 4,
                            child: _buildNavItem(
                              iconPath: Assets.icCart,
                              label: 'Shop',
                              index: 2,
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 4,
                            child: _buildNavItem(
                              iconPath: Assets.icCoinStar,
                              label: 'Kids Zone',
                              index: 3,
                            ),
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
        switch (index) {
          case 0:
            controller.analytics.logParentHomeTabClicked(AnalyticsScreenNames.parentBase);
            break;
          case 1:
            controller.analytics.logParentNotificationTabClicked(AnalyticsScreenNames.parentBase);
            break;
          case 2:
            controller.analytics.logParentMarketClicked(AnalyticsScreenNames.parentBase);
            break;
          case 3:
            controller.analytics.logSwitchToKidZoneClicked(AnalyticsScreenNames.parentBase);
            break;
        }

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
                            controller.messagesController.unreadNotificationsCount.value > 9
                                ? "9+"
                                : controller.messagesController.unreadNotificationsCount.value.toString(),
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
      return Stack(
        children: [
          Showcase(
            key: _kidZoneButtonShowcaseKey,
            description: "Switch to Kids Zone to access children's features!",
            descriptionAlignment: Alignment.center,
            descriptionTextAlign: TextAlign.center,
            tooltipBackgroundColor: AppColors.colorPrimary,
            descTextStyle: AppTextStyle.headingSmall.copyWith(color: Colors.white),
            targetPadding: EdgeInsets.all(6.w),
            disableBarrierInteraction: false,
            tooltipPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
            child: navItem,
          ),
          // Obx(() {
          //   if (!isShowcaseVisible.value) return SizedBox.shrink();
          //   return Positioned(
          //     top: -30.h,
          //     right: 20.w,
          //     child: Image.asset(
          //       Assets.icHand,
          //       width: 40.w,
          //       height: 40.w,
          //     ),
          //   );
          // }),
        ],
      );
    }

    return navItem;
  }
}
