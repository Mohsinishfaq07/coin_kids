import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/base/kid_onboarding_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KidNameScreen extends GetView<KidOnboardingController> {
  const KidNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KidOnboardingBaseScreen(
      showBackButton: false,
      title: 'Welcome to CoinKids!',
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use constraints to make layout responsive in landscape
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: maxWidth * 0.04, // 10% padding on sides
              vertical: maxHeight * 0.05, // 5% padding top/bottom
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "What's your name?",
                  style: AppTextStyle.headingMedium,
                ),
                SizedBox(height: maxHeight * 0.05),
                SizedBox(
                  width: maxWidth * 0.4, // 40% of screen width
                  child: KidTextField(
                    maxlength: 10,
                    hintText: "Enter your name",
                    onChange: (value) {
                      controller.setName(value);
                    },
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: KidButton(
                    onTap: () {
                      controller.proceedToAge();
                    },
                    text: 'Next',
                    baseColor: AppColors.btnColorGreen,
                    iconPath: Assets.icEmailSent,
                    iconPosition: IconPosition.right,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
