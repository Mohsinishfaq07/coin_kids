import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/role_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RoleSelectionScreen extends GetView<RoleSelectionController> {
  RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Are you a parent or a child?",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 24.sp, // Adjust the font size as needed
                      ),
                ),
                SizedBox(height: 57.h),
                OptionCard(
                  imagePath: Assets.icImParent,
                  title: "I’m a Parent",
                  description: "Give allowances",
                  onTap: () async {
                    controller.finalizeRole(UserRole.PARENT);
                  },
                  description1: "Support your child's",
                  description2: "Financial journey  ",
                ),
                SizedBox(height: 14.h),
                OptionCard(
                  imagePath: Assets.icImKid,
                  title: "I’m a Child",
                  description: "Receive Allowance",
                  onTap: () async {
                    controller.finalizeRole(UserRole.CHILD);
                  },
                  description1: 'Set up saving goals',
                  description2: '',
                ),
              ],
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
        height: 147.h,
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
                  color: imageColor,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
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
                      Text(description, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontSize: 14)),
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
                      Text(description1, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icSupport,
                        height: 18.h,
                        color: Colors.transparent,
                      ),
                      const SizedBox(width: 12),
                      Text(description2, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
