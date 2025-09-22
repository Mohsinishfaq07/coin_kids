import 'dart:io';
import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/share_utils.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_exit_dialog.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/common/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignupScreen extends GetView<SignupController> {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await ParentExitDialog.show(context);
          if (shouldExit) {
            await controller.logScreenTime(); // Log screen time before exit
            Get.back();
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ParentAppBar(
          backgroundColor: Color(0xFFCAF0FF),
          title: "Let's Get Start!",
          showBackButton: false,
          centerTitle: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  if (Platform.isIOS) ...[
                    // Google Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(screenWidth * 0.84, 50), // Responsive width
                      ),
                      onPressed: () async {
                        try {
                          await controller.signInWithGoogle();
                          await controller.analytics.logSignUpSuccess("google_sign_in", "sign_up_screen");
                        } catch (e) {
                          Get.log("Error: $e");
                          await controller.analytics.logSignUpFailure(e.toString(), "sign_up_screen");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, left: 10.w),
                            child: SvgPicture.asset(Assets.icGoogle, height: 24),
                          ),
                          Text(
                            "Sign in with Google",
                            style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp),
                          ),
                          SizedBox.shrink()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(screenWidth * 0.84, 50), // Responsive width
                      ),
                      onPressed: () async {
                        try {
                          await controller.signInWithApple();
                          await controller.analytics.logSignUpSuccess("apple_sign_in", "sign_up_screen");
                        } catch (e) {
                          Get.log("Error: $e");
                          await controller.analytics.logSignUpFailure(e.toString(), "sign_up_screen");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, left: 10.w),
                            child: SvgPicture.asset(Assets.icApple, height: 24),
                          ),
                          Text(
                            "Sign in with Apple",
                            style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp),
                          ),
                          SizedBox.shrink()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.textPrimary, fontSize: 12.sp),
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.offNamed(Routes.signIn);
                            },
                            child: Text(
                              "LOGIN",
                              style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp, color: AppColors.buttonPrimary),
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                      child: Text("OR", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54, fontWeight: FontWeight.w800)),
                    ),
                  ],
                  if (Platform.isAndroid) ...[
                    // Google Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(screenWidth * 0.84, 50), // Responsive width
                      ),
                      onPressed: () async {
                        try {
                          await controller.signInWithGoogle();
                          await controller.analytics.logSignUpSuccess("google_sign_in", "sign_up_screen");
                        } catch (e) {
                          Get.log("Error: $e");
                          await controller.analytics.logSignUpFailure(e.toString(), "sign_up_screen");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, left: 10.w),
                            child: SvgPicture.asset(Assets.icGoogle, height: 24),
                          ),
                          Text(
                            "Sign in with Google",
                            style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp),
                          ),
                          SizedBox.shrink()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.textPrimary, fontSize: 12.sp),
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.offNamed(Routes.signIn);
                            },
                            child: Text(
                              "LOGIN",
                              style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp, color: AppColors.buttonPrimary),
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                      child: Text("OR", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54, fontWeight: FontWeight.w800)),
                    ),
                  ],
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ParentTextField(
                          textInputAction: TextInputAction.next,
                          hintText: 'Full Name',
                          onChanged: (value) {
                            controller.name.value = value.trim();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Full Name is required";
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: ParentTextField(
                            textInputAction: TextInputAction.next,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              controller.email.value = value.trim();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              // Validate email format
                              if (!GetUtils.isEmail(value)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                        ),
              
                        // PIN Input
                        Obx(() {
                          return ParentTextField(
                            textInputAction: TextInputAction.next,
                            hintText: 'Password',
                            onChanged: (value) {
                              controller.password.value = value.trim();
                            },
                            obscureText: controller.showPassword.value,
                            suffixIconColor: AppColors.textPrimary,
                            suffixSvgPath: controller.showPassword.value ? Assets.icEyeHide : Assets.icEye,
                            onSuffixTap: () {
                              controller.showPassword.value = !controller.showPassword.value;
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
                            child: ParentTextField(
                                textInputAction: TextInputAction.done,
                                hintText: 'Confirm Password',
                                onChanged: (value) {
                                  controller.confirmPassword.value = value.trim();
                                },
                                obscureText: controller.showPassword.value,
                                suffixIconColor: AppColors.textPrimary,
                                suffixSvgPath: controller.showPassword.value ? Assets.icEyeHide : Assets.icEye,
                                onSuffixTap: () {
                                  controller.showPassword.value = !controller.showPassword.value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Confirm Password is required";
                                  }
                                  if (value != controller.password.value) {
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
                            size: Size(0.8.sw, 50),
                            child: Text(
                              "Sign up",
                              style: AppTextStyle.appButton,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                try {
                                  await controller.analytics.logSignUpAttempt("sign_up_screen");
                                  await controller.signUpWithEmail();
                                  await controller.analytics.logSignUpSuccess(controller.email.value, "sign_up_screen");
                                } catch (e) {
                                  Get.log("Error: $e");
                                  await controller.analytics.logSignUpFailure(e.toString(), "sign_up_screen");
                                }
                              } else {
                                await controller.analytics.logSignUpValidationFailure("sign_up_screen");
                                Get.log("Form validation failed");
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                  // Terms and Conditions at bottom
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "By clicking Sign Up, you are agreeing to the ",
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
                              fontSize: 11.sp,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                ShareUtils.openLink(termAndCondition);
                              },
                          ),
                          TextSpan(
                            text: " & ",
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 11.sp,
                            ),
                          ),
                          TextSpan(
                            text: "Privacy Policy.",
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 11.sp,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                ShareUtils.openLink(privacyPolicy);
                              },
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
    );
  }
}
