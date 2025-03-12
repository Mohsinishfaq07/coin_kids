import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/presentation/screens/kid/base/kid_base_screen.dart';
import 'package:coin_kids/presentation/screens/parent/parent_base/parent_base_screen.dart';
import 'package:get/get.dart';

import '../../../core/utils/orientation_utils.dart';

class RoleController extends GetxController {
  void switchToParentMode(bool shouldShowInstruction) async {
    Get.log("orientation is switchToParentMode");
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, UserRole.PARENT.name);

    OrientationUtils.lockToPortrait();
    if (!(Get.currentRoute == '/ParentBaseScreen')) {
      Get.offAll(() => ParentBaseScreen(), arguments: shouldShowInstruction);
    }
  }

  void switchToKidMode(bool shouldShowInstruction) async {
    Get.log("orientation is switchToKidMode");
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, UserRole.CHILD.name);
    OrientationUtils.lockToLandscape();
    if (!(Get.currentRoute == '/KidBaseScreen')) {
      Get.offAll(() => KidBaseScreen(), arguments: shouldShowInstruction);
    }
  }
}
