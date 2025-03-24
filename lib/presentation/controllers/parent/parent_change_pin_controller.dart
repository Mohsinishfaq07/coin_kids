import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:get/get.dart';

class ParentChangePinController extends GetxController {
  final AppStateController appState = Get.find();
  final ParentService parentService = Get.find();

  final RxString currentPin = ''.obs;
  final RxString newPin = ''.obs;
  final RxString confirmPin = ''.obs;
  final RxBool isFirstTime = false.obs;

  // PIN visibility states
  final RxBool currentPinVisible = false.obs;
  final RxBool newPinVisible = false.obs;
  final RxBool confirmPinVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if it's first time PIN setup
    isFirstTime.value = appState.currentParent.value?.pin == null;
  }

  void toggleCurrentPinVisibility() => currentPinVisible.value = !currentPinVisible.value;

  void toggleNewPinVisibility() => newPinVisible.value = !newPinVisible.value;

  void toggleConfirmPinVisibility() => confirmPinVisible.value = !confirmPinVisible.value;

  String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (value.length != 4) {
      return 'PIN must be 4 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'PIN can only contain numbers';
    }
    return null;
  }

  bool validateForm() {
    // If not first time, validate current PIN
    if (!isFirstTime.value) {
      if (currentPin.value.isEmpty) {
        ToastUtil.showToast(
          'Please enter current PIN',
          color: AppColors.notificationWarning,
        );
        return false;
      }

      if (currentPin.value.length != 4) {
        ToastUtil.showToast(
          'Current PIN must be 4 digits',
          color: AppColors.notificationWarning,
        );
        return false;
      }

      if (currentPin.value != appState.currentParent.value?.pin) {
        ToastUtil.showToast(
          'Current PIN is incorrect',
          color: AppColors.notificationWarning,
        );
        return false;
      }
    }

    // Validate new PIN
    if (newPin.value.isEmpty) {
      ToastUtil.showToast(
        'Please enter new PIN',
        color: AppColors.notificationWarning,
      );
      return false;
    }

    if (newPin.value.length != 4) {
      ToastUtil.showToast(
        'PIN must be 4 digits',
        color: AppColors.notificationWarning,
      );
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(newPin.value)) {
      ToastUtil.showToast(
        'PIN can only contain numbers',
        color: AppColors.notificationWarning,
      );
      return false;
    }

    // Validate confirm PIN
    if (confirmPin.value != newPin.value) {
      ToastUtil.showToast(
        'PINs do not match',
        color: AppColors.notificationWarning,
      );
      return false;
    }

    return true;
  }

  Future<bool> updatePin() async {
    if (!validateForm()) return false;

    try {
      showLoadingDialog('Updating PIN...');

      final currentParent = appState.currentParent.value!;
      final parentModel = currentParent.copyWith(
        pin: newPin.value,
      );

      await parentService.updateParent(parentModel);
      Get.back(); // Close loading dialog
      Get.back(); // Navigate back

      ToastUtil.showToast('PIN updated successfully');
      return true;
    } catch (e) {
      Get.back(); // Close loading dialog
      ToastUtil.showToast(
        'Failed to update PIN',
        color: AppColors.notificationWarning,
      );
      return false;
    }
  }
}
