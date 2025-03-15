import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_change_pin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ParentChangePinScreen extends GetView<ParentChangePinController> {
  ParentChangePinScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ParentAppBar(
        title: "Change PIN",
        centerTitle: false,
        showBackButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => controller.isFirstTime.value
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current PIN",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Obx(
                              () => ParentTextField(
                                titleText: 'Current PIN',
                                hintText: "Enter current PIN",
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                obscureText: !controller.currentPinVisible.value,
                                onChanged: (value) {
                                  controller.currentPin.value = value;
                                },
                                validator: controller.validatePin,
                                suffixIcon: !controller.currentPinVisible.value ? Icons.visibility_off : Icons.visibility,
                                onSuffixTap: controller.toggleCurrentPinVisibility,
                                inputFormatter: TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                    if (newValue.text.isEmpty) {
                                      return newValue;
                                    }
                                    if (RegExp(r'^[0-9]+$').hasMatch(newValue.text)) {
                                      return newValue;
                                    }
                                    return oldValue;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h),
                          ],
                        )),
                  Text(
                    "New PIN",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => ParentTextField(
                        titleText: 'New PIN',
                        hintText: "Enter new PIN",
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: !controller.newPinVisible.value,
                        onChanged: (value) {
                          controller.newPin.value = value;
                        },
                        inputFormatter: TextInputFormatter.withFunction(
                          (oldValue, newValue) {
                            if (newValue.text.isEmpty) {
                              return newValue;
                            }
                            if (RegExp(r'^[0-9]+$').hasMatch(newValue.text)) {
                              return newValue;
                            }
                            return oldValue;
                          },
                        ),
                        validator: controller.validatePin,
                        suffixIcon: !controller.newPinVisible.value ? Icons.visibility_off : Icons.visibility,
                        onSuffixTap: controller.toggleNewPinVisibility,
                      )),
                  SizedBox(height: 25.h),
                  Text(
                    "Confirm PIN",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => ParentTextField(
                        titleText: 'Confirm PIN',
                        hintText: "Re-enter new PIN",
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: !controller.confirmPinVisible.value,
                        onChanged: (value) {
                          controller.confirmPin.value = value;
                        },
                        inputFormatter: TextInputFormatter.withFunction(
                          (oldValue, newValue) {
                            if (newValue.text.isEmpty) {
                              return newValue;
                            }
                            if (RegExp(r'^[0-9]+$').hasMatch(newValue.text)) {
                              return newValue;
                            }
                            return oldValue;
                          },
                        ),
                        validator: controller.validatePin,
                        suffixIcon: !controller.confirmPinVisible.value ? Icons.visibility_off : Icons.visibility,
                        onSuffixTap: controller.toggleConfirmPinVisibility,
                      )),
                  SizedBox(height: 40.h),
                  Center(
                    child: AppButton(
                      backgroundColor: AppColors.buttonPrimary,
                      child: Text(
                        "Save Changes",
                        style: AppTextStyle.appButton,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await controller.updatePin();
                        }
                      },
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
