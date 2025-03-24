import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrientationUtils.lockToPortrait();
    });

    controller.onInit();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                width: Get.width,
                Assets.parentBgCloud,
                fit: BoxFit.fitWidth,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                Assets.appIconText,
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
