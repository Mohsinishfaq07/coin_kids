import 'package:coin_kids/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashController = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Light blue background
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  AppAssets.appCloudsImage, // Path to your image
                  fit: BoxFit.cover, // Adjust fit to your needs
                  height: MediaQuery.of(context).size.height *
                      0.3, // Top 30% of the screen
                  width: double.infinity,
                ),
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
