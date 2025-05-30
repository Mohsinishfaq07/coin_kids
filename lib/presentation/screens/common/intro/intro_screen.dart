import 'package:carousel_slider/carousel_slider.dart';
import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/share_utils.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/common/app_icon_button.dart';
import 'package:coin_kids/presentation/controllers/common/intro_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class IntroScreen extends GetView<IntroController> {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.pageIndex.value == controller.pages.length - 1)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 1.h),
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
                        fontSize: 11.sp,
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
                        fontSize: 11.sp,
                      ),
                    ),
                    TextSpan(
                      text: "Privacy Policy.",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 11.sp,
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
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
              left: 20.w,
              right: 20.w,
            ),
            child: Obx(() {
              return controller.pageIndex.value == controller.pages.length - 1
                  ? AppButton(
                      onPressed: () async {
                        await controller.completeIntro();
                        Get.offNamed(Routes.signUp);
                      },
                      size: Size(0.8.sw, 50),
                      child: Text(
                        "Done",
                        style: AppTextStyle.appButton,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => controller.skipToLast(),
                          child: Text(
                            "Skip",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: controller.pageIndex.value == index
                                    ? AppColors.iconPrimary
                                    : AppColors.iconDisabled,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        AppIconButton(
                          onPressed: () => controller.nextPage(),
                          icon: const Icon(Icons.arrow_forward_rounded),
                        ),
                      ],
                    );
            }),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 46.h),
                child: SvgPicture.asset(
                  Assets.parentBgCloud,
                  width: 360.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
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
              ],
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
            style: AppTextStyle.headingMedium.copyWith(fontWeight: MyFontWeight.regular.fontWeight, color: AppColors.textSecondary)),
          //  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: MyFontWeight.thin.fontWeight, color: AppColors.textSecondary,fontSize: 18.sp)        ),
        ],
      ),
    );
  }
}
