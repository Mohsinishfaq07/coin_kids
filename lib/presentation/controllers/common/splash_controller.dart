import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/screens/common/intro/intro_screen.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/kid_onboarding.dart';
import 'package:coin_kids/presentation/screens/parent/bottom_navigation/parent_base_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _kidService = Get.find<KidService>();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = _authService.user.value;

    if (user == null) {
      final isEverLoggedIn = await SharedPreferencesHelper.getBool(
              SharedPreferencesHelper.isEverLoggedIn) ??
          false;
      if (isEverLoggedIn) {
        Get.off(() => LoginScreen());
      } else {
        Get.off(() => IntroScreen());
      }
    } else {
      final String role = await SharedPreferencesHelper.getString(
              SharedPreferencesHelper.lastLoggedInRole) ??
          UserRole.NONE.name;

      if (role == UserRole.NONE.name) {
        Get.off(() => RoleSelectionScreen());
      } else if (role == UserRole.PARENT.name) {
        Get.off(() => ParentBaseScreen());
      } else {
        try {
          // First check if there are any kids associated with this parent
          final kids = await _kidService.fetchKidsByParentId(user.uid);

          if (kids.isNotEmpty) {
            // If kids exist, go to home screen
            Get.offAll(() => KidHomeScreen());
          } else {
            // If no kids exist, check onboarding status
            final isKidOnboarded = await SharedPreferencesHelper.getBool(
                    SharedPreferencesHelper.isKidOnboarded) ??
                false;
            if (!isKidOnboarded) {
              Get.offAll(() => KidSectionOnboarding());
            } else {
              // Even if onboarded but no kids in DB, go to onboarding
              Get.offAll(() => KidSectionOnboarding());
            }
          }
        } catch (e) {
          print("Error checking kid status: $e");
          // In case of error, default to onboarding
          Get.offAll(() => KidSectionOnboarding());
        }
      }
    }
  }
}
