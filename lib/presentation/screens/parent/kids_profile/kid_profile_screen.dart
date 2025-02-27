import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/kid_profile_threed_btn.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:coin_kids/presentation/screens/parent/edit_child/edit_child_screen.dart';
import 'package:coin_kids/presentation/screens/parent/kids_profile/widgets/basic_info_widget.dart';
import 'package:coin_kids/presentation/screens/parent/kids_profile/widgets/goals_tab_widget.dart';
import 'package:coin_kids/presentation/screens/parent/kids_profile/widgets/jars_tab_widget.dart';
import 'package:coin_kids/presentation/screens/parent/kids_profile/widgets/notification_tab_widget.dart';
import 'package:coin_kids/presentation/screens/parent/transfer/quick_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class KidProfileScreen extends GetView<KidProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${controller.appState.currentKid.value!.name}'s Profile",
        centerTitle: true,
        showBackButton: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BasicInfoWidget(),
              Padding(
                padding: EdgeInsets.only(top: 45.h, bottom: 46.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    kidMainButtons(
                      title: 'Quick\nTransfer',
                      assetPath: 'assets/kidManageIcons/quickTransfer.svg',
                      onTap: () => Get.to(() => QuickTransferPage(
                          // kidId: kidId,
                          // docData: kid.toJson(),
                          )),
                    ),
                    kidMainButtons(
                      title: 'Schedule\nAllowance',
                      assetPath: 'assets/kidManageIcons/scheduleAllowance.svg',
                      onTap: () {
                        ToastUtil.showToast("Coming soon...");
                      },
                    ),
                    kidMainButtons(
                      title: 'Edit\nProfile',
                      assetPath: 'assets/kidManageIcons/editProfile.svg',
                      onTap: () => Get.to(() => EditChildScreen()),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabSwitcher(KidProfileTabs.Jars, 'assets/kidManageIcons/coin.svg'),
                    _buildTabSwitcher(KidProfileTabs.Notifications, 'assets/Frame.svg'),
                    _buildTabSwitcher(KidProfileTabs.Goals, 'assets/kidManageIcons/goalIcon.svg'),
                  ],
                ),
              ),
              Obx(() {
                switch (controller.currentType.value) {
                  case KidProfileTabs.Jars:
                    return JarsTabWidget();
                  case KidProfileTabs.Notifications:
                    return NotificationTabWidget();
                  case KidProfileTabs.Goals:
                    return GoalsTabWidget();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher(KidProfileTabs type, String assetPath) {
    return Obx(() => _tabSwitcherContainer(
          containerColor: controller.currentType.value == type ? Colors.purple : const Color(0xFFEDFAFF),
          assetPath: assetPath,
          onTap: () => controller.currentType.value = type,
          topRight: type == KidProfileTabs.Goals ? 10.0 : 0.0,
          bottomRight: type == KidProfileTabs.Goals ? 10.0 : 0.0,
          topLeft: type == KidProfileTabs.Jars ? 10.0 : 0.0,
          bottomLeft: type == KidProfileTabs.Jars ? 10.0 : 0.0,
        ));
  }

  Widget _tabSwitcherContainer({
    required Color containerColor,
    required String assetPath,
    required Function() onTap,
    required double topRight,
    required double bottomRight,
    required double topLeft,
    required double bottomLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(Get.context!).width / 3.5,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(color: Colors.grey, width: 0.5.w),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: SvgPicture.asset(
            assetPath,
            height: 22.h,
            width: 22.w,
          ),
        ),
      ),
    );
  }
}
