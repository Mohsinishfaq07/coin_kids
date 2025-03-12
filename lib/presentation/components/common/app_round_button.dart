import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget AppRoundButton({required String title, required String assetPath, required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        SvgPicture.asset(
          assetPath,
        ),
        const SizedBox(height: 3),
        Text(title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center),
      ],
    ),
  );
}
