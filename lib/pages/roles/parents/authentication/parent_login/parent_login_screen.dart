import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/dialogues/custom_dialogues.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/pages/roles/parents/authentication/forgot_password.dart';
import 'package:coin_kids/pages/roles/parents/authentication/parent_signup/parent_signup_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';

class ParentLoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ParentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Welcome Back!",
        centerTitle: false,
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // PIN Input
                CustomTextField(
                  hintText: 'Password',
                  onChanged: (value) {
                    firebaseAuthController.pin.value = value.trim();
                    firebaseAuthController
                        .checkFields(); // Check fields on change
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                  },
                  titleText: 'Password',
                ),
                const SizedBox(height: 10),

                // Forgot Credentials
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => ForgotPasswordScreen());
                    },
                    child: Text(
                      "Forgot Credentials?",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: CustomThemeData().primaryTextColor,
                          fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Login Button
                Obx(() => CustomButton(
                      color: firebaseAuthController.isButtonEnabled.value
                          ? CustomThemeData().primaryButtonColor
                          : Colors.grey,
                      text: 'Login',
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await firebaseAuthController.loginWithEmail();

                          // Form is valid
                        } else {
                          Get.log("Form has errors");
                        }
                      },
                      isLoading: false,
                    )),
             

                const SizedBox(height: 40),

                // Signup Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: CustomThemeData().primaryTextColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignupParentScreen());
                      },
                      child: Text("SignUp",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: CustomThemeData().primaryButtonColor,
                                    fontWeight: FontWeight.w800,
                                  )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Text("OR",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: CustomThemeData().disabledIconColor,
                            fontWeight: FontWeight.w800,
                          )),
                ),

                // Google Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(screenWidth * 0.8, 50), // Responsive width
                  ),
                  onPressed: () async {
                    await firebaseAuthController.loginWithGoogle();
                  },
                  child: Obx(() {
                    return firebaseAuthController.isGoogleLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 30.0, left: 10),
                                child: Image.asset("assets/googlelogo.png",
                                    height: 24),
                              ),
                              Text(
                                "Sign in with Google",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: CustomThemeData().whiteColorText,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          );
                  }),
                ),
                const SizedBox(height: 20),

                // Apple Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(screenWidth * 0.8, 50), // Responsive width
                  ),
                  onPressed: () {
                    //firebaseAuthController.loginWithApple();
                    firebaseAuthController.signinWithApple();
                  },
                  child: Obx(
                    () {
                      return firebaseAuthController.isAppleLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Image.asset("assets/apple_logo.png",
                                      height: 24),
                                ),
                                Text(
                                  "Sign in with Apple",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: CustomThemeData().whiteColorText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
