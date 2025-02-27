import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final _authService = Get.find<AuthService>();

  final name = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final email = ''.obs;

  final showPassword = true.obs;

  final isEmailLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isAppleLoading = false.obs;

  Future<void> signUpWithEmail() async {
    try {
      isEmailLoading.value = true;
      showLoadingDialog("Signing up...");

      // Use AuthService for signup
      final credential = await _authService.signUpWithEmailPassword(
        email: email.value,
        password: password.value,
        name: name.value,
        gender: UserGender.None.name,
      );

      if (credential.user != null) {
        SharedPreferencesHelper.saveBool(SharedPreferencesHelper.isEverLoggedIn, true);
        Get.offAll(() => RoleSelectionScreen());
      }
    } catch (e) {
      ToastUtil.showExceptionToast(e);
      Get.log(e.toString());
    } finally {
      isEmailLoading.value = false;
      Get.back();
    }
  }
}
