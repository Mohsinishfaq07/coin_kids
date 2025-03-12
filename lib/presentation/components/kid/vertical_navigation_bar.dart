import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VerticalNavBarController extends GetxController {
  final RxInt selectedIndex = 0.obs;
}

class VerticalNavBar extends GetView<VerticalNavBarController> {

  final appbarController = Get.find<KidAppBarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF3FCFF),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationRail(
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (int index) {
              controller.selectedIndex.value = index;
              if(index == 1) {
                appbarController.resetToDefault();
              } else if (index == 2) {
                appbarController.configureForMarket();
              } else {
                appbarController.resetToDefault();
              }
            },
            minWidth: 80.w,
            backgroundColor: Colors.transparent,
            labelType: NavigationRailLabelType.all,
            useIndicator: false,
            groupAlignment: 0,
            destinations: [
              _buildDestination(
                Assets.icKidHome,
                'HOME',
                controller.selectedIndex.value == 0,
              ),
              _buildDestination(
                Assets.icKidGoal,
                'GOALS',
                controller.selectedIndex.value == 1,
              ),
              _buildDestination(
                Assets.icKidMarket,
                'SHOP',
                controller.selectedIndex.value == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  NavigationRailDestination _buildDestination(
    String iconPath,
    String label,
    bool isSelected,
  ) {
    return NavigationRailDestination(
      icon: SvgPicture.asset(iconPath),
      label: Text(
        label,
        style: AppTextStyle.labelSmall.copyWith(
          fontWeight: MyFontWeight.ExtraBold.fontWeight,
          color: isSelected ? AppColors.colorPrimary : AppColors.iconDisabled,
        ),
      ),
    );
  }
}
