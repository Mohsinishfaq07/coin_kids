import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/dialogs/kid/custom_dialogs.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final _authService = Get.find<AuthService>();

  final password = ''.obs;
  final email = ''.obs;

  final showPassword = true.obs;

  final isEmailLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isAppleLoading = false.obs;

  Future<void> signInWithEmail() async {
    try {
      isEmailLoading.value = true;
      showDialog(context: Get.context!, builder: (context) => LoadingProgressDialogueWidget(title: "Signing in..."));

      // Use AuthService for signup
      final credential = await _authService.signInWithEmailPassword(
        email: email.value,
        password: password.value,
      );

      if (credential.user != null) {
        SharedPreferencesHelper.saveBool(SharedPreferencesHelper.isEverLoggedIn, true);
        Get.offAll(() => RoleSelectionScreen());
      }
    } catch (e) {
      ToastUtil.showToast(e.toString());
      Get.log(e.toString());
    } finally {
      isEmailLoading.value = false;
      Get.back();
    }
  }
}
