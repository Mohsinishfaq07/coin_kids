import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirestoreOperations {
  ParentFirebaseFunctions parentFirebaseFunctions = ParentFirebaseFunctions();
  ChildFirebaseFunctions childFirebaseFunctions = ChildFirebaseFunctions();
}

class ParentFirebaseFunctions {
  // fetch the details of parent
  Stream<Map<String, dynamic>?> fetchParentData() {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        return Stream.value(null);
      }

      DocumentReference parentDocRef =
          FirebaseFirestore.instance.collection('parents').doc(userEmail);

      return parentDocRef.snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return docSnapshot.data() as Map<String, dynamic>?;
        } else {
          return null;
        }
      });
    } catch (e) {
      Get.log('Error fetching document fields: $e');
      return Stream.value(null); // Return an empty stream on error
    }
  }

  // update the profile of parent
  Future<void> updateParentProfile() async {
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
        Get.back(closeOverlays: true);
        Get.log('profile updated');
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

class ChildFirebaseFunctions {}
