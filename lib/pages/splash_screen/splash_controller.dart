import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/onboard/onboarding_screen.dart';
import 'package:coin_kids/pages/roles/kid/kid_bottom_nav/kid_bottom_nav_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
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
    await Future.delayed(const Duration(seconds: 1));

    // Check if user is already logged in with Firebase
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch user role from Firestore
      final isParent = await _checkIfParent(user.email!);
      if (isParent) {
        // Navigate to ParentBottomNavigationBar if user is a parent
        Get.off(() => ParentBottomNavigationBar());
      } else {
        // Navigate to KidMyMoney if user is a kid
        Get.off(() => KidBottomNavScreen());
      }
    }  else {
      // User is not logged in, attempt auto-login using local credentials
      await firebaseAuthController.loadCredentials();
      if (firebaseAuthController.email.isNotEmpty &&
          firebaseAuthController.pin.isNotEmpty) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: firebaseAuthController.email.value,
            password: firebaseAuthController.pin.value,
          );
         // Fetch user role and navigate accordingly after auto-login
          final isParent =
              await _checkIfParent(firebaseAuthController.email.value);
          if (isParent) {
            Get.off(() => ParentBottomNavigationBar());
          } else {
            Get.off(() => KidBottomNavScreen());
          }
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
   Future<bool> _checkIfParent(String email) async {
    try {
      final parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .where('email', isEqualTo: email)
          .get();

      if (parentSnapshot.docs.isNotEmpty) {
        return true; // User is a parent
      }

      // If not found in parents collection, check in kids collection
      final kidSnapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('email', isEqualTo: email)
          .get();

      if (kidSnapshot.docs.isNotEmpty) {
        return false; // User is a kid
      }
    } catch (e) {
      Get.log("Error checking user role: $e");
    }

    return false; // Default to kid if no matching document is found
  }

}
