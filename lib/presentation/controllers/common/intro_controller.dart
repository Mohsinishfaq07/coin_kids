 import 'package:carousel_slider/carousel_slider.dart';
import 'package:coin_kids/presentation/screens/common/intro/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  final pageIndex = 0.obs;
  final CarouselSliderController carouselController = CarouselSliderController();

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  List<Widget> pages = [
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
      imagePath: 'assets/on_board/anim_onboard_spend.json',
    ),
  ];
}
