import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/pages/onboard/parent_onboarding_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_onboarding.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final FirebaseAuthController firebaseAuthController =
      Get.put(FirebaseAuthController());
  final parentController = Get.put(ParentController());

  @override
  void onInit() {
    super.onInit();
    loadSavedEmail();
    _checkLoginStatus();
  }

  Future<void> loadSavedEmail() async {
    String? savedEmail = await DatabaseHelper.instance.getSavedEmail();
    if (savedEmail != null) {
      Get.log("Saved Email: $savedEmail");
    } else {
      Get.log("No email found.");
    }
  }

  void _checkLoginStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Simulate a splash screen delay (3 seconds)
  await Future.delayed(const Duration(seconds: 2));

  // Check if user is already logged in with Firebase
  final user = FirebaseAuth.instance.currentUser;
  
  if (user != null) {
    // Proceed with the user logic if user is logged in
    final kidSnapshot = await FirebaseFirestore.instance
        .collection('kids')
        .where('parentId', isEqualTo: user.uid)
        .get();

    int? loginAsParent = prefs.getInt("LoggedInAsParent") ?? 0;
    if (loginAsParent == 1) {
      bool parentHasKids = await parentController.fetchKids();
      if (parentHasKids) {
        Get.off(() => ParentBottomNavigationBar());
      } else {
        Get.off(() => const ParentsHomeScreen());
      }
    } else if (loginAsParent == 2) {
      if (kidSnapshot.docs.isNotEmpty) {
        Get.off(() =>  KidHomeScreen());
      } else {
        Get.off(() => KidSectionOnboarding());
      }
    } else {
      Get.off(() => KidSectionOnboarding());
    }
  } else {
    // Handle the case where the user is not logged in
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
          if (parentController.kidsList.isNotEmpty) {
            Get.off(() => ParentBottomNavigationBar());
          } else {
            Get.off(() => const ParentsHomeScreen());
          }
        } else {
          Get.off(() =>  KidHomeScreen());
        }
      } catch (e) {
        Get.log("Auto-login failed: $e");
        // Navigate to the Login Screen if auto-login fails
        Get.off(() => ParentOnboardingScreen());
      }
    } else {
      // Navigate to the Login Screen if no saved credentials
      Get.off(() => ParentOnboardingScreen());
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
