import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/firebase/firebase_authentication/authentication_controller.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_button.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final authController = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "We got you covered ;)",
        centerTitle: false,
        showBackButton: true,
      ),
      body: Padding(
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
                  authController.email.value = value.trim();
                  authController.checkFields(); // Check fields on change
                },
              ),
              const SizedBox(height: 25),
              // Forgot Credentials
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We will  sent  password recovery  message to provided email",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor),
                ),
              ),
              const SizedBox(height: 40),

              // Login Button
              CustomButton(
                color: Colors.purple,
                text: 'Send',
                onPressed: () async {
                  if (authController.email.value.isNotEmpty && authController.email.value.contains('@')) {
                    // await authController
                    //     .resetPassword(authController.email.value);
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
    );
  }
}
