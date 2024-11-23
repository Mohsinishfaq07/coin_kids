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
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _controller.updatePageIndex(index);
            },
            children: const [
              OnboardingPage(
                title: "Earn",
                description: "Give Kids Financial Superpowers",
                image: Icons.monetization_on_outlined,
              ),
              OnboardingPage(
                title: "Save",
                description: "Give Kids Financial Superpowers",
                image: Icons.savings_outlined,
              ),
              OnboardingPage(
                title: "Spend",
                description: "Give Kids Financial Superpowers",
                image: Icons.shopping_cart_outlined,
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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: const Text("Skip"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.purple, // Red background color
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
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData image;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.blue[50]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 100, color: Colors.blue),
          const SizedBox(height: 40),
          Text(
            title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
