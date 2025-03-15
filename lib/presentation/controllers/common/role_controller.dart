import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/orientation_utils.dart';

class RoleController extends GetxController {
  Rx<Orientation> currentOrientation = Orientation.portrait.obs;

  void updateOrientation(Orientation newOrientation) {
    if (currentOrientation.value != newOrientation) {
      currentOrientation.value = newOrientation;
    }
  }

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
    updateOrientation(Orientation.portrait);

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
    // OrientationUtils.lockToLandscape();
    updateOrientation(Orientation.landscape);
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
    // OrientationUtils.lockToLandscape();
    updateOrientation(Orientation.landscape);
    if (!(Get.currentRoute == Routes.kidOnboarding)) {
      Get.offAllNamed(Routes.kidOnboarding, arguments: shouldShowInstruction);
    }
  }
}
