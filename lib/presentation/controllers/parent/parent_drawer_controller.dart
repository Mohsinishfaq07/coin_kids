import 'dart:io';

import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
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

  var appVersion = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    getAppVersion();
    super.onInit();
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        try {
          await _parentService.updateParentPhoto(File(pickedFile.path));
          ToastUtil.showToast("Uploading Image");
        } catch (e) {
          ToastUtil.showToast("Failed to upload Image: $e");
          print(e);
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
}
