import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/firebase/firebase_authentication/authentication_controller.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KidGoalsController extends GetxController {
  var sliderValue = 0.0.obs; // .obs makes it reactive
  RxBool isMinus = false.obs;

  var isImageRemoved = false.obs;
  var isLoading = false.obs;
  var isEditMode = false.obs;
  var goalCurrentAmount = 0.0.obs;
  final ImagePicker picker = ImagePicker();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final authController = Get.find<AuthenticationController>();

  RxString goalName = ''.obs;
  RxDouble goalAmount = 0.0.obs;
  RxString goalImage = ''.obs;
  RxBool isPickingImage = false.obs; // Add flag
  var initialSliderValue = 0.0;
  void setInitialSliderValue(double value) {
    initialSliderValue = value;
  }

  double getInitialSliderValue() {
    return initialSliderValue;
  }

  void setGoalCurrentAmount(double amount) {
    goalCurrentAmount.value = amount;
  }

  final GoalService _goalService = Get.find<GoalService>();
  final KidService _kidService = Get.find<KidService>();
  final AuthService _authService = Get.find<AuthService>();

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
      authController.isNormalLoading.value = true;
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: true,
      );

      // Get current user ID
      final user = _authService.user.value;
      if (user == null) {
        ToastUtil.showToast("User not authenticated");
        authController.isNormalLoading.value = false;
        return;
      }

      // Get current kid using parent ID
      final kids = await _kidService.fetchKidsByParentId(user.uid);
      if (kids.isEmpty) {
        ToastUtil.showToast("No kid found");
        authController.isNormalLoading.value = false;
        return;
      }

      final KidModel currentKid = kids.first;
      final targetAmount = goalAmount.value;
      final spendingBalance = currentKid.wallet.spendingJar.balance;

      // Validate spending jar balance
      if (spendingBalance < targetAmount) {
        ToastUtil.showToast("Not enough funds in spending jar");
        authController.isNormalLoading.value = false;
        return;
      }

      // Create a new goal model with initial amount from spending
      final goal = GoalModel(
        userId: currentKid.kidId,
        title: goalName.value,
        photo: goalImage.value.isEmpty ? 'assets/logo.png' : goalImage.value,
        targetAmount: targetAmount,
        savedAmount: 0, // Initial amount same as target amount
        status: GoalStatus.in_progress,
        createdAt: DateTime.now(),
      );

      // Create the goal using GoalService which will also deduct from spending
      final goalRef = await _goalService.createGoal(goal);
      final goalId = goalRef.id;

      if (goalId.isNotEmpty) {
        // Save image if exists
        if (goalImage.value.isNotEmpty) {
          await saveImageToPrefs(goalId, File(goalImage.value));
        }
        await saveGoalIdToPrefs(goalId);

        // Reset values
        goalImage.value = "";
        goalName.value = "";
        goalAmount.value = 0.0;

        authController.isNormalLoading.value = false;
        ToastUtil.showToast("Goal added successfully");
        // Get.back(); // Remove loading dialog
      } else {
        authController.isNormalLoading.value = false;
        Get.back(); // Remove loading dialog
        ToastUtil.showToast("Failed to create goal");
      }
    } on TimeoutException catch (e) {
      authController.isNormalLoading.value = false;
      Get.back();
      ToastUtil.showToast("Operation timed out. Please try again.");
      print("Timeout error: $e");
    } catch (e) {
      authController.isNormalLoading.value = false;
      Get.back();
      ToastUtil.showToast(e.toString());
      print("Error adding goal: $e");
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

  // Function to update slider value
  void updateValue(double value) {
    sliderValue.value = value;
    initialSliderValue = value;
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

      // Update goal amounthor
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

  Future<void> deleteGoal(String goalId) async {
    try {
      isLoading.value = true;
      final kidSnapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (kidSnapshot.docs.isEmpty) {
        print("[DEBUG] No kids found");
        return;
      }

      final kidId = kidSnapshot.docs.first.id;

      // Get the goal document to check current amount
      DocumentSnapshot goalSnapshot =
          await _firebaseFirestore.collection('goals').doc(goalId).get();

      if (!goalSnapshot.exists) {
        ToastUtil.showToast("Goal not found");
        return;
      }

      // Get the current amount from the goal
      double currentGoalAmount =
          (goalSnapshot.data() as Map<String, dynamic>)['currentAmount']
                  ?.toDouble() ??
              0.0;

      // If there's any amount in the goal, transfer it to spendings
      if (currentGoalAmount > 0) {
        // Get the kid's document
        DocumentReference kidDocRef =
            _firebaseFirestore.collection('kids').doc(kidId);
        DocumentSnapshot kidSnapshot = await kidDocRef.get();

        if (kidSnapshot.exists) {
          // Get current spending amount
          double currentSpending = (kidSnapshot.data()
                      as Map<String, dynamic>)['spendings']?['amount']
                  ?.toDouble() ??
              0.0;

          // Add goal amount to spendings
          double updatedSpending = currentSpending + currentGoalAmount;

          // Update kid's spendings
          await kidDocRef.update({
            'spendings.amount': updatedSpending,
          });
        }
      }

      // Now proceed with the original delete operation
      await _firebaseFirestore.collection('goals').doc(goalId).update({
        'deleted': true,
      });
      await FirebaseFirestore.instance.collection('goals').doc(goalId).delete();

      // Remove the image from SharedPreferences
      await removeImageFromPrefs(goalId);

      ToastUtil.showToast("Goal deleted successfully");
      isLoading.value = false;
      Get.off(() => KidHomeScreen());
    } catch (e) {
      isLoading.value = false;
      ToastUtil.showToast("Failed to delete goal: $e");
      print("Error deleting goal: $e");
    }
  }

//  var goalsList = <Map<String, dynamic>>[].obs; // Reactive list

  // void fetchGoals(String kidId) {
  //   FirebaseFirestore.instance
  //       .collection('goals')
  //       .where('kidId', isEqualTo: kidId)
  //       .where('deleted', isEqualTo: false)
  //       .snapshots()
  //       .listen((snapshot) {
  //     if (snapshot.docs.isNotEmpty) {
  //       goalsList.value = snapshot.docs.map((doc) => doc.data()).toList();
  //     } else {
  //       goalsList.clear();
  //     }
  //   });
  // }
}
