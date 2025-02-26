import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class coinKidLockContainer extends StatelessWidget {
  const coinKidLockContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            fit: StackFit.loose,
            children: [
              Positioned(
                top: 5.h,
                right: 6.w,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 18.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(4.r),
                      border:
                          Border.all(color: AppColors.textPrimary, width: 2.0),
                    ),
                    child: Text(
                      "5000",
                      style: AppTextStyle.headingMedium
                          .copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -4.w,
                top: 2.h,
                child: Container(
                  color: Colors.transparent,
                  height: 24.h,
                  // width: 80.w,
                  child: SvgPicture.asset(AppAssets.kidCoinIcon, height: 24.h),
                ),
              ),
              Container(
                height: 28.9.h,
                width: 120.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xff000000).withOpacity(0.46)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppAssets.kidLockIcon, height: 24.h),
          ),
        ],
      ),
    );
  }
}
