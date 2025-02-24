import 'package:carousel_slider/carousel_slider.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/portrait_orientation.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/common/AppIconButton.dart';
import 'package:coin_kids/presentation/controllers/common/intro_controller.dart';
import 'package:coin_kids/presentation/screens/common/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class IntroScreen extends GetView<IntroController> {
  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PortraitOrientation();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 46.h),
                child: SvgPicture.asset(
                  AppAssets.cloudImageSvg,
                  width: 360.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Center(
              child: CarouselSlider(
                items: controller.pages,
                carouselController: controller.carouselController,
                options: CarouselOptions(
                  aspectRatio: 1.0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    controller.updatePageIndex(index);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 22.h,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    return controller.pageIndex.value == controller.pages.length - 1
                        ? AppButton(
                            onPressed: () {
                              Get.off(() => SignupScreen());
                            },
                            text: "Get Started")
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    controller.carouselController.animateToPage(
                                      controller.pages.length - 1,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Text(
                                    "Skip",
                                    style: AppTextStyle.bodyLarge.copyWith(color: AppColors.textSecondary),
                                  ),
                                ),
                                Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(controller.pages.length, (index) {
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        width: controller.pageIndex.value == index ? 10 : 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: controller.pageIndex.value == index ? AppColors.iconPrimary : AppColors.iconDisabled,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                                AppIconButton(
                                  onPressed: () {
                                    controller.carouselController.animateToPage(
                                      controller.pageIndex.value + 1,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded),
                                ),
                              ],
                            ),
                          );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Lottie.asset(
            imagePath,
            height: 190.h,
            width: 190.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 15.h),
          Text(
            title,
            style: AppTextStyle.headingLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          SizedBox(height: 11.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyle.headingMedium.copyWith(fontWeight: MyFontWeight.Regular.fontWeight, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
