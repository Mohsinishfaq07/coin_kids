import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/controllers/common/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Recover Password",
        centerTitle: false,
        showBackButton: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Email Input
                CustomTextField(
                  hintText: 'Email',
                  titleText: 'Email',
                  onChanged: (value) {
                    controller.email.value = value.trim();
                  },
                ),
                const SizedBox(height: 25),
                // Forgot Credentials
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    textAlign: TextAlign.center,
                    "We will  sent  password recovery  message to provided email",
                    style: AppTextStyle.bodySmall,
                  ),
                ),
                const SizedBox(height: 40),

                // Login Button
                AppButton(
                  text: 'Send',
                  onPressed: () async {
                    if (controller.email.value.isNotEmpty && controller.email.value.contains('@')) {
                      await controller.authService.resetPassword(controller.email.value);
                      ToastUtil.showToast("Email sent");
                      Get.back();
                    } else {
                      ToastUtil.showToast('Check your email');
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
