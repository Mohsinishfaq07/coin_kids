import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketFilterChip extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final bool isSelected;
  final String iconPath;
  final VoidCallback onTap;

  const MarketFilterChip({
    super.key,
    required this.label,
    this.selectedValue,
    required this.isSelected,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.colorPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.colorPrimary : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 16.w,
              height: 16.w,
              colorFilter: ColorFilter.mode(isSelected ? Colors.white : Colors.grey[600]!, BlendMode.srcIn),
            ),
            SizedBox(width: 4.w),
            Text(
              selectedValue ?? label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
