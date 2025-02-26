import 'package:coin_kids/data/remote_services/auth_service.dart';

import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthService _authService = Get.find();

  final email = ''.obs;
  final number = ''.obs;
  final parentName = ''.obs;
  final password = ''.obs;
  final confirmPassword = "".obs;
  final isEmailLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isAppleLoading = false.obs;
  final isNormalLoading = false.obs;
  final parentPin = 0.obs;

  // Reactive state for tracking if fields are filled
  final isButtonEnabled = false.obs;
  final showPassword = true.obs;
  final showConfirmPassword = true.obs;

  // Update button state whenever a field changes
  void checkFields() {
    isButtonEnabled.value = email.value.isNotEmpty && password.value.isNotEmpty;
  }
}
