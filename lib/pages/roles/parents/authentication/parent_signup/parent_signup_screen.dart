import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/pages/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupParentScreen extends StatelessWidget {
  SignupParentScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Lets's Get Start!",
        showBackButton: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hintText: 'Full Name',
                  onChanged: (value) {
                    firebaseAuthController.username.value = value.trim();
                    firebaseAuthController
                        .signUpCheckField(); // Check fields on change
                  },
                  titleText: 'Full Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Full Name is required";
                    }
                  },
                ),
                // email

                const SizedBox(height: 14),
                CustomTextField(
                  hintText: 'Email',
                  onChanged: (value) {
                    firebaseAuthController.email.value = value.trim();
                    firebaseAuthController
                        .signUpCheckField(); // Check fields on change
                  },
                  titleText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    // Validate email format
                    if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // PIN Input
                CustomTextField(
                  hintText: 'Password',
                  onChanged: (value) {
                    firebaseAuthController.pin.value = value.trim();
                    firebaseAuthController
                        .signUpCheckField(); // Check fields on change
                  },
                  titleText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                    hintText: 'Confirm Password',
                    onChanged: (value) {
                      firebaseAuthController.confirmPin.value = value.trim();
                      firebaseAuthController
                          .signUpCheckField(); // Check fields on change
                    },
                    titleText: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm Password is required";
                      }
                      if (value != firebaseAuthController.pin.value) {
                        return "Passwords do not match";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    }),

                const SizedBox(height: 30),
                Obx(() => Center(
                      child: CustomButton(
                        color: firebaseAuthController.isButtonEnabled.value
                            ? Colors.purple
                            : Colors.grey,
                        text: 'Signup',
                        isLoading: firebaseAuthController.isEmailLoading.value,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // If the form is valid, proceed with the signup action
                            try {
                              firebaseAuthController.signUpWithEmail();
                            } catch (e) {
                              print("Error: $e");
                            }
                          } else {
                            // If the form is not valid, show error messages
                            print("Form validation failed");
                          }
                        },
                      ),
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: CustomThemeData().primaryTextColor),
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => ParentLoginScreen());
                        },
                        child: Text("LOGIN",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: CustomThemeData().primaryButtonColor,
                                    fontWeight: FontWeight.w800))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22.0),
                  child: Text("OR",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.w800)),
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // If the form is valid, proceed with the signup action
                      try {
                        firebaseAuthController.signUpWithEmail();
                      } catch (e) {
                        print("Error: $e");
                      }
                    } else {
                      // If the form is not valid, show error messages
                      print("Form validation failed");
                    }
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

                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                // Terms and Signup Button
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By clicking Sign Up, you are agreeing to the ",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: "Terms of services & Privacy Policy.",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
