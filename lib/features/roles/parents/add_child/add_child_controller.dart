import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Define the AddChildController
class AddChildController extends GetxController {
  // Observable fields
  var childName = ''.obs;
  var childAge = ''.obs;
  var selectedGrade = ''.obs;
  var selectedAvatar = 0.obs;
  var customAvatarPath = ''.obs; // Path for custom uploaded avatar
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
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Change to ImageSource.camera for camera
      imageQuality: 80,
    );

    if (pickedFile != null) {
      customAvatarPath.value = pickedFile.path;
      selectedAvatar.value = -1; // To differentiate custom avatar
    }
  }

  // Function to update selected grade
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
    if (childName.isEmpty || selectedGrade.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    try {
      String avatarUrl = customAvatarPath.value.isNotEmpty
          ? customAvatarPath.value // Use custom avatar if uploaded
          : avatars[selectedAvatar.value]; // Use selected avatar

      // Reference to the parent document
      DocumentReference parentRef =
          _firestore.collection('parents').doc(parentId.value);

      // Prepare child data
      final Map<String, dynamic> childData = {
        'name': childName.value,
        'parentId': FirebaseAuth.instance.currentUser!.uid,
        'grade': selectedGrade.value,
        'parent': parentRef,
        'avatar': avatarUrl,
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

      Get.snackbar("Success", "Child added and parent updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add child: $e");
      Get.log(e.toString());
    }
  }
}
