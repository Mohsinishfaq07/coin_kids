import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();
  final roleController = Get.find<RoleController>();
  final analytics = Get.find<AnalyticsService>();


  @override
  void onInit() {
    OrientationUtils.lockToPortrait();
    super.onInit();
  }

  void finalizeRole(UserRole role) async {
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, role.name);

    if (role == UserRole.parent) {
      roleController.switchToParentMode(false);
    } else if (role == UserRole.child) {
      final user = _authService.user.value;
      if (user == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }
      final isKidInDb = await _kidService.fetchKidsByParentId(user.uid);
      Get.log("$isKidInDb");
      if (isKidInDb.isEmpty) {
        roleController.switchToKidOnboarding(true);
      } else {
        roleController.switchToKidMode(true);
      }
    }
  }
}
