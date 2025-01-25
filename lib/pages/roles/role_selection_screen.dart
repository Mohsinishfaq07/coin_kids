import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_onboarding.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_home_page.dart';
import 'package:coin_kids/pages/roles/parents/authentication/login/login_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app_assets.dart';
import '../../theme/color_theme.dart';
import 'kid_landscape_section/common_funcitons.dart/common_funcitons.dart';

class RoleSelectionScreen extends StatelessWidget {
  RoleSelectionScreen({super.key});
  // final splashCOntroller = Get.put(SplashController());
  final firebaseAuthController = Get.put(FirebaseAuthController());
  final parentController = Get.put(ParentController());

  @override
  Widget build(BuildContext context) {
    PortraitOrientation();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: SafeArea(
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
                    imagePath: "assets/role_selection_icons/im_parent_icon.svg",
                    title: "I’m a Parent",
                    description: "Give allowances",
                    onTap: () async {
                      final isParent = await firebaseAuthController
                          .checkIfParent(firebaseAuthController.email.value);
                      if (isParent) {
                        bool parentHasKids = await parentController.fetchKids();
                        if (parentHasKids) {
                          Get.off(() => ParentBottomNavigationBar());
                        } else {
                          Get.off(() => const ParentsHomeScreen());
                        }
                        // Navigate to ParentBottomNavigationBar if user is a parent
                      } else {
                        Get.off(() => LoginScreen());
                        // Navigate to KidMyMoney if user is a kid
                        //  Get.off(() => const KidHomePage());
                      }

                      // Get.offAll(const ParentsHomeScreen());
                    },
                    description1: "Support your child's",
                    description2: "Financial journey  ",
                  ),
                  SizedBox(height: 14.h),
                  OptionCard(
                    imagePath: "assets/role_selection_icons/Group.svg",
                    title: "I’m a Child",
                    description: "Receive Allowance",
                    onTap: () async {
                      final isParent = await firebaseAuthController
                          .checkIfParent(firebaseAuthController.email.value);
                      if (isParent) {
                        bool parentHasKids = await parentController.fetchKids();
                        if (parentHasKids) {
                          Get.off(() => KidHomePage());
                        } else {
                          Get.off(() =>   KidSectionOnboarding());
                        }
                        // Navigate to ParentBottomNavigationBar if user is a parent
                      } else {
                        Get.off(() => LoginScreen());
                        // Navigate to KidMyMoney if user is a kid
                        //  Get.off(() => const KidHomePage());
                      }

                      //
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
        height: 147.h,
        width: 320.w,
        decoration: BoxDecoration(
          color: const Color(0xFFEDFAFF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
                backgroundColor: Colors.purple,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 18.sp),
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.coinSvg,
                        height: 20.w,
                        width: 20.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor,
                                  fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.supportSvg,
                        height: 20.w,
                        width: 20.w,
                      ),
                      const SizedBox(width: 10),
                      Text(description1,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor,
                                  fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.coinSvg,
                        height: 22,
                        color: Colors.transparent,
                      ),
                      const SizedBox(width: 12),
                      Text(description2,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor)),
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
