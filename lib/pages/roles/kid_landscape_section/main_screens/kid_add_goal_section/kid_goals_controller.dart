import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KidGoalsController extends GetxController {
  var isLoading = false.obs;
  var isEditMode = false.obs;
  var goalCurrentAmount = 0.0.obs;
  final ImagePicker picker = ImagePicker();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  RxString goalName = ''.obs;
  RxDouble goalAmount = 0.0.obs;
  RxString goalImage = ''.obs;
  RxBool isPickingImage = false.obs; // Add flag

  void setGoalCurrentAmount(double amount) {
    goalCurrentAmount.value = amount;
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        goalImage.value = pickedFile.path;

        // ToastUtil.showToast("Image saved locally.");
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
        'currentAmount': 0.0,
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

          // final String localPath =
          //     await saveImageLocally(File(goalImage.value), goalRef.id);
          // goalImage.value = localPath;
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

  Future<void> saveGoalIdToPrefs(String goalId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentGoalId', goalId);
  }

  Future<String?> getGoalIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentGoalId');
  }

  Future<void> saveImageToPrefs(String goalId, File? imageFile) async {
    try {
      List<int> imageBytes;

      // **Check if imageFile is valid**
      if (imageFile == null || !imageFile.existsSync()) {
        print("Invalid image file provided. Using default image.");

        // **Load the default image from assets**
        ByteData assetData = await rootBundle.load('assets/dollar_coin.png');
        imageBytes = assetData.buffer.asUint8List();
      } else {
        // **Read the provided image file**
        imageBytes = await imageFile.readAsBytes();
      }

      // **Convert image to Base64 string**
      String base64Image = base64Encode(imageBytes);

      // **Store in SharedPreferences with goalId as key**
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('goal_image_$goalId', base64Image);

      print("Image saved successfully for goalId: $goalId");
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  Future<void> removeImageFromPrefs(String goalId) async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('goal_image_$goalId'); // Remove image based on goalId
    goalImage.value = "";
    isLoading.value = false;
    ToastUtil.showToast("Goal Image Removed");
    print("Image removed from SharedPreferences");
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

  var sliderValue = 0.0.obs; // .obs makes it reactive
  RxBool isMinus = false.obs;

  // Function to update slider value
  void updateValue(double value) {
    sliderValue.value = value;
  }

  // Function to set the goal amount (max value)
  void setGoalAmount(double amount) {
    // If you want to update slider value to 0 when the goalAmount is set
    sliderValue.value = 0.0;
  }

  Future<void> GoalsTOSpending({
    required String kidId,
    required String goalId,
    required double enteredAmount,
  }) async {
    try {
      // References to Firestore collections
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(kidId);
      DocumentReference goalDocRef =
          FirebaseFirestore.instance.collection('goals').doc(goalId);

      // Fetch current spending details
      DocumentSnapshot kidSnapshot = await kidDocRef.get();
      if (!kidSnapshot.exists) {
        Get.back();
        Get.log("Kid document not found: $kidId");
        return;
      }

      double currentSpending = (kidSnapshot.data()
              as Map<String, dynamic>?)?['spendings']?['amount'] ??
          0.0;

      if (enteredAmount > currentSpending) {
        Get.back();
        ToastUtil.showToast('Not Enough Funds');

        return;
      }

      // Deduct from spending
      double updatedSpending = currentSpending + enteredAmount;

      // Update spending in `kids` collection
      await kidDocRef.update({
        'spendings.amount': updatedSpending,
      });

      // Fetch existing goal amount
      DocumentSnapshot goalSnapshot = await goalDocRef.get();
      if (!goalSnapshot.exists) {
        Get.back();
        Get.log("Goal document not found: ");
        return;
      }
      double currentGoalAmount =
          (goalSnapshot.data() as Map<String, dynamic>?)?['currentAmount']
                  ?.toDouble() ??
              0.0;

      double updatedGoalAmount = currentGoalAmount - enteredAmount;

      // Update or create goal document in `goals` collection
      await goalDocRef.update(
        {
          'kidId': kidId,
          'currentAmount': updatedGoalAmount,
        },
      );

      // Get.back();
      Get.log(
          "Funds moved successfully: $enteredAmount transferred from Spendings to Goals.");
      ToastUtil.showToast('Funds moved to Spendings successfully!');
    } catch (e) {
      Get.back();
      Get.log("Error transferring funds: $e");
    }
  }

  Future<void> SpendingTOGoals({
    required String kidId,
    required String goalId,
    required double enteredAmount,
  }) async {
    try {
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(kidId);
      DocumentReference goalDocRef =
          FirebaseFirestore.instance.collection('goals').doc(goalId);

      // Fetch current spending details
      DocumentSnapshot kidSnapshot = await kidDocRef.get();
      if (!kidSnapshot.exists) {
        Get.back();
        Get.log("Kid document not found: $kidId");
        return;
      }

      double currentSpending = (kidSnapshot.data()
              as Map<String, dynamic>?)?['spendings']?['amount'] ??
          0.0;

      // Fetch existing goal amount
      DocumentSnapshot goalSnapshot = await goalDocRef.get();
      if (!goalSnapshot.exists) {
        Get.back();
        Get.log("Goal document not found: ");
        return;
      }

      double currentGoalAmount =
          (goalSnapshot.data() as Map<String, dynamic>?)?['currentAmount']
                  ?.toDouble() ??
              0.0;
      double goalAmount =
          (goalSnapshot.data() as Map<String, dynamic>?)?['amount']
                  ?.toDouble() ??
              0.0;

      // Check if the goal is already completed (currentGoalAmount >= goalAmount)
      if (currentGoalAmount == goalAmount) {
        ToastUtil.showToast('Goal already achieved!');
        return; // If goal is already reached, prevent any changes
      }

      if (enteredAmount > currentSpending) {
        ToastUtil.showToast('Not Enough Funds');
        return;
      }

      if (enteredAmount > goalAmount) {
        ToastUtil.showToast('Not Enough Funds');
        return;
      }

      // Deduct from spending only if goal is not completed
      double updatedSpending = currentSpending - enteredAmount;

      // Update spending in `kids` collection
      await kidDocRef.update({
        'spendings.amount': updatedSpending,
      });

      // Prevent exceeding the goalAmount while updating goal
      if (currentGoalAmount + enteredAmount > goalAmount) {
        ToastUtil.showToast('Goal amount already reached!');
        return; // Prevent further processing if goal amount is exceeded
      }

      // Update goal amount
      double updatedGoalAmount = currentGoalAmount + enteredAmount;
      int completionPercentage =
          ((updatedGoalAmount / goalAmount) * 100).toInt();

      // Update goal document in `goals` collection
      await goalDocRef.update({
        'kidId': kidId,
        'currentAmount': updatedGoalAmount,
        'progress': completionPercentage,
      });

      // Mark goal as completed if the goal is fully achieved
      if (updatedGoalAmount >= goalAmount) {
        await goalDocRef.update({
          'completed': true,
        });
        Get.log("Goal completed!");
      }
      // previousValue.value = 0.0;
      Get.log(
          "Funds moved successfully: $enteredAmount transferred from Spendings to Goals.");
      ToastUtil.showToast(
        'Funds moved to Goals successfully!',
      );
    } catch (e) {
      Get.back();
      Get.log("Error transferring funds: $e");
    }
  }
}
