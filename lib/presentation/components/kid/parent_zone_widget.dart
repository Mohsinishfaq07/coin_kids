import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentZoneWidget extends StatelessWidget {
  const ParentZoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: REdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80.r),
            topRight: Radius.circular(80.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icParentZone,
              width: 40.r,
              height: 40.r,
            ),
            Text(
              "Parent\nZone",
              textAlign: TextAlign.center,
              style: AppTextStyle.labelSmall.copyWith(
                color: AppColors.kidZoneParent,
                fontWeight: MyFontWeight.extraBold.fontWeight,
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
