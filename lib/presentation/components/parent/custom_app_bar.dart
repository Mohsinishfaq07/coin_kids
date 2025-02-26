import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final Color backButtonColor; // New parameter for back button color

  const CustomAppBar({
    super.key,
    required this.title, // Enforce required     title
    this.backgroundColor = const Color(0xFFCAF0FF),
    scrolledUnderElevation = 0.0,

    // Nullable, initialized in constructor body
    this.elevation = 0.0,
    this.onBackPressed,
    this.actions,
    this.showBackButton = false,
    this.centerTitle = true,
    this.backButtonColor = AppColors.textPrimary, // Default back button color
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: backButtonColor),
              onPressed: onBackPressed ??
                  () => Get.back(), // Default action is Get.back
            )
          : null,
      title: Text(
        title,
        style: AppTextStyle.headingLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontSize: 18.sp),
      ),
      centerTitle: centerTitle,
      // Adjust center alignment based on your design
      actions: actions, // Add custom actions if provided
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  get buttonColor => null;
}
