import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerticalNavBar extends StatelessWidget {
  final List<NavItem> navItems = [
    NavItem(AppAssets.kidHomeIcon, 'HOME'),
    NavItem(AppAssets.kidGoalIcon, 'GOALS'),
    NavItem(AppAssets.kidShopIcons, 'SHOP'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: navItems.map((item) => _buildNavItem(item)).toList(),
      ),
    );
  }

  Widget _buildNavItem(NavItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Circular Button (SVG)
            SvgPicture.asset(
              item.iconPath,
              height: 30.h,
            ),
            SizedBox(height: 0.h),
            // Label
            Text(item.label,
                style: AppTextStyle.labelSmall
                    .copyWith(fontWeight: MyFontWeight.ExtraBold.fontWeight)),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final String iconPath;
  final String label;

  NavItem(this.iconPath, this.label);
}
