import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/role_selection_controller.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RoleSelectionScreen extends GetView<RoleSelectionController> {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await showExitConfirmation(context);
          if (shouldExit) Get.back();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kTextTabBarHeight + 20.h,
                  ),
                  Text(
                    "Are you a parent or a child?",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 24.sp,
                        ),
                  ),
                  SizedBox(height: 57.h),
                  OptionCard(
                    imagePath: Assets.icImParent,
                    title: "I'm a Parent",
                    description: "Give allowances",
                    onTap: () async {
                      //await controller.analytics.logRoleSelected(AnalyticsParameterNames.roleParent, AnalyticsScreenNames.roleSelection ,AnalyticsScreenNames.parentHome );
                      controller.finalizeRole(UserRole.parent);
                    },
                    description1: "Support your child's",
                    description2: "Financial journey  ",
                  ),
                  SizedBox(height: 14.h),
                  OptionCard(
                    imagePath: Assets.icImKid,
                    title: "I'm a Child",
                    description: "Receive Allowance",
                    onTap: () async {
                      // await controller.analytics.logRoleSelected(AnalyticsParameterNames.roleChild, AnalyticsScreenNames.roleSelection, AnalyticsScreenNames.kidBaseScreen);
                      controller.finalizeRole(UserRole.child);
                    },
                    description1: 'Set up saving goals',
                    description2: '',
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

class OptionCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String description1;
  final String description2;
  final VoidCallback onTap;
  final Color? imageColor;

  const OptionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.description1,
    required this.description2,
    required this.onTap,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 147.h,
        width: 320.w,
        decoration: BoxDecoration(
          color: const Color(0xFFEDFAFF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CircleAvatar(
                radius: 38,
                backgroundColor: AppColors.colorPrimary,
                child: SvgPicture.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  colorFilter: imageColor != null ? ColorFilter.mode(imageColor!, BlendMode.srcIn) : null,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
                    ),
                    SizedBox(height: 9.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.icCoinEuro,
                          height: 20.w,
                          width: 20.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(description,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.icSupport,
                          height: 20.w,
                          width: 20.w,
                        ),
                        const SizedBox(width: 10),
                        Text(description1,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontSize: 14)),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.icSupport,
                          height: 18.h,
                          colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.clear),
                        ),
                        const SizedBox(width: 12),
                        Text(description2, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showExitConfirmation(BuildContext context) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 2),
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
                  color: AppColors.colorPrimary.withValues(alpha: 1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.colorPrimary.withValues(alpha: 1),
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
                            AppColors.colorPrimary.withValues(alpha: 2),
                            AppColors.colorPrimary.withValues(alpha: 1),
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
                            AppColors.colorPrimary.withValues(alpha: 3),
                            AppColors.colorPrimary.withValues(alpha: 2),
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
                    color: AppColors.textPrimary.withValues(alpha: 7),
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
                          backgroundColor: AppColors.colorPrimary.withValues(alpha: 08),
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
                              AppColors.colorPrimary.withValues(alpha: 9),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.colorPrimary.withValues(alpha: 25),
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
      ) ??
      false;
}
