import 'dart:io';

import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ParentDrawerController extends GetxController {
  final authService = Get.find<AuthService>();
  final appState = Get.find<AppStateController>();
  final _parentService = Get.find<ParentService>();

  var goalAchievementSwitch = true.obs;
  var moneyRequestSwitch = true.obs;
  // final goalAchievementSwitch = false.obs;
  // final moneyRequestSwitch = false.obs;

  var appVersion = ''.obs;
  //final appVersion = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    getAppVersion();
    super.onInit();
  }
  //@override
  //   void onInit() async {
  //     super.onInit();
  //     await _loadNotificationPreferences();
  //     await getAppVersion();
  //   }
  //
  //   Future<void> _loadNotificationPreferences() async {
  //     final goalAchievement = await SharedPreferencesHelper.getBool(
  //         SharedPreferencesHelper.goalAchievementNotificationEnabled);
  //     final moneyRequest = await SharedPreferencesHelper.getBool(
  //         SharedPreferencesHelper.moneyRequestNotificationEnabled);
  //
  //     goalAchievementSwitch.value = goalAchievement ?? true;
  //     moneyRequestSwitch.value = moneyRequest ?? true;
  //   }
  //
  //   Future<void> toggleGoalAchievement(bool value) async {
  //     goalAchievementSwitch.value = value;
  //     await SharedPreferencesHelper.saveBool(
  //         SharedPreferencesHelper.goalAchievementNotificationEnabled, value);
  //   }
  //
  //   Future<void> toggleMoneyRequest(bool value) async {
  //     moneyRequestSwitch.value = value;
  //     await SharedPreferencesHelper.saveBool(
  //         SharedPreferencesHelper.moneyRequestNotificationEnabled, value);
  //   }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        try {
          ToastUtil.showToast("Uploading Image");
          await _parentService.updateParentPhoto(File(pickedFile.path));
        } catch (e) {
          ToastUtil.showToast("Failed to upload Image: $e");
          Get.log(e.toString(), isError: true);
        }
      }
    } catch (e) {
      ToastUtil.showToast("Failed to pick image: $e");
    }
  }

  void getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }
  //  Future<void> getAppVersion() async {
//     final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     appVersion.value = packageInfo.version;
//   }
}
