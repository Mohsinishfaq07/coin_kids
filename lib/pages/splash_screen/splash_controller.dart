import 'package:coin_kids/pages/onboard/onboarding_screen.dart';
import 'package:coin_kids/pages/roles/parents/authentication/parent_auth_controller/parent_auth_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:coin_kids/firebase/authentication/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final FirebaseAuthController firebaseAuthController =
      Get.put(FirebaseAuthController());

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  // Check for saved credentials
  /// Check if the user is logged in and navigate accordingly
  void _checkLoginStatus() async {
    // Simulate a splash screen delay (3 seconds)
    await Future.delayed(const Duration(seconds: 4));

    // Check if user is already logged in with Firebase
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to the Home Screen
      Get.off(() => BottomNavigationBarScreen());
    } else {
      // User is not logged in, attempt auto-login using local credentials
      await firebaseAuthController.loadCredentials();
      if (firebaseAuthController.email.isNotEmpty &&
          firebaseAuthController.pin.isNotEmpty) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: firebaseAuthController.email.value,
            password: firebaseAuthController.pin.value,
          );
          // Navigate to the Home Screen on successful auto-login
          Get.off(() => ParentsHomeScreen());
        } catch (e) {
          Get.log("Auto-login failed: $e");
          // Navigate to the Login Screen if auto-login fails
          Get.off(() => OnboardingScreen());
        }
      } else {
        // Navigate to the Login Screen if no saved credentials
        Get.off(() => OnboardingScreen());
      }
    }
  }
}
