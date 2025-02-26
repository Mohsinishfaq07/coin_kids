import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class KidsOnBoardingController extends GetxController {
  final GlobalKey textFieldKey = GlobalKey();
  final GlobalKey ageListKey = GlobalKey();
  final GlobalKey avatarListKey = GlobalKey();
  final GlobalKey jarKey = GlobalKey();
  final GlobalKey spendingJarKey = GlobalKey();
  final GlobalKey savingsJarKey = GlobalKey();

  void startShowcase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context)
          .startShowCase([textFieldKey, ageListKey, avatarListKey,jarKey,spendingJarKey,savingsJarKey]);
    });
  }

  @override
  void onReady() {
    super.onReady();
    startShowcase(Get.context!); // Call showcase after UI builds
  }
  RxBool spotLightOn = false.obs;

  RxInt spotLightIndex = 0.obs;

  RxString selectedAge = "".obs;
  RxString selectedAvatar = "".obs;

  List<String> ageList = ['6', '7', '8', '9', '10', '11', '12', '13', '14+'];
  final List<String> avatars = [
    "assets/child_avatar_image_pngs/Frame 1.png",
    "assets/child_avatar_image_pngs/Frame 2.png",
    "assets/child_avatar_image_pngs/Frame 3.png",
    "assets/child_avatar_image_pngs/Frame 4.png",
    "assets/child_avatar_image_pngs/Frame 5.png",
    "assets/child_avatar_image_pngs/Frame 6.png",
    "assets/child_avatar_image_pngs/Frame 7.png",
    "assets/child_avatar_image_pngs/Frame 8.png",
    "assets/child_avatar_image_pngs/Frame 9.png",
    "assets/child_avatar_image_pngs/Frame 10.png",
    "assets/child_avatar_image_pngs/Frame 11.png",
    "assets/child_avatar_image_pngs/Frame 12.png",
    "assets/child_avatar_image_pngs/Frame 13.png",
    "assets/child_avatar_image_pngs/Frame 14.png",
    "assets/child_avatar_image_pngs/Frame 15.png",
    "assets/child_avatar_image_pngs/Frame 16.png",
    "assets/child_avatar_image_pngs/Frame 17.png",
    "assets/child_avatar_image_pngs/Frame 18.png",
    "assets/child_avatar_image_pngs/Frame 19.png",
    "assets/child_avatar_image_pngs/Frame 20.png",
    "assets/child_avatar_image_pngs/Frame 21.png",
    "assets/child_avatar_image_pngs/Frame 22.png",
    "assets/child_avatar_image_pngs/Frame 23.png",
    "assets/child_avatar_image_pngs/Frame 24.png",
    "assets/child_avatar_image_pngs/Frame 25.png",
    "assets/child_avatar_image_pngs/Frame 26.png",
    "assets/child_avatar_image_pngs/Frame 27.png",
    "assets/child_avatar_image_pngs/Frame 28.png",
    "assets/child_avatar_image_pngs/Frame 29.png",
    "assets/child_avatar_image_pngs/Frame 30.png",
    "assets/child_avatar_image_pngs/Frame 31.png",
    "assets/child_avatar_image_pngs/Frame 32.png",
    "assets/child_avatar_image_pngs/Frame 33.png",
    "assets/child_avatar_image_pngs/Frame 34.png",
    "assets/child_avatar_image_pngs/Frame 35.png",
    "assets/child_avatar_image_pngs/Frame 36.png"
  ];

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), () {
     // showOnBoarding1SpotLight();
    });
    super.onInit();
  }

  showOnBoarding1SpotLight() {
    spotLightOn.value = true;
    Get.log('showing spot light : $spotLightOn');
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent, // Make background transparent
          child: Text(""),
        );
      },
    ).then((_) {
      spotLightOn.value = false;
      Get.log('spot light dismissed : $spotLightOn');
    });
  }

  // showOnBoarding2SpotLight() {
  //   spotLightOn.value = true;
  //   Get.log('showing spot light : $spotLightOn');
  //   showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return const Dialog(
  //         backgroundColor: Colors.transparent, // Make background transparent
  //         child: SpotLight2DialogueBox(),
  //       );
  //     },
  //   ).then((_) {
  //     spotLightOn.value = false;
  //     Get.log('spot light dismissed : $spotLightOn');
  //   });
  // }

  // showOnBoarding3SpotLight() {
  //   spotLightOn.value = true;
  //   Get.log('showing spot light : $spotLightOn');
  //   showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return const Dialog(
  //         backgroundColor: Colors.transparent, // Make background transparent
  //         child: SpotLight3DialogueBox(),
  //       );
  //     },
  //   ).then((_) {
  //     spotLightOn.value = false;
  //     Get.log('spot light dismissed : $spotLightOn');
  //   });
  // }

  increaseSpotLightIndex({required int index}) {
    spotLightIndex.value = index;
    if (spotLightIndex.value == 1) {
      // show second spotlight
      Future.delayed(const Duration(milliseconds: 200), () {
        // showOnBoarding2SpotLight();
      });
    } else if (spotLightIndex.value == 2) {
      //show third spotlight
      Future.delayed(const Duration(milliseconds: 200), () {
        // showOnBoarding3SpotLight();
      });
    }
  }

  decreaseSpotLightIndex() {
    if (spotLightIndex.value == 0) {
    } else {
      spotLightIndex.value--;
    }
  }
}
