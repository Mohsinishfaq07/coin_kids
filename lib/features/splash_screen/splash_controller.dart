import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// Replace with your signup screen
import '../onboard/onboarding_screen.dart'; // Optional, if you have onboarding

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  /// Check if the user is logged in and navigate accordingly
  void _checkLoginStatus() {
    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      // User is not logged in, navigate to Onboarding or Signup
      Get.off(() => OnboardingScreen()); // Or use SignupScreen()
    });
  }
}
