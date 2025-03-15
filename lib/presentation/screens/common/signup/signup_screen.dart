import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/share_utils.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 19.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    ParentTextField(
                      hintText: 'Full Name',
                      onChanged: (value) {
                        controller.name.value = value.trim();
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
                      child: ParentTextField(
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          controller.email.value = value.trim();
                        },
                        titleText: 'Email',
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
                        hintText: 'Password',
                        onChanged: (value) {
                          controller.password.value = value.trim();
                        },
                        titleText: 'Password',
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
                            hintText: 'Confirm Password',
                            onChanged: (value) {
                              controller.confirmPassword.value = value.trim();
                            },
                            titleText: 'Confirm Password',
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
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              controller.signUpWithEmail();
                            } catch (e) {
                              Get.log("Error: $e");
                            }
                          } else {
                            // If the form is not valid, show error messages
                            Get.log("Form validation failed");
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
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontSize: 12.sp),
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
                      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                      child: Text("OR", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54, fontWeight: FontWeight.w800)),
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
                          await controller.signInWithGoogle();
                        } catch (e) {
                          Get.log("Error: $e");
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
                    SizedBox(height: 16.h),

                    SizedBox(height: 80.h),
                    // Terms and Signup Button
                    Padding(
                      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 10.h),
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
                                fontSize: 12,
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
      ),
    );
  }
}
