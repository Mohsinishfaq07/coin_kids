import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';

import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

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
                  firebaseAuthController.email.value = value.trim();
                  firebaseAuthController
                      .checkFields(); // Check fields on change
                },
              ),
              const SizedBox(height: 25),
              // Forgot Credentials
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We will  sent  password recovery  message to provided email",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: CustomThemeData().primaryTextColor),
                ),
              ),
              const SizedBox(height: 40),

              // Login Button
              CustomButton(
                color: Colors.purple,
                text: 'Send',
                onPressed: () async {
                  //  await firebaseAuthController.sendPasswordResetEmail();
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
