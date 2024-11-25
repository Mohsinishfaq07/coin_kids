import 'package:coin_kids/features/onboard/onboarding_screen.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_auth_controller/parent_auth_controller.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

 

class SplashController extends GetxController {
    final ParentAuthController parentAuthController = Get.put(ParentAuthController());

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }
      
  // Check for saved credentials
 /// Check if the user is logged in and navigate accordingly
  void _checkLoginStatus() async {
    // Simulate a splash screen delay (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is already logged in with Firebase
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to the Home Screen
      Get.off(() => BottomNavigationBarScreen());
    } else {
      // User is not logged in, attempt auto-login using local credentials
      await parentAuthController.loadCredentials();
      if (parentAuthController.email.isNotEmpty &&
          parentAuthController.pin.isNotEmpty) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: parentAuthController.email.value,
            password: parentAuthController.pin.value,
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
