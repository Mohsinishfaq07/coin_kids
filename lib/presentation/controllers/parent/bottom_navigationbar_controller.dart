import 'dart:io';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/message_placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/parent/home_screen/parent_home_screen.dart';
import '../../screens/parent/shop/shop.dart';

class ParentNavigationBarController extends GetxController {
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
