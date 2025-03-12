import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/screens/common/intro/intro_screen.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/sign_in_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/kid_onboarding_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _kidService = Get.find<KidService>();
  final _roleController = Get.find<RoleController>();

  @override
  void onInit() {
    _checkLoginStatus();

    super.onInit();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 5));

    final user = _authService.user.value;

    if (user == null) {
      final isEverLoggedIn = await SharedPreferencesHelper.getBool(SharedPreferencesHelper.isEverLoggedIn) ?? false;
      if (!isEverLoggedIn) {
        Get.off(() => IntroScreen());
      } else {
        Get.off(() => SignInScreen());
      }
    } else {
      final String role = await SharedPreferencesHelper.getString(SharedPreferencesHelper.lastLoggedInRole) ?? UserRole.NONE.name;

      if (role == UserRole.NONE.name) {
        Get.off(() => RoleSelectionScreen());
      } else if (role == UserRole.PARENT.name) {
        _roleController.switchToParentMode(false);
      } else {
        try {
          // First check if there are any kids associated with this parent
          final kids = await _kidService.fetchKidsByParentId(user.uid);

          if (kids.isNotEmpty) {
            _roleController.switchToKidMode(true);
          } else {
            // If no kids exist, check onboarding status
            final isKidOnboarded = await SharedPreferencesHelper.getBool(SharedPreferencesHelper.isKidOnboarded) ?? false;
            if (!isKidOnboarded) {
              Get.offAll(() => ());
            } else {
              // Even if onboarded but no kids in DB, go to onboarding
              OrientationUtils.lockToLandscape();
              Get.offAll(() => KidOnboardingScreen());
            }
          }
        } catch (e) {
          print("Error checking kid status: $e");
          // In case of error, default to onboarding
          OrientationUtils.lockToLandscape();
          Get.offAll(() => KidOnboardingScreen());
        }
      }
    }
  }
}
