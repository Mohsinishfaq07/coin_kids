import 'package:coin_kids/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class KidsZoneDialog extends StatelessWidget {
  final String coinIconPath;
  final String greenButtonBgPath;
  final String tickIconPath;
  final String label;
  final String subLabel;

  const KidsZoneDialog({
    Key? key,
    required this.coinIconPath,
    required this.greenButtonBgPath,
    required this.tickIconPath,
    required this.label,
    required this.subLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 80.h, left: 20.w, right: 20.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            AppAssets.dialogueBGSvg,
            fit: BoxFit.cover,
            width: 330.w,
            height: 120.h,
          ),
          Positioned(
            top: -28.h,
            left: 0.w,
            right: 0.w,
            child: SvgPicture.asset(
              coinIconPath,
              width: 60.w,
              height: 60.h,
            ),
          ),
          Positioned(
            top: -1,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                AppAssets.crossWithDoubleBorderSvg,
                width: 32.w,
                height: 30.h,
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            left: 0.w,
            right: 0.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  subLabel,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -20.w,
            left: 0.w,
            right: 0.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    greenButtonBgPath,
                    width: 92.w,
                    height: 42.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        tickIconPath,
                        // width: 20.w,
                        height: 22.h,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'OK',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show the dialog
void showKidsZoneDialog(
  BuildContext context, {
  required String coinIconPath,
  required String greenButtonBgPath,
  required String tickIconPath,
  required String label,
  required String subLabel,
}) {
  Get.bottomSheet(
    KidsZoneDialog(
      coinIconPath: coinIconPath,
      greenButtonBgPath: greenButtonBgPath,
      tickIconPath: tickIconPath,
      label: label,
      subLabel: subLabel,
    ),
  );
}
