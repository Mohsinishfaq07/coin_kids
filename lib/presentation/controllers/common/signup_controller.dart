import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final _authService = Get.find<AuthService>();
  final analytics = Get.find<AnalyticsService>();

  final name = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final email = ''.obs;

  final showPassword = true.obs;

  final isLoading = false.obs;

  Future<void> signUpWithEmail() async {
    try {
      isLoading.value = true;
      showLoadingDialog("Signing up...");

      // Use AuthService for signup
      final credential = await _authService.signUpWithEmailPassword(
        email: email.value,
        password: password.value,
        name: name.value,
        gender: UserGender.none.name,
      );

      if (credential.user != null) {
        SharedPreferencesHelper.saveBool(SharedPreferencesHelper.isEverLoggedIn, true);
        Get.offAllNamed(Routes.roleSelection);
      }
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.log(e.toString());
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      showLoadingDialog("Signing in...");

      // Use AuthService for signup
      final credential = await _authService.signInWithGoogle();

      if (credential.user != null) {
        SharedPreferencesHelper.saveBool(SharedPreferencesHelper.isEverLoggedIn, true);
        Get.offAllNamed(Routes.roleSelection);
      }
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.log(e.toString());
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }
}
