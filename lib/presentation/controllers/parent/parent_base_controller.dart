import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/parent_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/firebase/firebase_authentication/authentication_controller.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/message_placeholder_screen.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:coin_kids/presentation/screens/parent/home_screen/parent_home_screen.dart';
import 'package:coin_kids/presentation/screens/parent/shop/shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentBaseController extends GetxController {
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();
  final _parentService = Get.find<ParentService>();

  Rx<ParentModel?> parent = Rx<ParentModel?>(null);

  final hasKids = false.obs;

  var parentId = ''.obs;
  var parentName = ''.obs;
  var kidName = ''.obs;

  final authController = Get.find<AuthenticationController>();

  Rx<ParentModel?> currentParent = Rx<ParentModel?>(null);

  RxString selectedChildIdForQuickTransfer = ''.obs;
  RxString selectedChildNameForQuickTransfer = ''.obs;

  // controller values for parent quick transfer
  RxString amount = ''.obs;
  RxString message = ''.obs;
  RxString amountValidation = ''.obs;

  final RxString customAvatarPath = ''.obs;
  final RxString networkImageUrl = ''.obs;

  final isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    loadImageFromPreferences();

    _parentService.streamParentData().listen((parentData) {
      parent.value = parentData; // Update the observable with new data
    });

    final parentId = _authService.user.value?.uid;
    if (parentId == null) {
      ToastUtil.showToast("user session expired, Login Again");
      Get.offAll(() => LoginScreen());
      return;
    }

    // Listen to has kids status
    _kidService.streamHasKids(parentId).listen((hasAnyKids) => hasKids.value = hasAnyKids);
  }

  void fetchParentData() async {
    _parentService.streamParentData().listen((parentData) {
      parent.value = parentData; // Update the observable with new data
    });
  }

  Future<void> loadImageFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localPath = prefs.getString('profileImagePath');
      final networkUrl = prefs.getString('profileImageUrl');

      if (localPath != null && localPath.isNotEmpty) {
        // Check if local file exists
        if (await File(localPath).exists()) {
          customAvatarPath.value = localPath;
        }
      }

      if (networkUrl != null && networkUrl.isNotEmpty) {
        networkImageUrl.value = networkUrl;
      }
    } catch (e) {
      print('Error loading image from preferences: $e');
    }
  }

  Future<void> saveImageToPreferences({String? localPath, String? networkUrl}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (localPath != null) {
        await prefs.setString('profileImagePath', localPath);
        customAvatarPath.value = localPath;
      }

      if (networkUrl != null) {
        await prefs.setString('profileImageUrl', networkUrl);
        networkImageUrl.value = networkUrl;
      }
    } catch (e) {
      print('Error saving image to preferences: $e');
    }
  }

  Future<void> clearStoredImages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profileImagePath');
      await prefs.remove('profileImageUrl');
      customAvatarPath.value = '';
      networkImageUrl.value = '';
    } catch (e) {
      print('Error clearing stored images: $e');
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
      DocumentReference kidDocRef = FirebaseFirestore.instance.collection('kids').doc(childId);
      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        // Convert color to a string value (Hex or RGBA)
        String colorHex = spendingJarColor.value.toRadixString(16).padLeft(8, '0'); // Converts to hex format

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
    ParentsHomeScreen(),
    const MessagePlaceholderScreen(),
    ShopScreen(),
    //KidZoneScreen(),
  ];

  var selectedAvatar = 0.obs;

  final selectedAvatarPath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickUpFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final String localPath = await saveImageLocally(imageFile);
        await saveImageToPreferences(localPath: localPath);
        return imageFile;
      }
      return null;
    } catch (e) {
      ToastUtil.showToast("Failed to pick image: $e");
      return null;
    }
  }

  Future<File?> pickFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final String localPath = await saveImageLocally(imageFile);
        await saveImageToPreferences(localPath: localPath);
        return imageFile;
      }
      return null;
    } catch (e) {
      ToastUtil.showToast("Failed to capture image: $e");
      return null;
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
