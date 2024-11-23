import 'package:coin_kids/features/roles/parents/authentication/parent_signup/parent_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import '../parent_auth_controller/parent_auth_controller.dart';

class ParentLoginScreen extends StatelessWidget {
  final ParentAuthController _controller = Get.put(ParentAuthController());

  ParentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Login to Your Account",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Username Input
              CustomTextField(
                hintText: 'Email',
                titleText: 'Email',
                onChanged: (value) => _controller.email.value = value,
              ),
              const SizedBox(height: 20),

              // PIN Input
              CustomTextField(
                hintText: 'Enter 6 digit PIN',
                onChanged: (value) => _controller.pin.value = value,
                titleText: 'Enter PIN',
              ),
              const SizedBox(height: 60),

              // Login Button
              Center(
                child: CustomButton(
                  text: 'Login',
                  onPressed: () {
                    _controller.loginWithEmail();
                  }, // Call the login handler
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        _controller.loginWithGoogle();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Image.asset("assets/googlelogo.png"),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text("Sign in with Google"),
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        _controller.loginWithGoogle();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Image.asset("assets/apple_logo.png"),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text("Sign in with Apple"),
                        ],
                      )),
                ),
              ),

              // CustomButton(
              //   text: 'Login with Google',
              //   onPressed: () {
              //     _controller.loginWithGoogle();
              //   }, // Call the login handler
              // ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        _controller.loginWithGoogle();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Image.asset("assets/apple_logo.png"),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text("Sign in with Apple"),
                        ],
                      )),
                ),
              ),

              // Navigate to Signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account?"),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SignupParentScreen());
                    }, // Navigate to the Signup screen
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
            ],
          ),
        ),
      ),
    );
  }
}
