import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/local_services/databse_helper.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Define the AddChildController
class AddChildController extends GetxController {
  // Observable fields
  var childName = ''.obs;
  var kidGoalName = ''.obs;
  var childAge = ''.obs;
  var selectedAvatar = (-1).obs;
  var kidImagePath = ''.obs; // Path for custom uploaded avatar
  final selectedAvatarPath = ''.obs;
  var parentId = ''.obs; // Observable for parentId
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final KidService _kidService = KidService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final isLoading = false.obs;

  final List<String> avatars = [
    "assets/child_avatar_image_pngs/Frame 1.png",
    "assets/child_avatar_image_pngs/Frame 2.png",
    "assets/child_avatar_image_pngs/Frame 3.png",
    "assets/child_avatar_image_pngs/Frame 4.png",
    "assets/child_avatar_image_pngs/Frame 5.png",
    "assets/child_avatar_image_pngs/Frame 6.png",
    "assets/child_avatar_image_pngs/Frame 7.png",
    "assets/child_avatar_image_pngs/Frame 8.png",
    "assets/child_avatar_image_pngs/Frame 9.png",
    "assets/child_avatar_image_pngs/Frame 10.png",
    "assets/child_avatar_image_pngs/Frame 11.png",
    "assets/child_avatar_image_pngs/Frame 12.png",
    "assets/child_avatar_image_pngs/Frame 13.png",
    "assets/child_avatar_image_pngs/Frame 14.png",
    "assets/child_avatar_image_pngs/Frame 15.png",
    "assets/child_avatar_image_pngs/Frame 16.png",
    "assets/child_avatar_image_pngs/Frame 17.png",
    "assets/child_avatar_image_pngs/Frame 18.png",
    "assets/child_avatar_image_pngs/Frame 19.png",
    "assets/child_avatar_image_pngs/Frame 20.png",
    "assets/child_avatar_image_pngs/Frame 21.png",
    "assets/child_avatar_image_pngs/Frame 22.png",
    "assets/child_avatar_image_pngs/Frame 23.png",
    "assets/child_avatar_image_pngs/Frame 24.png",
    "assets/child_avatar_image_pngs/Frame 25.png",
    "assets/child_avatar_image_pngs/Frame 26.png",
    "assets/child_avatar_image_pngs/Frame 27.png",
    "assets/child_avatar_image_pngs/Frame 28.png",
    "assets/child_avatar_image_pngs/Frame 29.png",
    "assets/child_avatar_image_pngs/Frame 30.png",
    "assets/child_avatar_image_pngs/Frame 31.png",
    "assets/child_avatar_image_pngs/Frame 32.png",
    "assets/child_avatar_image_pngs/Frame 33.png",
    "assets/child_avatar_image_pngs/Frame 34.png",
    "assets/child_avatar_image_pngs/Frame 35.png",
    "assets/child_avatar_image_pngs/Frame 36.png"
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
      ToastUtil.showToast("Failed to fetch parent ID: $e");
    }
  }

  final ImagePicker _picker = ImagePicker();

  // Function to open camera or gallery to upload photo
  Future<void> pickKidImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final String localPath = await saveImageLocally(File(pickedFile.path));
        kidImagePath.value = localPath;
        selectedAvatarPath.value = '';
        // Save the image path in SQLite
        await DatabaseHelper.instance.insertImage(localPath);

        ToastUtil.showToast("Image saved locally.");
      } else {
        ToastUtil.showToast(
          "No Image Selected",
        );
      }
    } catch (e) {
      ToastUtil.showToast("Failed to pick and save image: $e");
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

  void deselectAvatar() {
    selectedAvatar.value = -1; // Deselect by setting to -1 or any invalid value
  }

  // Function to update selected avatar
  void selectAvatar(int index) {
    selectedAvatar.value = index;
    kidImagePath.value = ''; // Clear custom avatar selection

    selectedAvatarPath.value = avatars[index];

    Get.log('selected avatar path: ${selectedAvatarPath.value}');
  }

  // Method to create a new kid
  Future<void> createKid() async {
    try {
      if (childName.value.isEmpty) {
        ToastUtil.showToast("Please enter child name");
        return;
      }

      if (childAge.value.isEmpty) {
        ToastUtil.showToast("Please enter child age");
        return;
      }

      if (kidImagePath.value.isEmpty && selectedAvatarPath.value.isEmpty) {
        ToastUtil.showToast("Please select an avatar or upload an image");
        return;
      }

      isLoading.value = true;

      String avatarUrl = selectedAvatarPath.value;

      // If a custom image was uploaded, upload it to Firebase Storage
      if (kidImagePath.value.isNotEmpty) {
        final File imageFile = File(kidImagePath.value);
        final String fileName =
            'kid_avatars/${DateTime.now().millisecondsSinceEpoch}${imageFile.path.split('.').last}';
        final Reference ref = _storage.ref().child(fileName);

        final UploadTask uploadTask = ref.putFile(imageFile);
        final TaskSnapshot snapshot = await uploadTask;
        avatarUrl = await snapshot.ref.getDownloadURL();
      }

      // Create initial wallet with empty jars
      final wallet = Wallet(
        savingJar: WalletJar(balance: 0.0, color: '#000000'),
        spendingJar: WalletJar(balance: 0.0, color: '#000000'),
      );

      // Create kid model with a unique kidId
      final KidModel kid = KidModel(
        name: childName.value,
        age: int.parse(childAge.value),
        avatar: avatarUrl,
        parentId: FirebaseAuth.instance.currentUser!.uid,
        wallet: wallet,
        coinKidsBalance: 0.0,
        createdAt: DateTime.now(),
        kidId: '', // Placeholder for now
      );

      // Add kid to Firestore and get the document reference
      final DocumentReference docRef = await _kidService.createKid(kid);

      // Set the kidId to the generated document ID
      final kidId = docRef.id;
      await _kidService.updateKid(kidId, kid.copyWith(kidId: kidId));

      ToastUtil.showToast("Child added successfully");
      Get.back();
    } catch (e) {
      ToastUtil.showToast("Failed to add child: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
