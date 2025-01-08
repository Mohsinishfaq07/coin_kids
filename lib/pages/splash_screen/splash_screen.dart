import 'package:coin_kids/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../theme/color_theme.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashController = Get.put(SplashController());
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 46.h),
                child: SvgPicture.asset(
                  AppAssets.cloudImageSvg,
                  height: 252.h,
                  width: 360.w,
                ),
              ),
            ),
            Center(
              child: SvgPicture.asset(
                AppAssets.appLogoSvg,
                height: 57.h,
                width: 253.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
