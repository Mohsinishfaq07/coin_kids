import 'package:carousel_slider/carousel_slider.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/onboard/onboard_controller.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final OnboardingController _controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = [
      OnboardingPage(
        title: "Earn",
        description: "Give Kids Financial Superpowers",
        imagePath: 'assets/on_board/anim_onboard_earn.json',
      ),
      OnboardingPage(
        title: "Save",
        description: "Give Kids Financial Superpowers",
        imagePath: 'assets/on_board/anim_onboard_save.json',
      ),
      OnboardingPage(
        title: "Spend",
        description: "Give Kids Financial Superpowers",
        imagePath: 'assets/on_board/anim_onboard_save.json',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  AppAssets.appCloudsImage,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                ),
              ),
            ),
            Center(
              child: CarouselSlider(
                items: pages,
                carouselController: _carouselController,
                options: CarouselOptions(
                  aspectRatio: 1.0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    _controller.updatePageIndex(index);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    return _controller.pageIndex.value == pages.length - 1
                        ? CustomButton(
                            text: 'Get Started',
                            onPressed: _controller.navigateToRoleSelection,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _carouselController.animateToPage(
                                    pages.length - 1,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: Text(
                                  "Skip",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      List.generate(pages.length, (index) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      width:
                                          _controller.pageIndex.value == index
                                              ? 10
                                              : 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: _controller.pageIndex.value ==
                                                index
                                            ? CustomThemeData().activeIconColor
                                            : CustomThemeData()
                                                .disabledIconColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  }),
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    _carouselController.animateToPage(
                                      _controller.pageIndex.value +
                                          1, // Move to the next index
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          CustomThemeData().primaryButtonColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/on_board/arrow_forward_icon.svg",
                                        height: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.arrow_forward),
                                    //   onPressed: () {
                                    //     _carouselController.animateToPage(
                                    //       _controller.pageIndex.value +
                                    //           1, // Move to the next index
                                    //       duration:
                                    //           const Duration(milliseconds: 500),
                                    //       curve: Curves.ease,
                                    //     );
                                    //   },
                                    //   color: Colors.white,
                                    // ),
                                  ),
                                ),
                              ),
                            ],
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
    return Column(
      children: [
        Lottie.asset(
          imagePath,
          height: 190,
          width: 190,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 14),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
