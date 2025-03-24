import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ParentPinDialog extends StatelessWidget {
  final Function(String) onPinSubmit;
  final bool isFirstTime;

  const ParentPinDialog({
    required this.onPinSubmit,
    required this.isFirstTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final RxString pin = ''.obs;

    void addDigit(String digit) {
      if (pin.value.length < 4) {
        pin.value += digit;
        pinController.text = pin.value;
      }
    }

    void removeDigit() {
      if (pin.value.isNotEmpty) {
        pin.value = pin.value.substring(0, pin.value.length - 1);
        pinController.text = pin.value;
      }
    }

    Widget buildKeypadButton(String text) {
      if (text.isEmpty) {
        // Backspace button
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: KidButton.iconOnly(
            onTap: () => removeDigit(),
            baseColor: Colors.white.withValues(alpha: 0.2),
            size: 45.r,
            iconSize: 20.r,
            showShadowOverlay: false,
            iconPath: Assets.icBack,
            iconColor: Colors.white,
          ),
        );
      }

      // Number buttons
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: KidButton(
          onTap: () => addDigit(text),
          text: text,
          baseColor: Colors.white.withValues(alpha: 0.2),
          height: 45.r,
          width: 45.r,
          showShadowOverlay: false,
          textStyle: AppTextStyle.headingMedium.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 0.85.sw),
            padding: REdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(24.r),
              image: DecorationImage(
                image: AssetImage(Assets.kidDialogBgPng),
                fit: BoxFit.fill,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left side - Title and PIN display
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isFirstTime ? 'Set Parent PIN' : 'Enter Parent PIN',
                          style: AppTextStyle.headingLarge.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isFirstTime)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Text(
                              'Enter your birth year\n(e.g., 1990)',
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(height: 24.h),
                        // PIN Display
                        Container(
                          width: 160.w,
                          height: 50.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) {
                                  final isFilled = index < pin.value.length;
                                  return Container(
                                    width: 16.w,
                                    height: 16.w,
                                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isFilled ? Colors.white : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  );
                                }),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24.w),
                  // Right side - Keypad
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          mainAxisSpacing: 12.h,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 1,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ...List.generate(9, (index) => buildKeypadButton('${index + 1}')),
                            buildKeypadButton(''),
                            buildKeypadButton('0'),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: KidButton.iconOnly(
                                onTap: () {
                                  if (pin.value.length == 4) {
                                    onPinSubmit(pin.value);
                                    Get.back();
                                  }
                                },
                                baseColor: pin.value.length == 4 ? Colors.white : Colors.white.withValues(alpha: 0.2),
                                size: 45.r,
                                iconSize: 20.r,
                                showShadowOverlay: false,
                                iconPath: Assets.icTick,
                                iconColor: pin.value.length == 4 ? AppColors.colorPrimary : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show({
    required bool isFirstTime,
    required Function(String) onPinSubmit,
  }) {
    return Get.dialog(
      ParentPinDialog(
        isFirstTime: isFirstTime,
        onPinSubmit: onPinSubmit,
      ),
      barrierDismissible: true,
    );
  }
}
