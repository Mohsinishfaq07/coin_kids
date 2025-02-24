import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/portrait_orientation.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/controllers/common/sign_in_controller.dart';
import 'package:coin_kids/presentation/screens/common/signup/signup_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<SignInController> {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PortraitOrientation();
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(
          backgroundColor: Color(0xFFCAF0FF),
          title: "Welcome Back!",
          showBackButton: false,
          centerTitle: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),

                    // Email Input
                    CustomTextField(
                      hintText: 'Email',
                      titleText: 'Email',
                      onChanged: (value) {
                        controller.email.value = value.trim();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // PIN Input
                    Obx(() {
                      return CustomTextField(
                        hintText: 'Password',
                        onChanged: (value) {
                          controller.password.value = value.trim();
                        },
                        obscureText: controller.showPassword.value,
                        suffixIconColor: AppColors.textPrimary,
                        suffixSvgPath: controller.showPassword.value ? "assets/eye.svg" : "assets/hide_eye.svg",
                        onSuffixTap: () {
                          controller.showPassword.value = !controller.showPassword.value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        titleText: 'Password',
                      );
                    }),
                    SizedBox(height: 62.h),

                    // Forgot Credentials
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Get.to(() => ForgotPasswordScreen());
                    //     },
                    //     child: Text(
                    //       "Forgot Credentials?",
                    //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    //           color: CustomThemeData().primaryTextColor,
                    //           fontSize: 12),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 40),

                    // Login Button
                    AppButton(
                      backgroundColor: AppColors.buttonPrimary,
                      text: controller.isEmailLoading.value ? 'Logging in...' : 'Login',
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            await controller.signInWithEmail();
                          } catch (e) {
                            ToastUtil.showToast("Login failed: $e");
                          }
                        } else {
                          ToastUtil.showToast("Please fill all required fields correctly");
                        }
                      },
                    ),

                    SizedBox(height: 22.h),

                    // Signup Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontSize: 12.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.off(() => SignupScreen());
                          },
                          child: Text(
                            "SignUp",
                            style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp, color: AppColors.buttonPrimary),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 31.h, bottom: 20.h),
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
                        try {
                          // await controller.loginWithGoogle();
                        } catch (e) {
                          print("Error: $e");
                        }
                      },
                      child: Obx(() {
                        return controller.isGoogleLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                                    child: SvgPicture.asset(AppAssets.googleIconSvg, height: 24),
                                  ),
                                  Text(
                                    "Sign in with Google",
                                    style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                                    child: SvgPicture.asset(AppAssets.appleIconSvg, color: Colors.transparent, height: 10),
                                  ),
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
                        fixedSize: Size(screenWidth * 0.8, 50), // Responsive width
                      ),
                      onPressed: () {
                        // controller.signinWithApple();
                      },
                      child: Obx(
                        () {
                          return controller.isAppleLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: SvgPicture.asset(AppAssets.appleIconSvg, height: 24),
                                    ),
                                    Text(
                                      "Sign in with Apple",
                                      style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: SvgPicture.asset(AppAssets.appleIconSvg, color: Colors.transparent, height: 10),
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
        ),
      ),
    );
  }
}
