import 'package:carousel_slider/carousel_slider.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/screens/common/intro/intro_screen.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  final pageIndex = 0.obs;
  final CarouselSliderController carouselController = CarouselSliderController();
  final analytics = Get.find<AnalyticsService>();
  DateTime? _screenStartTime;


  final List<Widget> pages = [
    OnboardingPage(
      title: "Earn",
      description: "Give Kids Financial Superpowers",
      imagePath: Assets.animOnboardEarn,
    ),
    OnboardingPage(
      title: "Save",
      description: "Give Kids Financial Superpowers",
      imagePath: Assets.animOnboardSave,
    ),
    OnboardingPage(
      title: "Spend",
      description: "Give Kids Financial Superpowers",
      imagePath: Assets.animOnboardSpend,
    ),
  ];

  final List<String> pageTitles = ["Earn", "Save", "Spend"];

  @override
  void onInit() {
    OrientationUtils.lockToPortrait();
    // _initAnalytics();
    _screenStartTime = DateTime.now();
    logScreenTime();
    super.onInit();
  }

  // Future<void> _initAnalytics() async {
  //   // Track initial page view
  //   await _analytics.logScreenView(
  //     screenName: AnalyticsScreenNames.intro,
  //     screenClass: 'IntroScreen',
  //   );
  //   await _analytics.logIntroPageView(0, pageTitles[0]);
  // }

  void updatePageIndex(int index) {
    pageIndex.value = index;
    analytics.logIntroPageView(index, pageTitles[index]);
  }

  Future<void> skipToLast() async {
    await analytics.logIntroAction('skip');
    carouselController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Future<void> nextPage() async {
    await analytics.logIntroAction('next');
    carouselController.animateToPage(
      pageIndex.value + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Future<void> completeIntro() async {
    await analytics.logIntroComplete();
  }


  @override
  void onClose() {
    logScreenTime();
    super.onClose();
  }

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(AnalyticsScreenNames.intro,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.intro,
    );
  }

}
