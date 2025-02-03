import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class KidGoalsController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  RxString goalName = ''.obs;
  RxString goalAmount = ''.obs;
  RxString goalImage = ''.obs;
  RxBool isPickingImage = false.obs; // Add flag

  // Future<void> pickImageFromGallery() async {
  //   if (isPickingImage.value) return; // Prevent multiple calls
  //   isPickingImage.value = true;

  //   try {
  //     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //     if (pickedImage != null) {
  //       goalImage.value = pickedImage.path;
  //     }
  //   } catch (e) {
  //     print("Error picking image: $e");
  //   } finally {
  //     isPickingImage.value = false; // Reset flag
  //   }
  // }
  Future<void> pickCustomAvatar() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final String localPath = await saveImageLocally(File(pickedFile.path));
        goalImage.value = localPath;
        // goalImage.value = '';
        // Save the image path in SQLite
        await DatabaseHelper.instance.insertImage(localPath);

        Get.snackbar("Success", "Image saved locally.");
      } else {
        Get.snackbar("No Image Selected", "Please select an image.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick and save image: $e");
    }
  }

  Future<void> pickImageFromCamera() async {
    if (isPickingImage.value) return; // Prevent multiple calls
    isPickingImage.value = true;

    try {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        goalImage.value = pickedImage.path;
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      isPickingImage.value = false; // Reset flag
    }
  }

  Future<void> addKidGoal() async {
    try {
      // Ensure user is authenticated
      final String? parentId = _firebaseAuth.currentUser?.uid;
      if (parentId == null) {
        Get.snackbar("Error", "User not authenticated");
        return;
      }

      Get.log('Adding new goal for kid with parent ID: $parentId');
      QuerySnapshot kidSnapshot = await _firebaseFirestore
          .collection('kids')
          .where('parentId', isEqualTo: parentId) // Match parentId
          .get();
      if (kidSnapshot.docs.isEmpty) {
        // Handle error if no kid document is found for the given parentId
        throw Exception("No kid document found for this parent ID");
      }

      // Firestore reference for goal
      DocumentReference goalRef =
          _firebaseFirestore.collection('goals').doc(); // New goal document
      DocumentSnapshot kidDoc = kidSnapshot.docs.first;
      DocumentReference kidRef = kidDoc.reference;
      final String avatarUrl =
          goalImage.value.isEmpty ? 'assets/defaultImage.png' : goalImage.value;

      // Firestore goal data
      final Map<String, dynamic> goalData = {
        'amount': goalAmount.value,
        'kidId': kidRef.id,
        'completed': false,
        'deleted': false,
        'image': avatarUrl,
        'name': goalName.value,
        'progress': 0,
        //  'kid': '/kids/${kidRef.id}',
      };

      // Firestore kid data to update (Add new goal reference to 'goalsReference' field)
      final Map<String, dynamic> kidData = {
        'goals': FieldValue.arrayUnion(
            [goalRef]), // Add goal reference to goalsReference field
      };

      // Find the kid document where parentId matches

      // Use Firestore transaction for atomic operation
      await _firebaseFirestore.runTransaction((transaction) async {
        try {
          // Log the data you are passing to Firestore
          Get.log('Setting goal data: $goalData');

          // Set goal data
          transaction.set(goalRef, goalData);

          // Update kid document
          transaction.update(kidRef, kidData);
        } catch (e) {
          Get.log('Error in Firestore transaction: $e');
          rethrow; // Re-throw exception to be caught outside
        }
      }).timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException("Firestore transaction timed out");
      });

      // Success response
      firebaseAuthController.isNormalLoading.value = false;
      Get.snackbar("Success", "Goal added for kid successfully");
      Get.log('Added new goal for kid with parent ID: $parentId');
    } catch (e) {
      firebaseAuthController.isNormalLoading.value = false;
      Get.back();

      // Firestore timeout error handling
      if (e is TimeoutException) {
        Get.snackbar(
            "Error", "Firestore operation timed out. Please try again.");
      } else {
        Get.snackbar("Error", "Failed to add goal: $e");
      }

      Get.log('Error adding goal: $e');
    }
  }

  Future<String> saveImageLocally(File image) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File localImage = await image.copy('${appDir.path}/$fileName.jpg');
      return localImage.path; // Return the local path
    } catch (e) {
      Get.snackbar("Error", "Failed to save image locally: $e");
      rethrow;
    }
  }
}
