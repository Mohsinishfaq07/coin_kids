import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/presentation/dialogs/kid/custom_dialogs.dart';
import 'package:coin_kids/data/local_services/databse_helper.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuthenticationController extends GetxController {
  final AuthService _authService = Get.find();

  final email = ''.obs;
  final number = ''.obs;
  final birthday = ''.obs;
  final parentName = ''.obs;
  final password = ''.obs;
  final confirmPassword = "".obs;
  final selectedGender = ''.obs; // "Male" or "Female"
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

  void setBirthday(DateTime date) {
    final DateFormat formatter = DateFormat('d MMM, y');

    birthday.value = formatter.format(date);
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

}
