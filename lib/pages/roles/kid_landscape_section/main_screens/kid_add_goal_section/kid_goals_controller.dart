import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KidGoalsController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  RxString goalName = ''.obs;
  RxDouble goalAmount = 0.0.obs;
  RxString goalImage = ''.obs;
  RxBool isPickingImage = false.obs; // Add flag

  Future<void> pickFromGallery() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        goalImage.value = pickedFile.path;

        ToastUtil.showToast("Image saved locally.");
      } else {
        ToastUtil.showToast("No Image Selected");
      }
    } catch (e) {
      ToastUtil.showToast("Failed to pick and save image: $e");
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
      firebaseAuthController.isNormalLoading.value = true;
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible:
            true, // Prevent dialog from being dismissed by tapping outside
      );
      // Ensure user is authenticated
      final String? parentId = _firebaseAuth.currentUser?.uid;
      if (parentId == null) {
        ToastUtil.showToast("User not authenticated");
        firebaseAuthController.isNormalLoading.value = false;
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
      final String avatarUrl = goalImage.value.isEmpty || goalImage.value == ""
          ? 'assets/logo.png'
          : goalImage.value;

      //locally store the image

      // Firestore goal data
      final Map<String, dynamic> goalData = {
        'currentAmount': 0,
        'amount': goalAmount.value,
        'kidId': kidRef.id,
        'completed': false,
        'deleted': false,
        'image': avatarUrl,
        'name': goalName.value,
        'progress': 0,
        'goalId': goalRef.id,
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

          final String localPath =
              await saveImageLocally(File(goalImage.value), goalRef.id);
          goalImage.value = localPath;
          await saveImageToPrefs(goalRef.id, File(goalImage.value));
          await saveGoalIdToPrefs(goalRef.id);
        } catch (e) {
          Get.log('Error in Firestore transaction: $e');
          rethrow; // Re-throw exception to be caught outside
        }
      }).timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException("Firestore transaction timed out");
      });

      // Success response
      firebaseAuthController.isNormalLoading.value = false;
      goalImage.value = "";
      goalName.value = "";
      goalAmount.value = 0.0;
      ToastUtil.showToast("Goal added for kid successfully");
      Get.log('Added new goal for kid with parent ID: $parentId');
      goalImage.value = "";
    } catch (e) {
      firebaseAuthController.isNormalLoading.value = false;
      Get.back();

      // Firestore timeout error handling
      if (e is TimeoutException) {
        ToastUtil.showToast("Firestore operation timed out. Please try again.");
      } else {
        ToastUtil.showToast("Failed to add goal: $e");
      }

      Get.log('Error adding goal: $e');
    }
  }

  Future<String> saveImageLocally(File image, String goalId) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();

      final String goalDirPath =
          '${appDir.path}/$goalId'; // Create a directory per goalId
      final Directory goalDir = Directory(goalDirPath);
      if (!await goalDir.exists()) {
        await goalDir.create(recursive: true);
      }
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File localImage = await image.copy('$goalDirPath/$fileName.jpg');
      return localImage.path;
    } catch (e) {
      ToastUtil.showToast("Failed to save image locally: $e");
      rethrow;
    }
  }

  Future<String?> getImageFromDatabase(String goalId) async {
    try {
      final imagePath = await DatabaseHelper.instance.getImageByGoalId(goalId);
      if (imagePath != null && imagePath.isNotEmpty) {
        return imagePath;
      }
      return null; // Return null if no image is found
    } catch (e) {
      ToastUtil.showToast("Failed to fetch image: $e");
      print("Error Failed to fetch image: $e");
      return null;
    }
  }

  Future<void> saveGoalIdToPrefs(String goalId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentGoalId', goalId);
  }

  Future<String?> getGoalIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentGoalId');
  }

  Future<void> saveImageToPrefs(String goalId, File imageFile) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Read the image file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Convert image to Base64 string
      String base64Image = base64Encode(imageBytes);

      // Store in SharedPreferences with goalId as key
      await prefs.setString('goal_image_$goalId', base64Image);

      print("Image saved successfully for goalId: $goalId");
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  Future<File?> getImageFromPrefs(String goalId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve Base64 string from SharedPreferences
      String? base64Image = prefs.getString('goal_image_$goalId');

      if (base64Image == null) return null; // If no image found, return null

      // Convert Base64 to bytes
      List<int> imageBytes = base64Decode(base64Image);

      // Get the temporary directory
      Directory tempDir = await Directory.systemTemp.createTemp();

      // Create a file with the goalId as its name
      File imageFile = File('${tempDir.path}/$goalId.png');

      // Write bytes to the file
      await imageFile.writeAsBytes(imageBytes);

      return imageFile;
    } catch (e) {
      print("❌ Error retrieving image: $e");
      return null;
    }
  }
}
