import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum OnboardingStep { name, age, avatar }

class KidOnboardingController extends GetxController {
  final kidsService = Get.find<KidService>();
  final authService = Get.find<AuthService>();
  final ImagePicker _picker = ImagePicker();
  final analytics = Get.find<AnalyticsService>();

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
  DateTime? _screenStartTime;

  // Getters
  String get name => _name.value;

  int get selectedAge => _age.value;

  int get selectedAvatarIndex => _selectedAvatarIndex.value;

  String get customImagePath => _customImagePath.value;

  String get selectedAvatarUrl => _selectedAvatarUrl.value;

  List<String> get avatars => _avatars;

  bool get isLoading => _isLoading.value;

  final ageList = ['3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14+'];

  @override
  void onInit() {
    super.onInit();
    _screenStartTime = DateTime.now();
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
      showLoadingDialog("Creating Profile");

      final parentId = authService.user.value?.uid;
      if (parentId == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      await kidsService
          .createKid(
              name: _name.value,
              age: _age.value,
              parentId: parentId,
              customImagePath: _customImagePath.value,
              selectedAvatarUrl: _selectedAvatarUrl.value,
              isConnected: false)
          .timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Slow or No Internet Connection");
        },
      );
      await analytics.logEvent(AnalyticsEventNames.kidProfileCreated, {
        AnalyticsParameterNames.roleChild: AnalyticsParameterNames.kidProfileCreated
      });

      KidDialog.show(
        emoji: Assets.icHappyStar,
        title: "Profile Created",
        subtitle: "Let's Start My Journey",
        buttons: [
          KidButton(
              text: "Let's Go",
              onTap: () {
                Get.offAllNamed(Routes.kidBase);
              },
              baseColor: AppColors.btnColorGreen),
        ],
      );
    } catch (e) {
      Get.back();
      KidDialog.show(
        emoji: Assets.emojiSad,
        title: "Oops!",
        subtitle: "SomeThing went wrong",
        extraContent: Text(e.toString()),
        buttons: [
          KidButton(
            text: "Retry",
            onTap: () {
              _completeOnboarding();
            },
            baseColor: AppColors.btnColorRed,
          ),
        ],
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
