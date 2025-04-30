import 'dart:io';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_exit_dialog.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/common/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignInScreen extends GetView<SignInController> {
  final _formKey = GlobalKey<FormState>();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      // canPop: false,
      canPop: false, // Block default back behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await ParentExitDialog.show(context);
          if (shouldExit) Get.back();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const ParentAppBar(
          backgroundColor: Color(0xFFCAF0FF),
          title: "Welcome Back!",
          showBackButton: false,
          centerTitle: false,
        ),
        body: Container(
          decoration: BoxDecoration(
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
                    ParentTextField(
                      textInputAction: TextInputAction.next,
                      hintText: 'Email',
                      titleText: 'Email',
                      onChanged: (value) {
                        controller.email.value = value.trim();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // PIN Input
                    Obx(() {
                      return ParentTextField(
                        textInputAction: TextInputAction.done,
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
                        titleText: 'Password',
                      );
                    }),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.forgetPassword);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: CustomThemeData().primaryTextColor, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Login Button
                    AppButton(
                      backgroundColor: AppColors.buttonPrimary,
                      size: Size(0.8.sw, 50),
                      child: Text(
                        "Sign In",
                        style: AppTextStyle.appButton,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            await controller.analytics.logSignInAttempt(AnalyticsScreenNames.signIn);
                           // ToastUtil.showToast("log sign in attempt called ${controller.email.value}");
                            print("Firebase sign-up analytics event logged");

                            await controller.signInWithEmail();
                            await controller.analytics.logSignInSuccess(controller.email.value, AnalyticsScreenNames.signIn);
                          } catch (e) {
                            ToastUtil.showToast("Login failed: $e");
                            await controller.analytics.logSignInFailure(
                              e.toString(),AnalyticsScreenNames.signIn
                            );
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
                            Get.offNamed(Routes.signUp);
                          },
                          child: Text(
                            "SignUp",
                            style: AppTextStyle.labelLarge.copyWith(fontSize: 14.sp, color: AppColors.buttonPrimary),
                          ),
                        ),
                      ],
                    ),
                    if (Platform.isAndroid)
                      Padding(
                        padding: EdgeInsets.only(top: 31.h, bottom: 20.h),
                        child: Text("OR",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: CustomThemeData().disabledIconColor,
                                  fontWeight: FontWeight.w800,
                                )),
                      ),

                    // Google Login Button - Show only on Android
                    if (Platform.isAndroid)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: Size(screenWidth * 0.8, 50), // Responsive width
                        ),
                        onPressed: () async {
                          await controller.signInWithGoogle();
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
                            Padding(
                              padding: EdgeInsets.only(right: 10.w, left: 10.w),
                              child: SizedBox(
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 16.h),
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
