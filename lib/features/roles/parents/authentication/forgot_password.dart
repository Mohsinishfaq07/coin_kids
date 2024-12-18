import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_auth_controller/parent_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ParentAuthController _controller = Get.put(ParentAuthController());

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: CustomAppBar(title: "We got you covered ;)"),
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
                      _controller.email.value = value.trim();
                      _controller.checkFields(); // Check fields on change
                    },
                  ) ,
              const SizedBox(height: 25),
              // Forgot Credentials
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We will  sent  password recovery  message to provided email",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),

              // Login Button
              Obx(() => CustomButton(
                    color: _controller.isButtonEnabled.value
                        ? Colors.purple
                        : Colors.grey,
                    text: 'Login',
                    onPressed: () async {
                      await _controller.loginWithEmail();
                    },
                  )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
