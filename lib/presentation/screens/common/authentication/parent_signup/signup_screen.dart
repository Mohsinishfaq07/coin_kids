import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';

import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/screens/common/authentication/login/login_screen.dart';
import 'package:coin_kids/presentation/screens/common/authentication/parent_signup/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';



class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar:  CustomAppBar(
          backgroundColor: Color(0xFFCAF0FF),
          title: "Let's Get Start!",
          showBackButton: false,
          centerTitle: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 19.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
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
                        return null;
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: CustomTextField(
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
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
                    ),

                    // PIN Input
                    Obx(() {
                      return CustomTextField(
                        hintText: 'Password',
                        onChanged: (value) {
                          firebaseAuthController.pin.value = value.trim();
                          firebaseAuthController
                              .signUpCheckField(); // Check fields on change
                        },
                        titleText: 'Password',
                        obscureText: firebaseAuthController.showPassword.value,
                        suffixIconColor: AppColors.textPrimary,
                        suffixSvgPath: firebaseAuthController.showPassword.value
                            ? "assets/eye.svg"
                            : "assets/hide_eye.svg",
                        onSuffixTap: () {
                          firebaseAuthController.showPassword.value =
                              !firebaseAuthController.showPassword.value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                      );
                    }),
                    Obx(() {
                      return Padding(
                        padding: EdgeInsets.only(top: 16.h, bottom: 36.h),
                        child: CustomTextField(
                            hintText: 'Confirm Password',
                            onChanged: (value) {
                              firebaseAuthController.confirmPin.value =
                                  value.trim();
                              firebaseAuthController
                                  .signUpCheckField(); // Check fields on change
                            },
                            titleText: 'Confirm Password',
                            obscureText: firebaseAuthController
                                .showConfirmPassword.value,
                            suffixIconColor: AppColors.textPrimary,
                            suffixSvgPath:
                                firebaseAuthController.showConfirmPassword.value
                                    ? "assets/eye.svg"
                                    : "assets/hide_eye.svg",
                            onSuffixTap: () {
                              firebaseAuthController.showConfirmPassword.value =
                                  !firebaseAuthController
                                      .showConfirmPassword.value;
                            },
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
                      );
                    }),

                    Center(
                      child: AppButton(
                        backgroundColor: AppColors.buttonPrimary,
                        // backgroundColor: firebaseAuthController.isButtonEnabled.value ? AppColors.buttonPrimary : AppColors.buttonDisabled,
                        text: 'Signup',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // If the form is valid, proceed with the signup action
                            try {
                              // ParentModel signupData = ParentModel(
                              //   name: firebaseAuthController.username.value,
                              //   email: firebaseAuthController.email.value,
                              //   password: firebaseAuthController.pin.value,
                              //   gender:
                              //       firebaseAuthController.selectedGender.value,
                              //   dob: firebaseAuthController.birthday.value,
                              //   kids: [],
                              //   createdAt: '',
                              // );
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
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor,
                                  fontSize: 12.sp),
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.off(() => LoginScreen());
                            },
                            child: Text(
                              "LOGIN",
                              style: AppTextStyle.labelLarge.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.buttonPrimary),
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                      child: Text("OR",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w800)),
                    ),

                    // Google Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize:
                            Size(screenWidth * 0.8, 50), // Responsive width
                      ),
                      onPressed: () async {
                        try {
                          //     await firebaseAuthController.signUpWithGoogle();
                        } catch (e) {
                          print("Error: $e");
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 10.w, left: 10.w),
                                    child: SvgPicture.asset(
                                        AppAssets.googleIconSvg,
                                        height: 24),
                                  ),
                                  Text(
                                    "Sign in with Google",
                                    style: AppTextStyle.labelLarge
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                  SizedBox.shrink()
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //       right: 10.w, left: 10.w),
                                  //   child: SvgPicture.asset(
                                  //       AppAssets.appleIconSvg,
                                  //       color: Colors.transparent,
                                  //       height: 10),
                                  // ),
                                ],
                              );
                      }),
                    ),
                    SizedBox(height: 16.h),

                    // Apple Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize:
                            Size(screenWidth * 0.8, 50), // Responsive width
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: SvgPicture.asset(
                                          AppAssets.appleIconSvg,
                                          height: 24),
                                    ),
                                    Text(
                                      "Sign in with Apple",
                                      style: AppTextStyle.labelLarge
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                    SizedBox.shrink()
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.only(right: 10.0),
                                    //   child: SvgPicture.asset(
                                    //       AppAssets.appleIconSvg,
                                    //       color: Colors.transparent,
                                    //       height: 10),
                                    // ),
                                  ],
                                );
                        },
                      ),
                    ),

                    SizedBox(height: 80.h),
                    // Terms and Signup Button
                    Padding(
                      padding: EdgeInsets.only(
                          left: 24.w, right: 24.w, bottom: 10.h),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "By clicking Sign Up, you are agreeing to the ",
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextSpan(
                              text: "Terms of services",
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " & ",
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: "Privacy Policy.",
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
