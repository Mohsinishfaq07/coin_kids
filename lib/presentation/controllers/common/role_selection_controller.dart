import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();
  final roleController = Get.find<RoleController>();
  final analytics = Get.find<AnalyticsService>();
  DateTime? _screenStartTime;

  @override
  void onInit() {
    OrientationUtils.lockToPortrait();
    _screenStartTime = DateTime.now();
    logScreenTime();
    super.onInit();
  }

  void finalizeRole(UserRole role) async {
    await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, role.name);

    if (role == UserRole.parent) {
      roleController.switchToParentMode(false);
      await analytics.logRoleSelected(AnalyticsParameterNames.roleParent, AnalyticsScreenNames.roleSelection ,AnalyticsScreenNames.parentHome );

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
        await analytics.logRoleSelected(AnalyticsParameterNames.roleChild, AnalyticsScreenNames.roleSelection ,AnalyticsScreenNames.kidOnboardingNameScreen );

        roleController.switchToKidOnboarding(true);
      } else {
        await analytics.logRoleSelected(AnalyticsParameterNames.roleChild, AnalyticsScreenNames.roleSelection ,AnalyticsScreenNames.kidBaseScreen );

        roleController.switchToKidMode(true);
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
      analytics.screenTime(AnalyticsScreenNames.roleSelection, durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.roleSelection,
    );
  }
}
