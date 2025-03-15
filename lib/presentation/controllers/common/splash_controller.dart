import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _kidService = Get.find<KidService>();
  final _roleController = Get.find<RoleController>();

  @override
  void onInit() {
    _checkLoginStatus();

    // OrientationUtils.lockToPortrait();

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
      final String role = SharedPreferencesHelper.getString(SharedPreferencesHelper.lastLoggedInRole) ?? UserRole.none.name;

      if (role == UserRole.none.name) {
        Get.offAllNamed(Routes.roleSelection);
      } else if (role == UserRole.parent.name) {
        _roleController.switchToParentMode(false);
      } else {
        try {
          final kids = await _kidService.fetchKidsByParentId(user.uid);

          if (kids.isNotEmpty) {
            // Get.to(() => OrientationTransitionScreen(
            //   nextScreen: Routes.kidBase,
            //   targetOrientation: DeviceOrientation.landscapeLeft,
            // ));

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
    }
  }
}
