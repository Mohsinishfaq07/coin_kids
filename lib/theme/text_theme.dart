import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle headingLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 24.sp,
    fontWeight: MyFontWeight.ExtraBold.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle headingMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: MyFontWeight.ExtraBold.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle headingSmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: MyFontWeight.Bold.fontWeight,
    color: AppColors.textPrimary,
  );
  static TextStyle bodyLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: MyFontWeight.SemiBold.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.sp,
    fontWeight: MyFontWeight.Regular.fontWeight,
    color: AppColors.textPrimary,
  );
  static TextStyle labelLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: MyFontWeight.Bold.fontWeight,
    color: AppColors.textOnPrimary,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12.sp,
    fontWeight: MyFontWeight.Regular.fontWeight,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 10.sp,
    fontWeight: MyFontWeight.SemiBold.fontWeight,
    color: AppColors.textPrimary,
  );
}

enum MyFontWeight {
  Thin,
  ExtraLight,
  Light,
  Regular,
  Medium,
  SemiBold,
  Bold,
  ExtraBold,
  Black,
}

extension CustomFontWeightExtension on MyFontWeight {
  FontWeight get fontWeight {
    switch (this) {
      case MyFontWeight.Thin:
        return FontWeight.w100;
      case MyFontWeight.ExtraLight:
        return FontWeight.w200;
      case MyFontWeight.Light:
        return FontWeight.w300;
      case MyFontWeight.Regular:
        return FontWeight.w400;
      case MyFontWeight.Medium:
        return FontWeight.w500;
      case MyFontWeight.SemiBold:
        return FontWeight.w600;
      case MyFontWeight.Bold:
        return FontWeight.w700;
      case MyFontWeight.ExtraBold:
        return FontWeight.w800;
      case MyFontWeight.Black:
        return FontWeight.w900;
    }
  }
}
