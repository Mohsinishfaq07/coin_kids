import 'dart:io';

import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Define the AddChildController
class EditChildController extends GetxController {
  final kidsService = Get.find<KidService>();
  final authService = Get.find<AuthService>();
  final appState = Get.find<AppStateController>();
  final ImagePicker _picker = ImagePicker();

  final childName = 'Enter new name'.obs;
  final childAge = 'Enter age'.obs;

  // Store original values to check for changes
  String originalName = '';
  String originalAge = '';
  String originalAvatar = '';

  final selectedAvatar = 0.obs; // -1 means no predefined avatar selected
  final selectedAvatarPath = ''.obs;
  final avatars = <String>[].obs;
  final kidImagePath = ''.obs;

  final isLoading = false.obs;
  final isLoadingAvatars = true.obs;

  @override
  void onInit() {
    super.onInit();

    final kid = appState.currentKid.value;

    if (kid == null) {
      ToastUtil.showToast("Session Expired, Login Again");
      Get.offAllNamed(Routes.signIn);
      return;
    }

    // Store original values
    originalName = kid.name;
    originalAge = kid.age.toString();
    originalAvatar = kid.avatar;

    // Set current values
    childName.value = originalName;
    childAge.value = originalAge;

    loadAvatars();
  }

  Future<void> loadAvatars() async {
    try {
      isLoadingAvatars.value = true;
      final urls = await kidsService.fetchPredefinedAvatars();
      avatars.value = urls;

      // Check if current avatar is a predefined one
      if (originalAvatar.isNotEmpty) {
        final avatarIndex = avatars.indexOf(originalAvatar);
        if (avatarIndex != -1) {
          selectedAvatar.value = avatarIndex;
          selectedAvatarPath.value = originalAvatar;
        } else {
          // If not predefined, it's a custom avatar
          kidImagePath.value = originalAvatar;
          selectedAvatar.value = -1;
        }
      }
    } catch (e) {
      ToastUtil.showToast('Failed to load avatars: $e');
    } finally {
      isLoadingAvatars.value = false;
    }
  }

  bool hasChanges() {
    return childName.value != originalName ||
        childAge.value != originalAge ||
        (kidImagePath.value.isNotEmpty &&
            kidImagePath.value != originalAvatar) ||
        (selectedAvatarPath.value.isNotEmpty &&
            selectedAvatarPath.value != originalAvatar);
  }

  Future<void> updateKid() async {
    try {
      if (!hasChanges()) {
        Get.back();
        return;
      }

      // Validate inputs
      if (childName.value.isEmpty) {
        ToastUtil.showToast("Please enter child name");
        return;
      }

      if (childAge.value.isEmpty) {
        ToastUtil.showToast("Please enter child age");
        return;
      }

      isLoading.value = true;

      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      // Only update changed values
      Map<String, dynamic> updates = {};

      if (childName.value != originalName) {
        updates['name'] = childName.value;
      }

      if (childAge.value != originalAge) {
        updates['age'] = int.parse(childAge.value);
      }

      showLoadingDialog("Updating Profile");

      // Handle avatar update
      if (kidImagePath.value.isNotEmpty &&
          kidImagePath.value != originalAvatar) {
        try {
          // Upload new custom image
          print(
              "Uploading image from path: ${kidImagePath.value}"); // Debug log
          final String avatarUrl =
              await kidsService.uploadCustomAvatar(File(kidImagePath.value));
          print("Got avatar URL: $avatarUrl"); // Debug log
          updates['avatar'] =
              avatarUrl; // Changed from 'user_avatars' to 'avatar'
        } catch (e) {
          print("Error uploading avatar: $e"); // Debug log
          throw Exception("Failed to upload avatar: $e");
        }
      } else if (selectedAvatarPath.value.isNotEmpty &&
          selectedAvatarPath.value != originalAvatar) {
        // Update to new predefined avatar
        updates['avatar'] =
            selectedAvatarPath.value; // Changed from 'user_avatars' to 'avatar'
      }

      if (updates.isNotEmpty) {
        await kidsService.updateKid(
          kid.kidId,
          kid.copyWith(
            name: updates['name'] as String? ?? kid.name,
            age: updates['age'] as int? ?? kid.age,
            avatar: updates['avatar'] as String? ?? kid.avatar,
          ),
        );
      }

      ToastUtil.showToast("Child updated successfully");
    } catch (e) {
      print("Update failed: $e"); // Debug log
      ToastUtil.showToast("Failed to update child: $e");
    } finally {
      Get.until((route) => route.settings.name == Routes.parentKidProfile);
      isLoading.value = false;
    }
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        print("Image picked: ${pickedFile.path}"); // Debug log
        kidImagePath.value = pickedFile.path;
        selectedAvatarPath.value = '';
        selectedAvatar.value = -1;
        update(); // Force UI update
      }
    } catch (e) {
      print("Error picking image: $e"); // Debug log
      ToastUtil.showToast("Failed to pick image: $e");
    }
  }

  void selectAvatar(int index) {
    selectedAvatar.value = index;
    kidImagePath.value = ''; // Clear custom avatar selection
    selectedAvatarPath.value = avatars[index];
  }
}
