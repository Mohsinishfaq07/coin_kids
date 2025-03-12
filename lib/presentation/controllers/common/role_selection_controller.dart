import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/screens/kid/base/kid_base_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/kid_onboarding_screen.dart';
import 'package:coin_kids/presentation/screens/parent/parent_base/parent_base_screen.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();

  void finalizeRole(UserRole role) async {
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, role.name);

    if (role == UserRole.PARENT) {
      OrientationUtils.lockToLandscape();
      if (!(Get.currentRoute == '/ParentBaseScreen')) {
        Get.offAll(() => ParentBaseScreen());
      }
    } else if (role == UserRole.CHILD) {
      final user = _authService.user.value;
      if (user == null) {
        ToastUtil.showToast("User not authenticated");
        return;
      }
      final isKidOnboarded = await SharedPreferencesHelper.getBool(SharedPreferencesHelper.isKidOnboarded) ?? false;
      final isKidInDb = await _kidService.fetchKidsByParentId(user.uid);
      print("$isKidInDb");
      if (!isKidOnboarded && isKidInDb.isEmpty) {
        OrientationUtils.lockToLandscape();
        if (!(Get.currentRoute == '/KidOnboardingScreen')) {
          Get.offAll(() => KidOnboardingScreen());
        }
      } else {
        if (!(Get.currentRoute == '/KidBaseScreen')) {
          Get.offAll(() => KidBaseScreen(), arguments: true);
        }
      }
    }
  }
}
