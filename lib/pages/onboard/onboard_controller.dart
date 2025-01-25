// onboarding_controller.dart
 import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageIndex = 0.obs;

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

   
}
