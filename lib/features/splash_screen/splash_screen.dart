// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';
//check
 
class SplashScreen extends StatelessWidget {
  final SplashController splashController = Get.put(SplashController());

    SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png", // Ensure the image is in the 'assets' folder and added to pubspec.yaml
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "Kids Finance App",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
