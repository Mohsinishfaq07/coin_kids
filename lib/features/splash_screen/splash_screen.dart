import 'package:coin_kids/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController splashController = Get.put(SplashController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Light blue background
      body: SafeArea(
        child: Stack(
          children: [
            // Clouds Image at the top
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                AppAssets.appCloudsImage, // Replace with your cloud image path
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Logo
                  Image.asset(
                    AppAssets.appLogo, // Replace with your logo path
                    height: 60, // Adjust logo size
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
