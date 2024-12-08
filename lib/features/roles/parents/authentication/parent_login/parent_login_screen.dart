import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/roles/parents/authentication/forgot_password.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_signup/parent_signup_screen.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import '../parent_auth_controller/parent_auth_controller.dart';

class ParentLoginScreen extends StatelessWidget {
  final ParentAuthController _controller = Get.put(ParentAuthController());
  final _formKey = GlobalKey<FormState>();

  ParentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Welcome Back!",
        centerTitle: false,
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
                    _controller.email.value = value.trim();
                    _controller.checkFields(); // Check fields on change
                  },
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
                const SizedBox(height: 25),

                // PIN Input
                CustomTextField(
                  hintText: 'Enter 6 digit PIN',
                  onChanged: (value) {
                    _controller.pin.value = value.trim();
                    _controller.checkFields(); // Check fields on change
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
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
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
                        if (_formKey.currentState?.validate() ?? false) {
                          await _controller.loginWithEmail();
                          Get.off(() => BottomNavigationBarScreen());
                          // Form is valid
                        } else {
                          print("Form has errors");
                        }
                      },
                    )),
                const SizedBox(height: 40),

                // Signup Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account?"),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignupParentScreen());
                      },
                      child: const Text(
                        " SIGN UP",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Text(
                    "OR",
                    style: TextStyle(color: Colors.purple, fontSize: 14),
                  ),
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
                      const Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.white),
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
                      const Text(
                        "Sign in with Apple",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
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
