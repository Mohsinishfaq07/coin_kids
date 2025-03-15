import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showLoadingDialog(message) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 100.w,
        height: 150.w,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary),
              ),
              SizedBox(height: 16.h),
              if (message != null)
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // Limit to 2 lines
                ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
