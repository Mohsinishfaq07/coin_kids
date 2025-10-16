import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/role_selection_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final _authService = Get.find<AuthService>();
  final analytics = Get.find<AnalyticsService>();
  final roleSelectionController = Get.find<RoleSelectionController>();


  final password = ''.obs;
  final email = ''.obs;

  final showPassword = true.obs;

  final isLoading = false.obs;
  DateTime? _screenStartTime;
  @override
  void onInit() {
    super.onInit();
    _screenStartTime = DateTime.now();
    logScreenTime();
  }

  @override
  void onClose() {
    logScreenTime();
    super.onClose();
  }

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(AnalyticsScreenNames.signIn,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.signIn,
    );
  }

  Future<void> signInWithEmail() async {
    try {
      isLoading.value = true;
      showLoadingDialog("Signing in...");

      // Log sign-in attempt

      // Use AuthService for signup
      final credential = await _authService.signInWithEmailPassword(
        email: email.value,
        password: password.value,
      );

      if (credential.user != null) {
        // Log successful sign-in
        SharedPreferencesHelper.saveBool(SharedPreferencesHelper.isEverLoggedIn, true);
        Get.offAllNamed(Routes.roleSelection);
      }
    } catch (e) {
      // Log sign-in failure
      await analytics.logSignInFailure( e.toString(),"sign_in_screen");
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

      // Log Google sign-in attempt
      await analytics.logGoogleSignInAttempt("sign_in_screen");

      // Use AuthService for signup
      final credential = await _authService.signInWithGoogle();

      if (credential.user != null) {
        // Log successful Google sign-in
        //
        SharedPreferencesHelper.saveBool(SharedPreferencesHelper.isEverLoggedIn, true);
        Get.offAllNamed(Routes.roleSelection);
      }
    } catch (e) {
      // Log Google sign-in failure
      await analytics.logGoogleSignInFailure(e.toString(),"sign_in_screen");
      ToastUtil.showExceptionToast(e);
      Get.log(e.toString());
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }
  // Future<void> signInWithApple() async {
  //   try {
  //     isLoading.value = true;
  //     showLoadingDialog("Signing in...");
  //
  //     final credential = await _authService.signInWithApple();
  //
  //     if (credential.user != null) {
  //       await logScreenTime(); // Log screen time before navigation
  //       SharedPreferencesHelper.saveBool(SharedPreferencesHelper.isEverLoggedIn, true);
  //       // If user already exists, directly finalize role
  //       final bool exists = await _authService.checkUserExists(credential.user!.uid);
  //       if (exists) {
  //         roleSelectionController.finalizeRole(UserRole.child);
  //       } else {
  //         Get.offAllNamed(Routes.roleSelection);
  //       }
  //     }
  //   } catch (e) {
  //     ToastUtil.showExceptionToast(e);
  //     Get.log(e.toString());
  //   } finally {
  //     isLoading.value = false;
  //     Get.back();
  //   }
  // }

}
