// onboarding_controller.dart
import 'package:coin_kids/pages/roles/role_selection_screen.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageIndex = 0.obs;

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  void navigateToRoleSelection() {
    Get.off(() => const RoleSelectionScreen());
  }
}
