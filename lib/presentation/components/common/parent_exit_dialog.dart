import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentExitDialog extends StatelessWidget {
  const ParentExitDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ParentExitDialog(),
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
              padding: EdgeInsets.all( 24.h),
              decoration: BoxDecoration(

              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  Assets.appIcon,
                  width: 64.w,
                  height: 64.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Column(
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
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.colorPrimary,
                          innerShadowColor: Colors.transparent,
                          size: Size(0.35.sw, 48.h),
                          child: Text(
                            'Stay',
                            style: AppTextStyle.appButton.copyWith(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppButton(
                          onPressed: () => SystemNavigator.pop(),
                          backgroundColor: AppColors.colorPrimary,
                          size: Size(0.35.sw, 48.h),
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