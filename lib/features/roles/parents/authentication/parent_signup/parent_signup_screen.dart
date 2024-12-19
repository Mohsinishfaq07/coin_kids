import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../parent_auth_controller/parent_auth_controller.dart';

class SignupParentScreen extends StatelessWidget {
  final ParentAuthController _controller = Get.put(ParentAuthController());
  final _formKey = GlobalKey<FormState>();

  SignupParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Lets's Get Start!",
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
                    _controller.username.value = value.trim();
                    _controller.checkFields(); // Check fields on change
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
                    _controller.email.value = value.trim();
                    _controller.checkFields(); // Check fields on change
                  },
                  titleText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    // if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                    //     .hasMatch(value)) {
                    //   return "Enter a valid email";
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // PIN Input
                CustomTextField(
                  hintText: 'Password',
                  onChanged: (value) {
                    _controller.pin.value = value.trim();
                    _controller.checkFields(); // Check fields on change
                  },
                  titleText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                    hintText: 'Confirm Password',
                    onChanged: (value) {
                      _controller.confirmPin.value = value.trim();
                      _controller.checkFields(); // Check fields on change
                    },
                    titleText: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "COnfirm Password is required";
                      }
                    }),

                const SizedBox(height: 30),
                Obx(() => Center(
                      child: CustomButton(
                        color: _controller.isButtonEnabled.value
                            ? Colors.purple
                            : Colors.grey,
                        text: 'Signup',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Form is valid
                            _controller.signUpWithEmail();
                            Get.off(() => BottomNavigationBarScreen());
                          } else {
                            print("Form has errors");
                          }
                          // Call signup method
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
                    _controller.loginWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 10),
                        child: Image.asset("assets/googlelogo.png", height: 24),
                      ),
                      Text(
                        "Sign in with Google",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: CustomThemeData().whiteColorText,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
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
                    //_controller.loginWithApple();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Image.asset("assets/apple_logo.png", height: 24),
                      ),
                      Text(
                        "Sign in with Apple",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: CustomThemeData().whiteColorText,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
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
