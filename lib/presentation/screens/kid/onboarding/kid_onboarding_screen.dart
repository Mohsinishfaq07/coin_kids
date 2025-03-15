import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/age_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/avatar_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/name_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KidOnboardingScreen extends GetView<KidOnboardingController> {
  const KidOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.currentStep.value) {
        case OnboardingStep.name:
          return const KidNameScreen();
        case OnboardingStep.age:
          return const KidAgeScreen();
        case OnboardingStep.avatar:
          return const KidAvatarScreen();
      }
    });
  }
}
