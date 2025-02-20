import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/message_placeholder_screen.dart';
import 'package:coin_kids/presentation/screens/common/authentication/parent_signup/parent_model.dart';
import 'package:coin_kids/presentation/screens/parent/home_screen/parent_home_screen.dart';
import 'package:coin_kids/presentation/screens/parent/shop/shop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentController extends GetxController {

  final RxBool isLoading = false.obs;
  final ParentService _parentService = ParentService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  var parentId = ''.obs;
  var kidsList = [].obs;
  var parentName = ''.obs;
  var kidName = ''.obs;
  
  Rx<ParentModel?> currentParent = Rx<ParentModel?>(null);
  
  RxString selectedChildIdForQuickTransfer = ''.obs;
  RxString selectedChildNameForQuickTransfer = ''.obs;

  // controller values for parent quick transfer
  RxString amount = ''.obs;
  RxString message = ''.obs;
  RxString amountValidation = ''.obs;



  Future<bool> fetchKids() async {
    // Get.log('kids app parent id in starting:${FirebaseAuth.instance.currentUser!.uid}');
    try {
      isLoading.value = true; // Start loading

      // Fetch the initial snapshot
      final QuerySnapshot initialSnapshot = await _firestore
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Process the initial data
      kidsList.value = initialSnapshot.docs.map((doc) {
        var docData = doc.data() as Map<String, dynamic>?;
        if (docData != null) {
          docData['id'] = doc.id;
          Get.log('kids app doc id: ${doc.id}');
        }
        return docData ?? {};
      }).toList();

      // Listen to updates for real-time changes
      _firestore
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        kidsList.value = snapshot.docs.map((doc) {
          var docData = doc.data() as Map<String, dynamic>?;
          if (docData != null) {
            docData['id'] = doc.id;
            Get.log('kids app doc id: ${doc.id}');
          }
          return docData ?? {};
        }).toList();

        isLoading.value = false;
        Get.log('kids app kid list status: ${kidsList.isNotEmpty}');
      });

      isLoading.value = false; // Stop loading
      return kidsList.isNotEmpty; // Return whether kidsList has data
    } catch (e) {
      isLoading.value = false; // Ensure loading is stopped on error
      ToastUtil.showToast("Failed to fetch kids: $e");
      return false; // Return false in case of an error
    }
  }

  Future<void> updateParentProfile({required ParentModel originalParent}) async {
    try {
      isLoading.value = true;

      final updatedParent = originalParent.copyWith(
        name: firebaseAuthController.parentName.value,
        dob: DateFormat('d MMM, y').parse(firebaseAuthController.birthday.value),
        gender: firebaseAuthController.selectedGender.value,
      );

      await _parentService.updateParent(updatedParent);
      
      // Update the current parent data
      currentParent.value = updatedParent;
      parentName.value = updatedParent.name;
      
      ToastUtil.showToast('Profile updated successfully');
      Get.back();
    } catch (e) {
      ToastUtil.showToast('Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  var selectedColorIndex = (-1).obs; // Default to no selection
  RxBool isSelected = false.obs; //

  // Update Spending Jar Color in Firebase
  Future<void> updateSavingJarColor({
    required bool save,
    required String childId,
    required Color spendingJarColor, // Color passed as parameter
  }) async {
    try {
      // Show loading dialog
      // showDialog(
      //   context: Get.context!,
      //   builder: (context) => LoadingProgressDialogueWidget(
      //     title: "Saving...",
      //   ),
      // );

      // Reference to the kid's document
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(childId);
      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        // Convert color to a string value (Hex or RGBA)
        String colorHex = spendingJarColor.value
            .toRadixString(16)
            .padLeft(8, '0'); // Converts to hex format

        if (save) {
          // Save the updated spending jar color as a hex string
          await kidDocRef.update({
            'savings.color': colorHex, // Use dot notation for nested fields
          });
          // Close loading dialog
          // Get.back();
          print("Spending Jar Color updated successfully to: $colorHex");
          Get.log("Spending Jar Color updated successfully to: $colorHex");
          // Get.to(() => AmountScreen(
          //       isSpending: false.obs,
          //     ));
        } else {
          Get.back();
          Get.log("Save flag is false. No changes made.");
        }
      } else {
        Get.back();
        Get.log("Kid document does not exist.");
      }
    } catch (e) {
      // Handle errors
      Get.back();
      Get.log("Error updating spending jar color: $e");
    }
  }






  var currentIndex = 0.obs;
  var toggleValue = true.obs;
  var toggleValue1 = true.obs;

  final List<Widget> screens = [
    const ParentsHomeScreen(),
    const MessagePlaceholderScreen(),
    ShopScreen(),
    //KidZoneScreen(),
  ];

  Future<void> loadAvatarFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPath = prefs.getString('profileImagePath');

    if (storedPath != null && storedPath.isNotEmpty) {
      customAvatarPath.value = storedPath;
    }
  }

  var selectedAvatar = 0.obs;

  var customAvatarPath = ''.obs;

  final selectedAvatarPath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickUpFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final String localPath = await saveImageLocally(File(pickedFile.path));
        // customAvatarPath.value = localPath;
        // selectedAvatarPath.value = '';
        customAvatarPath.value = localPath;

        // Save the image path in Firestore
        // await FirebaseFirestore.instance
        //     .collection('parent') // Parent collection
        //     .doc(firebaseAuthController
        //         .email.value) // Replace with actual user ID
        //     .update({'image': localPath});

        // Save the image path in SQLite
        // await DatabaseHelper.instance.insertImage(localPath);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', localPath);

        ToastUtil.showToast("Image saved locally.");
      } else {}
    } catch (e) {
      ToastUtil.showToast("Failed to pick and save image: $e");
    }
  }

  Future<void> pickFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final String localPath = await saveImageLocally(File(pickedFile.path));
        customAvatarPath.value = localPath;

        // Save the image path in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', localPath);
      }
    } catch (e) {
      ToastUtil.showToast("Failed to capture and save image: $e");
    }
  }

  // Save the image locally
  Future<String> saveImageLocally(File image) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File localImage = await image.copy('${appDir.path}/$fileName.jpg');
      return localImage.path; // Return the local path
    } catch (e) {
      ToastUtil.showToast("Failed to save image locally: $e");
      rethrow;
    }
  }
}
