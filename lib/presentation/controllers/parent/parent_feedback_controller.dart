import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/share_utils.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:get/get.dart';

class ParentFeedbackController extends GetxController {
  final RxList<String> feedbackCategories = <String>['Bug Report', 'Feature Request', 'User Experience', 'Performance', 'Content', 'Design', 'Other'].obs;

  final RxList<String> selectedCategories = <String>[].obs;
  final RxString feedbackText = ''.obs;

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  bool isValid() {
    return feedbackText.value.trim().isNotEmpty || selectedCategories.isNotEmpty;
  }

  Future<void> submitFeedback() async {
    if (!isValid()) {
      ToastUtil.showToast(
        'Please provide some feedback',
        color: AppColors.notificationWarning,
      );
      return;
    }

    try {
      String categories = selectedCategories.isEmpty ? '' : '\nCategories: ${selectedCategories.join(", ")}';

      String feedback = feedbackText.value.trim().isEmpty ? '' : '\nFeedback: ${feedbackText.value.trim()}';

      await ShareUtils.sendFeedback(
        additionalText: '$categories$feedback',
      );

      Get.back(); // Return to previous screen after successful submission

      ToastUtil.showToast(
        'Thank you for your feedback!',
      );
    } catch (e) {
      ToastUtil.showToast(
        'Failed to send feedback',
        color: AppColors.notificationWarning,
      );
    }
  }
}
