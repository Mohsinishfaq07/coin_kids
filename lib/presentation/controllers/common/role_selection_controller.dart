import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/kid_onboarding.dart';
import 'package:coin_kids/presentation/screens/parent/parent_base/parent_base_screen.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();

  void finalizeRole(UserRole role) async {
    await SharedPreferencesHelper.saveString(
        SharedPreferencesHelper.lastLoggedInRole, role.name);

    if (role == UserRole.PARENT) {
      Get.offAll(() => ParentBaseScreen());
    } else if (role == UserRole.CHILD) {
      final isKidOnboarded = await SharedPreferencesHelper.getBool(
              SharedPreferencesHelper.isKidOnboarded) ??
          false;
      final isKidInDb =
          await _kidService.fetchKidsByParentId(_authService.user.value!.uid);
      print("$isKidInDb");
      if (!isKidOnboarded || isKidInDb.isEmpty) {
        Get.offAll(() => KidSectionOnboarding());
      } else {
        Get.offAll(() => KidHomeScreen());
      }
    }
  }
}
