import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirestoreOperations {
  Future<void> updateProfile() async {
    try {
      firebaseAuthController.isNormalLoading.value = true;

      // Update Firebase Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(user.email)
            .update({
          'name': firebaseAuthController.username.value,
          'dob': firebaseAuthController.birthday.value,
          'gender': firebaseAuthController.selectedGender.value.isNotEmpty
              ? firebaseAuthController.selectedGender.value
              : 'Not specified',
        });

        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "User not logged in. Please log in again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update profile: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      firebaseAuthController.isNormalLoading.value = false;
    }
  }
}
