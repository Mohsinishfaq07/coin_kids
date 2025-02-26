import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Define the AddChildController
class AddChildController extends GetxController {
  final kidsService = Get.find<KidService>();
  final authService = Get.find<AuthService>();
  final ImagePicker _picker = ImagePicker();

  final childName = ''.obs;
  final childAge = ''.obs;

  final selectedAvatar = (0).obs;
  final selectedAvatarPath = ''.obs;
  final avatars = <String>[].obs;
  final kidImagePath = ''.obs;

  final isLoading = false.obs;
  final isLoadingAvatars = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAvatars();
  }

  Future<void> loadAvatars() async {
    try {
      isLoadingAvatars.value = true;
      final urls = await kidsService.fetchPredefinedAvatars();
      avatars.value = urls;
      selectedAvatarPath.value = urls.first;
    } catch (e) {
      ToastUtil.showToast('Failed to load avatars: $e');
    } finally {
      isLoadingAvatars.value = false;
    }
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        kidImagePath.value = pickedFile.path;
        selectedAvatarPath.value = '';
        selectedAvatar.value = -1;
      }
    } catch (e) {
      ToastUtil.showToast("Failed to pick image: $e");
    }
  }

  void selectAvatar(int index) {
    selectedAvatar.value = index;
    kidImagePath.value = ''; // Clear custom avatar selection
    selectedAvatarPath.value = avatars[index];
  }

  Future<void> createKid() async {
    try {
      // Validate inputs
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

      final parentId = authService.user.value?.uid;
      if (parentId == null) {
        ToastUtil.showToast("User Session Expired");
        Get.offAll(() => LoginScreen());
        return;
      }

      await kidsService.createKid(
        name: childName.value,
        age: int.parse(childAge.value),
        parentId: parentId,
        customImagePath: kidImagePath.value,
        selectedAvatarUrl: selectedAvatarPath.value,
      );

      // final controller = Get.find<ParentBaseController>();
      // controller.showNavBar.value = true;

      ToastUtil.showToast("Child added successfully");
      Get.back();
    } catch (e) {
      ToastUtil.showToast("Failed to add child: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
