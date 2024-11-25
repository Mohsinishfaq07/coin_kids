import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../parent_auth_controller/parent_auth_controller.dart';

class SignupParentScreen extends StatelessWidget {
  final ParentAuthController _controller = Get.put(ParentAuthController());

  SignupParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: "Lets's Get Start!"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Full Name',
                onChanged: (value) {
                  _controller.username.value =  value.trim();
                  _controller.checkFields(); // Check fields on change
                },
                titleText: 'Full Name',
              ),
              // email

              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Email',
                onChanged: (value) {
                  _controller.email.value =  value.trim();
                  _controller.checkFields(); // Check fields on change
                },
                titleText: 'Email',
              ),
              const SizedBox(height: 20),

              // PIN Input
              CustomTextField(
                hintText: 'Password',
                onChanged: (value) {
                  _controller.pin.value =  value.trim();
                  _controller.checkFields(); // Check fields on change
                },
                titleText: 'Password',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Confirm Password',
                onChanged: (value) {
                  _controller.confirmPin.value =  value.trim();
                  _controller.checkFields(); // Check fields on change
                },
                titleText: 'Confirm Password',
              ),

              // Gender Selection
              // const Text(
              //   "Gender (Optional)",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 14,
              //     color: Color.fromARGB(255, 9, 90, 156),
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Obx(() => Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         GestureDetector(
              //           onTap: () => _controller.selectGender("Female"),
              //           child: Container(
              //             width: 160,
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 16, horizontal: 32),
              //             decoration: BoxDecoration(
              //               color: _controller.selectedGender.value == "Female"
              //                   ? Colors.amber
              //                   : Colors.white,
              //               border: Border.all(color: Colors.grey),
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Icon(
              //               Icons.female,
              //               color: _controller.selectedGender.value == "Female"
              //                   ? Colors.white
              //                   : Colors.black54,
              //             ),
              //           ),
              //         ),
              //         GestureDetector(
              //           onTap: () => _controller.selectGender("Male"),
              //           child: Container(
              //             width: 160,
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 16, horizontal: 32),
              //             decoration: BoxDecoration(
              //               color: _controller.selectedGender.value == "Male"
              //                   ? Colors.purple
              //                   : Colors.white,
              //               border: Border.all(color: Colors.grey),
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Icon(
              //               Icons.male,
              //               color: _controller.selectedGender.value == "Male"
              //                   ? Colors.white
              //                   : Colors.black54,
              //             ),
              //           ),
              //         ),
              //       ],
              //     )),
              const SizedBox(height: 30),
              Obx(() => Center(
                    child: CustomButton(
                      color: _controller.isButtonEnabled.value
                          ? Colors.purple
                          : Colors.grey,
                      text: 'Signup',
                      onPressed: () {
                        _controller.signUpWithEmail(); // Call signup method
                      },
                    ),
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account,"),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ParentLoginScreen());
                    },
                    child: const Text(
                      " LOGIN",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
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

              const SizedBox(height: 40),

              // Terms and Signup Button
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "By clicking Sign Up, you are agreeing to the ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: "Terms of services & Privacy Policy.",
                      style: TextStyle(
                        color: Colors.black54,
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
    );
  }
}
