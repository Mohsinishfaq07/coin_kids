import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle headingLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 24.sp,
    fontWeight: MyFontWeight.extraBold.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle headingMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: MyFontWeight.extraBold.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle headingSmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: MyFontWeight.bold.fontWeight,
    color: AppColors.textPrimary,
  );
  static TextStyle bodyLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: MyFontWeight.semiBold.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: MyFontWeight.regular.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle appButton = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: MyFontWeight.extraBold.fontWeight,
    color: Colors.white,
  );

  static TextStyle labelLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: MyFontWeight.bold.fontWeight,
    color: AppColors.textOnPrimary,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12.sp,
    fontWeight: MyFontWeight.regular.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 10.sp,
    fontWeight: MyFontWeight.semiBold.fontWeight,
    color: AppColors.textPrimary,
  );
}

enum MyFontWeight {
  thin,
  extraLight,
  light,
  regular,
  medium,
  semiBold,
  bold,
  extraBold,
  black,
}

extension CustomFontWeightExtension on MyFontWeight {
  FontWeight get fontWeight {
    switch (this) {
      case MyFontWeight.thin:
        return FontWeight.w100;
      case MyFontWeight.extraLight:
        return FontWeight.w200;
      case MyFontWeight.light:
        return FontWeight.w300;
      case MyFontWeight.regular:
        return FontWeight.w400;
      case MyFontWeight.medium:
        return FontWeight.w500;
      case MyFontWeight.semiBold:
        return FontWeight.w600;
      case MyFontWeight.bold:
        return FontWeight.w700;
      case MyFontWeight.extraBold:
        return FontWeight.w800;
      case MyFontWeight.black:
        return FontWeight.w900;
    }
  }
}
