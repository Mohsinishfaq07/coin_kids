import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_market_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AgeFilterDialog extends StatelessWidget {
  final double width;
  final AgeRange selectedRange;
  final Function(AgeRange) onSelect;

  const AgeFilterDialog({
    required this.selectedRange,
    required this.onSelect,
    this.width = 0.6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isLandScape = Get.width > Get.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Dialog content container
          Container(
            constraints: BoxConstraints(minWidth: isLandScape ? 0.6.sw : 0.9.sw),
            padding: REdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(24.r),
              image: DecorationImage(
                image: AssetImage(Assets.kidDialogBgPng),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Age Range",
                  style: AppTextStyle.headingLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  alignment: WrapAlignment.center,
                  children: AgeRange.values.map((range) {
                    final isSelected = range == selectedRange;
                    return GestureDetector(
                      onTap: () {
                        onSelect(range);
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _getAgeRangeText(range),
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: isSelected ? AppColors.colorPrimary : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAgeRangeText(AgeRange range) {
    switch (range) {
      case AgeRange.all:
        return 'All Ages';
      case AgeRange.zeroToTwo:
        return '0-2 years';
      case AgeRange.threeToFive:
        return '3-5 years';
      case AgeRange.sixToNine:
        return '6-9 years';
      case AgeRange.tenToTwelve:
        return '10-12 years';
      case AgeRange.thirteenToSixteen:
        return '13-16 years';
      case AgeRange.sixteenPlus:
        return '16+ years';
    }
  }

  // Static method to show the dialog
  static Future<void> show({
    required AgeRange selectedRange,
    required Function(AgeRange) onSelect,
    double width = 0.8,
    bool dismissible = true,
  }) {
    return Get.dialog(
      AgeFilterDialog(
        width: width,
        selectedRange: selectedRange,
        onSelect: onSelect,
      ),
      barrierDismissible: dismissible,
    );
  }
}
