import 'package:coin_kids/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget CloudImage() {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: EdgeInsets.only(top: 46.h),
      child: SvgPicture.asset(
        AppAssets.cloudImageSvg,
        width: 399.w,
      ),
    ),
  );
}

Widget AppLogo() {
  return Center(
    child: SvgPicture.asset(
      AppAssets.appLogoSvg,
      height: 57.h,
      width: 253.w,
    ),
  );
}