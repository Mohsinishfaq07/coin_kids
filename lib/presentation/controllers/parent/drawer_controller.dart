import 'dart:io';

import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ParentDrawerController extends GetxController {
  final authService = Get.find<AuthService>();
  final appState = Get.find<AppStateController>();
  final _parentService = Get.find<ParentService>();

  var goalAchievementSwitch = true.obs;
  var moneyRequestSwitch = true.obs;

  final ImagePicker _picker = ImagePicker();

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
}
