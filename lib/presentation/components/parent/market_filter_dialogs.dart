import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_market_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AgeRangeDialog extends StatelessWidget {
  final AgeRange selectedRange;
  final Function(AgeRange) onSelect;

  const AgeRangeDialog({
    Key? key,
    required this.selectedRange,
    required this.onSelect,
  }) : super(key: key);

  String getAgeRangeText(AgeRange range) {
    switch (range) {
      case AgeRange.all:
        return 'All Ages';
      case AgeRange.zero_to_two:
        return '0-2 years';
      case AgeRange.three_to_five:
        return '3-5 years';
      case AgeRange.six_to_nine:
        return '6-9 years';
      case AgeRange.ten_to_twelve:
        return '10-12 years';
      case AgeRange.thirteen_to_sixteen:
        return '13-16 years';
      case AgeRange.sixteen_plus:
        return '16+ years';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Age Range',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ...AgeRange.values.map(
              (range) => RadioListTile<AgeRange>(
                title: Text(getAgeRangeText(range)),
                value: range,
                groupValue: selectedRange,
                onChanged: (value) {
                  if (value != null) {
                    onSelect(value);
                    Get.back();
                  }
                },
                activeColor: AppColors.colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RangeFilterDialog extends StatefulWidget {
  final String title;
  final double minValue;
  final double maxValue;
  final double currentMin;
  final double currentMax;
  final Function(double, double) onSelect;
  final String Function(double) labelFormat;

  const RangeFilterDialog({
    Key? key,
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.currentMin,
    required this.currentMax,
    required this.onSelect,
    required this.labelFormat,
  }) : super(key: key);

  @override
  State<RangeFilterDialog> createState() => _RangeFilterDialogState();
}

class _RangeFilterDialogState extends State<RangeFilterDialog> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(widget.currentMin, widget.currentMax);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            RangeSlider(
              values: _currentRange,
              min: widget.minValue,
              max: widget.maxValue,
              divisions: 100,
              labels: RangeLabels(
                widget.labelFormat(_currentRange.start),
                widget.labelFormat(_currentRange.end),
              ),
              onChanged: (values) {
                setState(() {
                  _currentRange = values;
                });
              },
              activeColor: AppColors.colorPrimary,
              inactiveColor: Colors.grey[300],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {
                    widget.onSelect(_currentRange.start, _currentRange.end);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorPrimary,
                  ),
                  child: Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
