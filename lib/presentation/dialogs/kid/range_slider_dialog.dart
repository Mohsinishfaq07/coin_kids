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
  final double? dialogWidth;

  const RangeSliderDialog({
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.currentMin,
    required this.currentMax,
    required this.onSelect,
    required this.labelFormat,
    this.dialogWidth,
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

    // Create focus nodes for better control
    final FocusNode minFocusNode = FocusNode();
    final FocusNode maxFocusNode = FocusNode();

    // Dispose focus nodes when dialog is closed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.delete<FocusNode>(tag: 'minFocusNode');
      Get.delete<FocusNode>(tag: 'maxFocusNode');
      Get.put(minFocusNode, tag: 'minFocusNode');
      Get.put(maxFocusNode, tag: 'maxFocusNode');
    });

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

          // Update text fields only if values were swapped
          minController.text = minValue.toStringAsFixed(0);
          maxController.text = maxValue.toStringAsFixed(0);
        }

        // Ensure values are within bounds
        double clampedMin = minValue.clamp(this.minValue, this.maxValue);
        double clampedMax = maxValue.clamp(this.minValue, this.maxValue);

        // Only update text fields if values were clamped
        if (clampedMin != minValue) {
          minController.text = clampedMin.toStringAsFixed(0);
        }
        if (clampedMax != maxValue) {
          maxController.text = clampedMax.toStringAsFixed(0);
        }

        // Update the reactive values
        selectedMin.value = clampedMin;
        selectedMax.value = clampedMax;

      } catch (e) {
        // Handle parsing errors
        updateTextFields();
      }
    }

    // Listen for changes to the slider values
    ever(selectedMin, (_) => updateTextFields());
    ever(selectedMax, (_) => updateTextFields());

    // Use a local variable with a default value
    final double actualWidth = dialogWidth ?? 0.95;

    // Close keyboard when tapping outside text fields
    void closeKeyboard() {
      minFocusNode.unfocus();
      maxFocusNode.unfocus();
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),

      child: GestureDetector(
        onTap: closeKeyboard,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: actualWidth.sw,
              padding: REdgeInsets.all(12.w),
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
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          title,
                          style: AppTextStyle.headingLarge.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),


                      // Text Field Range Input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Min value text field
                          Container(
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: TextField(
                              focusNode: minFocusNode,
                              textInputAction: TextInputAction.done,
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
                                prefixStyle: TextStyle(
                                  color: AppColors.colorPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                counterText: "",
                              ),
                              onTap: () {
                                // Select all text when tapped
                                minController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: minController.text.length
                                );
                              },
                              onEditingComplete: () {
                                updateFromTextFields();
                                closeKeyboard();
                              },
                              onSubmitted: (_) {
                                updateFromTextFields();
                                closeKeyboard();
                              },
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: TextField(
                              focusNode: maxFocusNode,
                              textInputAction: TextInputAction.done,
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
                                prefixStyle: TextStyle(
                                  color: AppColors.colorPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                counterText: "",
                              ),
                              onTap: () {
                                // Select all text when tapped
                                maxController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: maxController.text.length
                                );
                              },
                              onEditingComplete: () {
                                updateFromTextFields();
                                closeKeyboard();
                              },
                              onSubmitted: (_) {
                                updateFromTextFields();
                                closeKeyboard();
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),
                      // Range Slider
                      Obx(() => Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.w),
                        child: SfSliderTheme(
                          data: SfSliderThemeData(
                           //  thumbStrokeColor: Colors.blue,
                           //  activeLabelStyle: TextStyle(color: Colors.white),
                           //  inactiveLabelStyle: TextStyle(color: Colors.blue),
                           //  activeTickColor: Colors.green,
                           //  tooltipBackgroundColor: Colors.blue,
                           //  activeDividerColor: Colors.teal,
                           //  activeDividerStrokeColor: Colors.orange,
                           //  activeMinorTickColor: Colors.blue,
                           //  tooltipTextStyle: TextStyle(color: Colors.yellow),
                           //  activeTrackHeight: 15.h,
                           //  inactiveTrackHeight: 15.h,
                           //  trackCornerRadius: 50.r,
                           // // trackCornerRadius: 50.r,
                           //  activeTrackColor: AppColors.btnColorOrange,
                           //  inactiveTrackColor: AppColors.cardPrimary,
                           //  thumbColor: Colors.transparent,
                           //  thumbRadius: 50.r,
                            activeTrackHeight: 15.h,
                            inactiveTrackHeight: 15.h,
                            trackCornerRadius: 50.r,
                            activeTrackColor: AppColors.btnColorOrange,
                            inactiveTrackColor: Colors.red,
                            thumbColor: Colors.transparent,
                            thumbRadius: 15.r,
                          ),
                          child: SfRangeSlider(
                            min: minValue,
                            max: maxValue,

                            values: SfRangeValues(selectedMin.value, selectedMax.value),
                            onChanged: (SfRangeValues values) {
                              selectedMin.value = values.start;
                              selectedMax.value = values.end;
                            },
                            labelPlacement: LabelPlacement.onTicks,
                            activeColor: Color(0xfff79009),
                            inactiveColor: Colors.white.withValues(alpha: 0.3),
                            // showDividers: false,
                            tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                              return labelFormat(actualValue);
                            },
                            labelFormatterCallback: (_, text) {
                              return double.parse(text).toMoneyFormat();
                            },
                            edgeLabelPlacement: EdgeLabelPlacement.auto,


                            startThumbIcon: SvgPicture.asset(Assets.icCoinEuro),
                            endThumbIcon: SvgPicture.asset(Assets.icCoinEuro),
                            showLabels: true,
                            showTicks: true,
                            enableTooltip: true,
                            showDividers: true,
                            shouldAlwaysShowTooltip: true,
                          ),
                        ),
                      )),
                     // SizedBox(height: 12.h),
                     //  Obx(() => Padding(
                     //    padding:  EdgeInsets.all(12.h),
                     //    child: Row(
                     //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     //      children: [
                     //        Text(
                     //          labelFormat(selectedMin.value),
                     //          style: AppTextStyle.bodyLarge.copyWith(
                     //            color: Colors.white,
                     //            fontWeight: FontWeight.w600,
                     //          ),
                     //        ),
                     //        Text(
                     //          labelFormat(selectedMax.value),
                     //          style: AppTextStyle.bodyLarge.copyWith(
                     //            color: Colors.white,
                     //            fontWeight: FontWeight.w600,
                     //          ),
                     //        ),
                     //      ],
                     //    ),
                     //  )),



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
    double? dialogWidth,
    bool dismissible = false,
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
        dialogWidth: dialogWidth,
      ),
      barrierDismissible: dismissible,
    );
  }
}