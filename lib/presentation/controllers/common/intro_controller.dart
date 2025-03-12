import 'package:carousel_slider/carousel_slider.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/screens/common/intro/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  final pageIndex = 0.obs;
  final CarouselSliderController carouselController = CarouselSliderController();

  @override
  void onInit() {
    OrientationUtils.lockToPortrait();
    super.onInit();
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  List<Widget> pages = [
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
}
