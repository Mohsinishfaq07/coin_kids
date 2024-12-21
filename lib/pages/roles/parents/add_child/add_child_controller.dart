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
  final selectedImagePath = ''.obs;
  var parentId = ''.obs; // Observable for parentId
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List of predefined avatars
  final List<String> avatars = [
    'assets/avatar1.png',
    'assets/avatar2.png',
    'assets/avatar3.png',
  ];
  @override
  void onInit() {
    super.onInit();
    fetchParentId(); // Dynamically fetch parentId
  }

  Future<void> fetchParentId() async {
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
  }

  // Add new child and update parent reference
  Future<void> addChildAndUpdateParent() async {
    Get.log(
      'Adding new child with parent ID: ${parentId.value}',
    );
    if (childName.value.isEmpty || childAge.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      final String avatarUrl = customAvatarPath.value; // Use selected avatar

      // Reference to the parent document
      DocumentReference parentRef =
          _firestore.collection('parents').doc(parentId.value);

      // Prepare child data
      final Map<String, dynamic> childData = {
        'name': childName.value,
        'parentId': FirebaseAuth.instance.currentUser!.uid,
        'grade': 'Grade 1',
        'parent': parentRef,
        'avatar': avatarUrl,
        'age': childAge.value,
        'savings': {
          'amount': '15', // Default savings value
          'color': '#227799',
          'name': 'Savings',
        },
        'spendings': {
          'amount': 45, // Default spendings value
          'color': '#F54422',
          'name': 'Spendings',
        },
      };

      // Add child and update parent in a transaction
      await _firestore.runTransaction((transaction) async {
        DocumentReference newChildRef = _firestore.collection('kids').doc();
        transaction.set(newChildRef, childData);
        transaction.update(parentRef, {
          'kids': FieldValue.arrayUnion([newChildRef])
        });
      });
      Get.to(() => ParentsHomeScreen());

      Get.snackbar("Success", "Child added and parent updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add child: $e");
      Get.log(e.toString());
    }
  }
}
