import 'package:coin_kids/core/utils/portrait_orientation.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/common/cloud.dart';
import 'package:coin_kids/presentation/controllers/common/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PortraitOrientation();

    controller.onInit();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(
          children: [
            CloudImage(),
            AppLogo(),
          ],
        ),
      ),
    );
  }
}
