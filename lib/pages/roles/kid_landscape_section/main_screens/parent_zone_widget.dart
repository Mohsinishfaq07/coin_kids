import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';

class ParentZoneWidget extends StatelessWidget {
  const ParentZoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 51.h,
        width: 70.w,
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80.r),
            topRight: Radius.circular(80.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(2.h),
                child: SvgPicture.asset(
                  "assets/parent.svg",
                  height: 30.h,
                ),
              ),
              Text(
                "Parent\nZone",
                textAlign: TextAlign.center,
                style: AppTextStyle.labelSmall.copyWith(
                  color: AppColors.KidZoneParent,
                  fontWeight: MyFontWeight.ExtraBold.fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
