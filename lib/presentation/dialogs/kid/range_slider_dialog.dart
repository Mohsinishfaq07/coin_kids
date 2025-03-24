import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class RangeSliderDialog extends StatelessWidget {
  final String title;
  final double minValue;
  final double maxValue;
  final double currentMin;
  final double currentMax;
  final Function(double, double) onSelect;
  final String Function(double) labelFormat;

  const RangeSliderDialog({
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.currentMin,
    required this.currentMax,
    required this.onSelect,
    required this.labelFormat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Create RxDouble variables for the current values
    final RxDouble selectedMin = currentMin.obs;
    final RxDouble selectedMax = currentMax.obs;

    final isLandScape = Get.width > Get.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
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
                  title,
                  style: AppTextStyle.headingLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 32.h),
                // Range Values Display
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          labelFormat(selectedMin.value),
                          style: AppTextStyle.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          labelFormat(selectedMax.value),
                          style: AppTextStyle.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 16.h),
                // Range Slider
                Obx(() => SfRangeSlider(
                      min: minValue,
                      max: maxValue,
                      values: SfRangeValues(selectedMin.value, selectedMax.value),
                      onChanged: (SfRangeValues values) {
                        selectedMin.value = values.start;
                        selectedMax.value = values.end;
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withValues(alpha: 0.3),
                      enableTooltip: true,
                      tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                        return labelFormat(actualValue);
                      },
                      showLabels: false,
                      showTicks: false,
                    )),
                SizedBox(height: 32.h),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    KidButton(
                      onTap: () => Get.back(),
                      text: 'Cancel',
                      baseColor: Colors.white.withValues(alpha: 0.3),
                      height: 40.h,
                      fontSize: 14,
                      width: 100.w,
                    ),
                    SizedBox(width: 12.w),
                    KidButton(
                      onTap: () {
                        onSelect(selectedMin.value, selectedMax.value);
                        Get.back();
                      },
                      text: 'Apply',
                      baseColor: Colors.white,
                      height: 40.h,
                      fontSize: 14,
                      width: 100.w,
                      textStyle: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Static method to show the dialog
  static Future<void> show({
    required String title,
    required double minValue,
    required double maxValue,
    required double currentMin,
    required double currentMax,
    required Function(double, double) onSelect,
    required String Function(double) labelFormat,
    bool dismissible = true,
  }) {
    return Get.dialog(
      RangeSliderDialog(
        title: title,
        minValue: minValue,
        maxValue: maxValue,
        currentMin: currentMin,
        currentMax: currentMax,
        onSelect: onSelect,
        labelFormat: labelFormat,
      ),
      barrierDismissible: dismissible,
    );
  }
} 