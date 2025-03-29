import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget buildNotificationEmptyState(VoidCallback onTap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Image.asset(
      //   Assets.phMessages,
      //   height: 100,
      // ),
      SvgPicture.asset(Assets.phGoalImage, height: 100.h),
      SizedBox(height: 16.h),
      Text(
        'No notifications yet',
        style: TextStyle(
          fontSize: 16.sp,
          color: AppColors.iconDisabled,
        ),
      ),
      SizedBox(height: 8.h),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.buttonPrimary),
          foregroundColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        ),
        onPressed: () => onTap,
        child: Text('Refresh'),
      ),
    ],
  );
}

Widget buildGoalsEmptyState(VoidCallback onTap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(Assets.phGoalImage, height: 100.h),
      SizedBox(height: 16.h),
      Text(
        'No Goals yet',
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 8.h),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.buttonPrimary),
          foregroundColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        ),
        onPressed: () => onTap,
        child: Text('Refresh'),
      ),
    ],
  );
}

Widget buildJarEmptyState() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(Assets.phJar, height: 100.h),
      SizedBox(height: 16.h),
      Text(
        'No Jars created',
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 48),
    ],
  );
}
