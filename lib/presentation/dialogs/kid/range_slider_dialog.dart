import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
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
    
    // Create TextEditingControllers for the text fields
    final TextEditingController minController = TextEditingController(
      text: currentMin.toStringAsFixed(0)
    );
    final TextEditingController maxController = TextEditingController(
      text: currentMax.toStringAsFixed(0)
    );

    // Function to update text fields when slider changes
    void updateTextFields() {
      minController.text = selectedMin.value.toStringAsFixed(0);
      maxController.text = selectedMax.value.toStringAsFixed(0);
    }
    
    // Function to update slider when text fields change
    void updateFromTextFields() {
      try {
        double minValue = double.parse(minController.text);
        double maxValue = double.parse(maxController.text);
        
        // Ensure min <= max
        if (minValue > maxValue) {
          double temp = minValue;
          minValue = maxValue;
          maxValue = temp;
          
          minController.text = minValue.toStringAsFixed(0);
          maxController.text = maxValue.toStringAsFixed(0);
        }
        
        // Ensure values are within bounds
        minValue = minValue.clamp(this.minValue, this.maxValue);
        maxValue = maxValue.clamp(this.minValue, this.maxValue);
        
        selectedMin.value = minValue;
        selectedMax.value = maxValue;
      } catch (e) {
        // Handle parsing errors
        updateTextFields();
      }
    }

    // Listen for changes to the slider values
    ever(selectedMin, (_) => updateTextFields());
    ever(selectedMax, (_) => updateTextFields());

    final isLandScape = Get.width > Get.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            constraints: BoxConstraints(minWidth: isLandScape ? 0.2.sw : 0.9.sw),
            padding: REdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(24.r),
              image: DecorationImage(
                image: AssetImage(Assets.kidDialogBgPng),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                 // mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(height: 12.h),
                    Text(
                      title,
                      style: AppTextStyle.headingLarge.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),

                    // Text Field Range Input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Min value text field
                        Container(
                          width: 70.w,
                         // height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: TextField(
                            controller: minController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                              // prefixText: title.contains('Budget') ? '€' : '',
                              prefixStyle: TextStyle(
                                color: AppColors.colorPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onEditingComplete: updateFromTextFields,
                          ),
                        ),

                        // Separator
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: 20.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),

                        // Max value text field
                        Container(
                          width: 70.w,
                        //  height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: TextField(
                            controller: maxController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                             // prefixText: title.contains('Budget') ? '€' : '',
                              prefixStyle: TextStyle(
                                color: AppColors.colorPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onEditingComplete: updateFromTextFields,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

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

                    SizedBox(height: 12.h),

                    // Range Slider
                    Obx(() => SfSliderTheme(
                      data: SfSliderThemeData(
                        activeTrackHeight: 20.h,
                        inactiveTrackHeight: 20.h,
                        trackCornerRadius: 50.r,
                        activeTrackColor: AppColors.btnColorOrange,
                        inactiveTrackColor: AppColors.btnColorOrange.withValues(alpha: 0.2),
                        thumbColor: Colors.transparent,
                        thumbRadius: 25.r,
                      ),
                      child: SfRangeSlider(
                        min: minValue,
                        max: maxValue,
                        interval: 2,
                        values: SfRangeValues(selectedMin.value, selectedMax.value),
                        onChanged: (SfRangeValues values) {
                          selectedMin.value = values.start;
                          selectedMax.value = values.end;
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white.withValues(alpha: 0.3),
                        enableTooltip: false,
                        showDividers: true,
                        shouldAlwaysShowTooltip: true,
                        tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                          return labelFormat(actualValue);
                        },
                        labelFormatterCallback: (_, text) {
                          return double.parse(text).toMoneyFormat();
                        },
                        showLabels: false,
                        showTicks: false,
                        startThumbIcon: SvgPicture.asset(Assets.icCoinEuro),
                        endThumbIcon: SvgPicture.asset(Assets.icCoinEuro),
                      ),
                    )),

                    // SizedBox(height: 12.h),

                    // Action Buttons
                    KidButton(
                      onTap: () {
                        // Update values from text fields before submitting
                        updateFromTextFields();
                        onSelect(selectedMin.value, selectedMax.value);
                        Get.back();
                      },
                      text: 'OK',
                      baseColor: AppColors.btnColorGreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 6.w,
            top: 6.h,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(
                Assets.icRoundClose,
                height: 40.h,
                width: 40.w,
              ),
            )
          )
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