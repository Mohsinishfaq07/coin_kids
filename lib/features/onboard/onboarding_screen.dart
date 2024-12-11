// onboarding_screen.dart
import 'package:coin_kids/features/onboard/onboard_controller.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final OnboardingController _controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFCAF0FF), Color(0xFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            // Path to your image
            // Ensures the image covers the entire screen
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/background_image/background_Image.png', // Path to your image
                  fit: BoxFit.cover, // Adjust fit to your needs
                  height: MediaQuery.of(context).size.height *
                      0.3, // Top 30% of the screen
                  width: double.infinity,
                ),
              ),
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _controller.updatePageIndex(index);
                },
                children: const [
                  OnboardingPage(
                    title: "Earn",
                    description: "Give Kids Financial Superpowers",
                    imagePath: "assets/on_board/coin-Icve1wV1C9.png",
                  ),
                  OnboardingPage(
                    title: "Save",
                    description: "Give Kids Financial Superpowers",
                    imagePath: "assets/on_board/coin-Icve1wV1C9.png",
                  ),
                  OnboardingPage(
                    title: "Spend",
                    description: "Give Kids Financial Superpowers",
                    imagePath: "assets/on_board/basket.png",
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: Colors.purple,
                        dotColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return _controller.pageIndex.value == 2
                          ? CustomButton(
                              text: 'Get Started',
                              onPressed: _controller.navigateToRoleSelection,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Skip to the last page
                                    _pageController.animateToPage(
                                      2,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: const Text(
                                    "Skip",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color:
                                          Colors.purple, // Red background color
                                      shape: BoxShape.circle, // Circular shape
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        // Move to the next page
                                        _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      },
                                      color: Colors.white, // Icon color
                                    ),
                                  ),
                                )
                              ],
                            );
                    }),
                  ],
                ),
              ),
            ],
          ),
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
    required this.title,
    required this.description,
    required this.imagePath,
  });

  Future<bool> _checkImageExists(String path) async {
    try {
      await AssetImage(path).obtainKey(const ImageConfiguration());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<bool>(
          future: _checkImageExists(imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Placeholder while checking if the image exists
              return const CircularProgressIndicator();
            } else if (snapshot.hasError || !(snapshot.data ?? false)) {
              // Show an error widget or placeholder if the image does not exist
              return const Icon(
                Icons.broken_image,
                size: 100,
                color: Colors.red,
              );
            } else {
              // Display the actual image if it exists
              return Image.asset(
                imagePath,
                height: 200, // Set desired height
                fit: BoxFit.contain, // Adjust the image fit
              );
            }
          },
        ),
        const SizedBox(height: 40),
        Text(
          title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
        ),
      ],
    );
  }
}
