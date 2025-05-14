import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _kidService = Get.find<KidService>();
  final _roleController = Get.find<RoleController>();
  final analytics = Get.find<AnalyticsService>();
  DateTime? _screenStartTime;


  @override
  void onInit() {
    _checkLoginStatus();
    _screenStartTime = DateTime.now();
    logScreenTime();
    super.onInit();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 5));

    final user = _authService.user.value;

    if (user == null) {
      final isEverLoggedIn = SharedPreferencesHelper.getBool(SharedPreferencesHelper.isEverLoggedIn) ?? false;
      if (!isEverLoggedIn) {
        Get.offNamed(Routes.intro);
      } else {
        Get.offNamed(Routes.signIn);
      }
    } else {
      // Add validation to check if user exists in database
      try {
        final userExists = await _authService.checkUserExists(user.uid);
        
        if (!userExists) {
          // User doesn't exist in database, sign out and redirect to sign in
          await _authService.signOut();
          Get.log("User not found in database, redirecting to sign in");
          Get.offNamed(Routes.signIn);
          return;
        }
        
        // Continue with normal flow if user exists
        final String role = SharedPreferencesHelper.getString(SharedPreferencesHelper.lastLoggedInRole) ?? UserRole.none.name;

        if (role == UserRole.none.name) {
          Get.offAllNamed(Routes.roleSelection);
        } else if (role == UserRole.parent.name) {
          _roleController.switchToParentMode(false);
        } else {
          try {
            final kids = await _kidService.fetchKidsByParentId(user.uid);

            if (kids.isNotEmpty) {
              _roleController.switchToKidMode(true);
            } else {
              _roleController.switchToKidOnboarding(true);
            }
          } catch (e) {
            Get.log("Error checking kid status: $e");
            // In case of error, default to onboarding
            _roleController.switchToKidOnboarding(true);
          }
        }
      } catch (e) {
        Get.log("Error validating user: $e");
        // In case of validation error, redirect to sign in
        await _authService.signOut();
        Get.offNamed(Routes.signIn);
      }
    }
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
      analytics.screenTime(AnalyticsScreenNames.splash,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.splash,
    );
  }

}
