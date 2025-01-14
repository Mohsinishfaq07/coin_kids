import 'dart:io';

import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/message_placeholder_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationbarController extends GetxController {
  var currentIndex = 0.obs; // Reactive index to track selected tab

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

  Future<void> pickCustomAvatar() async {
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

        // Get.snackbar("Success", "Image saved locally.");
      } else {
        // Get.snackbar("No Image Selected", "Please select an image.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick and save image: $e");
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
      Get.snackbar("Error", "Failed to save image locally: $e");
      rethrow;
    }
  }









}

 



class KidZoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kid Zone'),
      ),
      body: Center(
        child: Text(
          'Welcome to Kid Zone Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
