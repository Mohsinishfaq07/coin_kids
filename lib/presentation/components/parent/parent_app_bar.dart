import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';

class ParentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final Color? backButtonColor; // New parameter for back button color
  final double scrolledUnderElevation; // ✅ Add this


  const ParentAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFFCAF0FF),
    // scrolledUnderElevation = 0.0,
    this.elevation = 0.0,
    this.onBackPressed,
    this.actions,
    this.showBackButton = false,
    this.centerTitle = true,
    this.backButtonColor,
    this.scrolledUnderElevation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation, // ✅ Set it here

      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: backButtonColor ?? AppColors.iconPrimaryVariant),
              onPressed: onBackPressed ?? () => Get.back(), // Default action is Get.back
            )
          : null,
      title: Text(
        title,
//        style: AppTextStyle.headingLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 18.sp),
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 17.sp),
      ),
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  get buttonColor => null;
}
