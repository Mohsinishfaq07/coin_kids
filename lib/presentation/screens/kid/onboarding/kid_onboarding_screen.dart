import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_exit_dialog.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/age_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/avatar_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/name_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidOnboardingScreen extends GetView<KidOnboardingController> {
  const KidOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (controller.currentStep.value == OnboardingStep.name) {
            bool shouldExit = await KidExitDialog.show(context);
            if (shouldExit) SystemNavigator.pop();
          } else {
            controller.goBack();
          }
        }
      },
      child: Obx(() {
        switch (controller.currentStep.value) {
          case OnboardingStep.name:
            return const KidNameScreen();
          case OnboardingStep.age:
            return const KidAgeScreen();
          case OnboardingStep.avatar:
            return const KidAvatarScreen();
        }
      }),
    );
  }
}

