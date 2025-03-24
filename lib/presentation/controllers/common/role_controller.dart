import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:get/get.dart';


class RoleController extends GetxController {
  // Add a debounce mechanism
  DateTime? _lastSwitchTime;
  final _debounceTime = Duration(seconds: 5); // Prevent multiple calls within 2 seconds

  bool get _canSwitch {
    if (_lastSwitchTime == null) return true;
    return DateTime.now().difference(_lastSwitchTime!) > _debounceTime;
  }

  void switchToParentMode(bool shouldShowInstruction) async {
    if (!_canSwitch) {
      Get.log("RoleController: Ignoring duplicate switchToParentMode call");
      return;
    }

    _lastSwitchTime = DateTime.now();
    Get.log("RoleController switchToParentMode");
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, UserRole.parent.name);

    OrientationUtils.lockToPortrait();

    if (!(Get.currentRoute == Routes.parentBase)) {
      Get.offAllNamed(Routes.parentBase, arguments: shouldShowInstruction);
    }
  }

  void switchToKidMode(bool shouldShowInstruction) async {
    if (!_canSwitch) {
      Get.log("RoleController: Ignoring duplicate switchToKidMode call");
      return;
    }

    _lastSwitchTime = DateTime.now();
    Get.log("RoleController is switchToKidMode");
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, UserRole.child.name);
    OrientationUtils.lockToLandscape();
    if (!(Get.currentRoute == Routes.kidBase)) {
      Get.offAllNamed(Routes.kidBase, arguments: shouldShowInstruction);
    }
  }

  void switchToKidOnboarding(bool shouldShowInstruction) async {
    if (!_canSwitch) {
      Get.log("RoleController: Ignoring duplicate switchToKidOnboarding call");
      return;
    }

    _lastSwitchTime = DateTime.now();
    Get.log("RoleController is switchToKidMode");
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, UserRole.child.name);
    OrientationUtils.lockToLandscape();
    if (!(Get.currentRoute == Routes.kidOnboarding)) {
      Get.offAllNamed(Routes.kidOnboarding, arguments: shouldShowInstruction);
    }
  }
}
