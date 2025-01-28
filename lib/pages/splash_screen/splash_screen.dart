import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/common_funcitons.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PortraitOrientation();
    final splashController = Get.put(SplashController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(
          children: [
            _buildCloudImage(),
            _buildAppLogo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCloudImage() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 46.h),
        child: SvgPicture.asset(
          AppAssets.cloudImageSvg,
          width: 399.w,
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Center(
      child: SvgPicture.asset(
        AppAssets.appLogoSvg,
        height: 57.h,
        width: 253.w,
      ),
    );
  }
}
