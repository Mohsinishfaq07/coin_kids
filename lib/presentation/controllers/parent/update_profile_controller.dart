import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../dialogs/common/loading_dialog.dart';

class UpdateProfileController extends GetxController {
  final AppStateController appState = Get.find();
  final ParentService parentService = Get.find();

  final RxString parentName = ''.obs;
  final Rxn<DateTime> birthday = Rxn<DateTime>();
  final RxString selectedGender = ''.obs;
  final  analytics = Get.find<AnalyticsService>();


  final isLoading = false.obs;


  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  bool validateForm() {
    // Name validation
    if (parentName.value.isNotEmpty) {
      if (parentName.value.length < 2) {
        ToastUtil.showToast(
          'Name must be at least 2 characters long',
          color: AppColors.notificationWarning,
        );
        return false;
      }
      if (parentName.value.length > 50) {
        ToastUtil.showToast(
          'Name must be less than 50 characters',
          color: AppColors.notificationWarning,
        );
        return false;
      }
      // Check for valid characters in name
      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(parentName.value)) {
        ToastUtil.showToast(
          'Name can only contain letters and spaces',
          color: AppColors.notificationWarning,
        );
        return false;
      }
    }

    // Birthday validation
    if (birthday.value != null) {
      final now = DateTime.now();
      final age = now.difference(birthday.value!).inDays / 365;

      if (age < 18) {
        ToastUtil.showToast(
          'You must be at least 18 years old',
          color: AppColors.notificationWarning,
        );
        return false;
      }

      if (age > 100) {
        ToastUtil.showToast(
          'Please enter a valid birth date',
          color: AppColors.notificationWarning,
        );
        return false;
      }
    }

    // Gender validation
    if (selectedGender.value.isEmpty) {
      ToastUtil.showToast(
        'Please select a gender',
        color: AppColors.notificationWarning,
      );
      return false;
    }

    // Check if any changes were made
    final currentParent = appState.currentParent.value!;
    final noChanges = (parentName.value.isEmpty || parentName.value == currentParent.name) &&
        (birthday.value == null || birthday.value!.millisecondsSinceEpoch == currentParent.dob) &&
        selectedGender.value == currentParent.gender;

    if (noChanges) {
      ToastUtil.showToast(
        'No changes were made',
        color: AppColors.notificationWarning,
      );
      return false;
    }

    return true;
  }

  Future<bool> updateProfile() async {
    if (!validateForm()) return false;

    try {
      showLoadingDialog('Updating Profile...');

      final currentParent = appState.currentParent.value!;
      final parentModel = currentParent.copyWith(
        dob: birthday.value == null ? currentParent.dob : birthday.value!.millisecondsSinceEpoch,
        name: parentName.value.isEmpty ? currentParent.name : parentName.value,
        gender: selectedGender.value,
      );

      await parentService.updateParent(parentModel);
      Get.back(); // Close loading dialog
      Get.back(); // Navigate back

      ToastUtil.showToast('Profile updated successfully');
      return true;
    } catch (e) {
      Get.back(); // Close loading dialog
      ToastUtil.showToast(
        'Failed to update profile',
        color: AppColors.notificationWarning,
      );
      return false;
    }
  }
}
