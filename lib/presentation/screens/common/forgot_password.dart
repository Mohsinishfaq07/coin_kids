import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/common/forgot_password_controller.dart';
import 'package:coin_kids/presentation/dialogs/parent/app_parent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ParentAppBar(
        title: "Recover Password",
        centerTitle: false,
        showBackButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Email Input
                ParentTextField(
                  hintText: 'Email',
                  titleText: 'Email',
                  onChanged: (value) {
                    controller.email.value = value.trim();
                  },
                ),
                const SizedBox(height: 25),
                // Forgot Credentials
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    textAlign: TextAlign.center,
                    "We will  sent  password recovery  message to provided email",
                    style: AppTextStyle.bodySmall,
                  ),
                ),
                const SizedBox(height: 40),

                // Login Button
                AppButton(
                  backgroundColor: AppColors.buttonPrimary,
                  size: Size(0.8.sw, 50),
                  child: Text(
                    "Get Recovery Link",
                    style: AppTextStyle.appButton,
                  ),
                  onPressed: () async {
                    if (controller.email.value.isNotEmpty && controller.email.value.contains('@')) {
                      // await controller.authService.resetPassword(controller.email.value);
                      showDialog(
                        context: context,
                        builder: (context) => AppParentDialog(
                          iconPath: Assets.icEmailSent,
                          title: "Email sent successfully",
                          subtitle: "Password reset e-mail sent to your added email address, Click on the link to recover your password.",
                          buttons: [
                            DialogButton(
                              text: "Close",
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ToastUtil.showToast('Please enter correct E-mail');
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
