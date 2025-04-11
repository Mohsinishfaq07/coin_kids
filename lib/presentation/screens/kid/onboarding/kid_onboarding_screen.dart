import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/age_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/avatar_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/screens/name_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidOnboardingScreen extends GetView<KidOnboardingController> {
  const KidOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (controller.currentStep.value == OnboardingStep.name) {
            bool shouldExit = await showExitConfirmationKidSide(context);
            if (shouldExit) SystemNavigator.pop();
          } else {
            controller.goBack();
          }
        }
      },
      child: Obx(() {
        switch (controller.currentStep.value) {
          case OnboardingStep.name:
            return const KidNameScreen();
          case OnboardingStep.age:
            return const KidAgeScreen();
          case OnboardingStep.avatar:
            return const KidAvatarScreen();
        }
      }),
    );
  }
}

Future<bool> showExitConfirmationKidSide(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 0.85.sw,
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.colorPrimary.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.colorPrimary.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 88.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.colorPrimary.withOpacity(0.2),
                        AppColors.colorPrimary.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.colorPrimary.withOpacity(0.3),
                        AppColors.colorPrimary.withOpacity(0.2),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                ClipOval(
                  child: Image.asset(
                    Assets.appIcon,
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Exit Application',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Are you sure you want to leave the application?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textPrimary.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: AppColors.colorPrimary.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'Stay',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.colorPrimary,
                          AppColors.colorPrimary.withOpacity(0.9),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.colorPrimary.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ) ?? false;
}
