import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum OnboardingStep { name, age, avatar }

class KidOnboardingController extends GetxController {
  final kidsService = Get.find<KidService>();
  final authService = Get.find<AuthService>();
  final ImagePicker _picker = ImagePicker();

  // Step Management
  final currentStep = OnboardingStep.name.obs;

  // Form Data
  final _name = ''.obs;
  final _age = 0.obs;
  final _selectedAvatarIndex = (-1).obs;
  final _customImagePath = ''.obs;
  final _selectedAvatarUrl = ''.obs;
  final _avatars = <String>[].obs;
  final _isLoading = false.obs;

  // Getters
  String get name => _name.value;

  int get selectedAge => _age.value;

  int get selectedAvatarIndex => _selectedAvatarIndex.value;

  String get customImagePath => _customImagePath.value;

  String get selectedAvatarUrl => _selectedAvatarUrl.value;

  List<String> get avatars => _avatars;

  bool get isLoading => _isLoading.value;

  // Age options as defined in original controller
  final ageList = ['6', '7', '8', '9', '10', '11', '12', '13', '14+'];

  @override
  void onInit() {
    super.onInit();
    loadAvatars();
  }

  // Navigation Functions
  void proceedToAge() {
    if (_name.value.isEmpty) {
      ToastUtil.showToast("Please enter your name");
      return;
    }

    currentStep.value = OnboardingStep.age;
  }

  void proceedToAvatar() {
    if (_age.value == 0) {
      ToastUtil.showToast("Please select your age");
      return;
    }

    currentStep.value = OnboardingStep.avatar;
  }

  void goBack() {
    switch (currentStep.value) {
      case OnboardingStep.name:
        Get.back(); // Return to role selection
        break;
      case OnboardingStep.age:
        currentStep.value = OnboardingStep.name;
        break;
      case OnboardingStep.avatar:
        currentStep.value = OnboardingStep.age;
        break;
    }
  }

  // Data Functions
  void setName(String value) => _name.value = value.trim();

  void setAge(String value) {
    if (value == '14+') {
      _age.value = 14;
    } else {
      _age.value = int.tryParse(value) ?? 0;
    }
  }

  Future<void> loadAvatars() async {
    try {
      _isLoading.value = true;
      final urls = await kidsService.fetchPredefinedAvatars();
      _avatars.value = urls;
      if (urls.isNotEmpty) {
        _selectedAvatarUrl.value = urls.first;
      }
    } catch (e) {
      ToastUtil.showToast('Failed to load avatars: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> takePicture() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      _customImagePath.value = image.path;
      _selectedAvatarIndex.value = -1;
      _selectedAvatarUrl.value = '';
    }
  }

  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      _customImagePath.value = image.path;
      _selectedAvatarIndex.value = -1;
      _selectedAvatarUrl.value = '';
    }
  }

  void selectAvatar(int index) {
    _selectedAvatarIndex.value = index;
    _customImagePath.value = '';
    _selectedAvatarUrl.value = avatars[index];
  }

  void skipAvatar() {
    _completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    if (_selectedAvatarIndex.value == -1 && _customImagePath.isEmpty) {
      ToastUtil.showToast("Please select an avatar or upload a photo");
      return;
    }
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    try {
      _isLoading.value = true;

      final parentId = authService.user.value?.uid;
      if (parentId == null) {
        ToastUtil.showToast("User not authenticated");
        return;
      }

      await kidsService.createKid(name: _name.value, age: _age.value, parentId: parentId, customImagePath: _customImagePath.value, selectedAvatarUrl: _selectedAvatarUrl.value, isConnected: false);

      ToastUtil.showToast("Profile created successfully!");
      Get.offAllNamed(Routes.kidBase);
    } catch (e) {
      ToastUtil.showToast("Failed to create profile: $e");
    } finally {
      _isLoading.value = false;
    }
  }
}
