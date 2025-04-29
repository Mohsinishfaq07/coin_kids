import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KidExitDialog extends StatelessWidget {
  const KidExitDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const KidExitDialog(),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 0.85.sw,
        decoration: BoxDecoration(
          color: AppColors.cardPrimary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Image.asset(
                Assets.appIcon,
                width: 56.w,
                height: 56.w,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Exit Application',
                    style: AppTextStyle.headingMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Are you sure you want to leave\nthe application?',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.colorSecondary,
                          innerShadowColor: Colors.transparent,
                          size: Size(0.35.sw, 44.h),
                          child: Text(
                            'Stay',
                            style: AppTextStyle.appButton.copyWith(
                              color: AppColors.colorSecondary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppButton(
                          onPressed: () => SystemNavigator.pop(),
                          backgroundColor: AppColors.colorSecondary,
                          size: Size(0.35.sw, 44.h),
                          child: Text(
                            'Exit',
                            style: AppTextStyle.appButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 