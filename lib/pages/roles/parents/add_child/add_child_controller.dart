import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Define the AddChildController
class AddChildController extends GetxController {
  // Observable fields
  var childName = ''.obs;
  var childAge = ''.obs;
  var selectedGrade = ''.obs;
  var selectedAvatar = 0.obs;
  var customAvatarPath = ''.obs; // Path for custom uploaded avatar
  final selectedAvatarPath = ''.obs;
  var parentId = ''.obs; // Observable for parentId
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> avatars = [
    "assets/child_avatar_image_pngs/Frame1.png",
    "assets/child_avatar_image_pngs/Frame2.png",
    "assets/child_avatar_image_pngs/Frame3.png",
    "assets/child_avatar_image_pngs/Frame4.png",
    "assets/child_avatar_image_pngs/Frame5.png",
    "assets/child_avatar_image_pngs/Frame6.png",
    "assets/child_avatar_image_pngs/Frame7.png",
    "assets/child_avatar_image_pngs/Frame8.png",
    "assets/child_avatar_image_pngs/Frame9.png",
    "assets/child_avatar_image_pngs/Frame10.png",
    "assets/child_avatar_image_pngs/Frame11.png",
    "assets/child_avatar_image_pngs/Frame12.png",
    "assets/child_avatar_image_pngs/Frame13.png",
    "assets/child_avatar_image_pngs/Frame14.png",
    "assets/child_avatar_image_pngs/Frame15.png",
    "assets/child_avatar_image_pngs/Frame16.png",
    "assets/child_avatar_image_pngs/Frame17.png",
    "assets/child_avatar_image_pngs/Frame18.png",
    "assets/child_avatar_image_pngs/Frame19.png"
  ];
  @override
  void onInit() {
    super.onInit();
    fetchParentId(); // Dynamically fetch parentId
  }

  Future<void> fetchParentId() async {
    Get.log('fetch parent id function starts');
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Query Firestore for the parent document
        final QuerySnapshot snapshot = await _firestore
            .collection('parents')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          parentId.value = snapshot.docs.first.id; // Set parentId dynamically
        }
        Get.log(
          'Parent Id: ${parentId.value}',
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch parent ID: $e");
    }
  }

  final ImagePicker _picker = ImagePicker();

  // Function to open camera or gallery to upload photo
  Future<void> pickCustomAvatar() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final String localPath = await saveImageLocally(File(pickedFile.path));
        customAvatarPath.value = localPath;
        selectedAvatarPath.value = '';
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

  void setGrade(String grade) {
    selectedGrade.value = grade;
  }

  // Function to update selected avatar
  void selectAvatar(int index) {
    selectedAvatar.value = index;
    customAvatarPath.value = ''; // Clear custom avatar selection

    selectedAvatarPath.value = avatars[index];

    Get.log('selected avatar path: ${selectedAvatarPath.value}');
  }

  // Add new child and update parent reference
}
