import 'package:avatar_glow/avatar_glow.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddMoneyScreen extends StatelessWidget {
  AddMoneyScreen({super.key});
  final ButtonController buttonController = Get.put(ButtonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(
            image: AssetImage(AppAssets.kidSectionBG),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        kidBackButton(
                          onTap: () {
                            Get.back();
                          },
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "Add money",
                          style: AppTextStyle.headingLarge,
                        )
                      ]),
                      cardContainerIcon(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          buttonController.clickedIndex.value == 0;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AvatarGlow(
                            // curve: Curves.fastOutSlowIn,
                            startDelay: const Duration(seconds: 1),
                            repeat: true,
                            glowCount: 2,
                            glowShape: BoxShape.circle,
                            animate: true,
                            duration: Duration(seconds: 1),
                            glowColor: Colors.purple,
                            child: SvgPicture.asset(
                              "assets/notes.svg",
                              height: 30.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          buttonController.clickedIndex.value == 1;
                        },
                        child: AvatarGlow(
                          startDelay: const Duration(seconds: 1),
                          repeat: true,
                          glowCount: 2,
                          glowShape: BoxShape.circle,
                          animate: true,
                          duration: Duration(seconds: 1),
                          glowColor: Colors.purple,
                          child: SvgPicture.asset(
                            "assets/Coin.svg",
                            height: 30.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    // Dynamically display widget based on button click
                    if (buttonController.clickedIndex.value == 0) {
                      return Expanded(
                        child: GridView.builder(
                          // padding: EdgeInsets.symmetric(horizontal: 10.w),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            childAspectRatio: 5,
                            crossAxisSpacing: 8.0, // Space between columns
                            mainAxisSpacing: 8.0, // Space between rows
                          ),
                          itemCount: buttonController.notesList.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              buttonController.notesList[index],
                              width: 50.w,
                              height: 50.h,
                            );
                          },
                        ),
                      );
                    } else if (buttonController.clickedIndex.value == 1) {
                      return Container(
                        color: Colors.blue,
                        padding: EdgeInsets.all(20.r),
                        child: const Text(
                          "Coin Widget",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      );
                    } else {
                      return const Text(
                        "Click a button",
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      );
                    }
                  }),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9E29),
                              borderRadius: BorderRadius.circular(
                                  30.r), // Rounded corners
                              border: Border.all(
                                width: 2.22.w,
                                color: const Color(0xFFD67513),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 12.w,
                                  right: 12.w,
                                  top: 4.h,
                                  bottom: 4.h,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .transparent, // Background color (optional)
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color
                                            blurRadius:
                                                10, // Blur radius for the shadow
                                            offset: const Offset(
                                                2, 4), // Shadow position (x, y)
                                          ),
                                        ],
                                        shape: BoxShape
                                            .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/undo.svg",
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 0.5,
                                    top: 0.29,
                                    child: Image.asset(
                                      "assets/Button_shadow.png",
                                      height: 8.h,
                                    )),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        "undo",
                        style: AppTextStyle.bodyLarge,
                      )
                    ],
                  ),
                  Text("E 💸💰", style: AppTextStyle.headingLarge),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w, top: 16.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 120.w,
                      height: 32.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF19B859),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2.22.w, color: const Color(0xFF0E9454)),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20.w,
                            right: 12.w,
                            top: 4.h,
                            bottom: 4.h,
                            child: Row(
                              children: [
                                Text(
                                  "Next",
                                  style: AppTextStyle.headingMedium.copyWith(
                                      color: AppColors.textOnPrimary,
                                      fontSize: 22.sp),
                                ),
                                SizedBox(width: 12.w),
                                Center(
                                  child: SvgPicture.asset(
                                    "assets/arrorDirectionNoShadow.svg",
                                    height: 12.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 1,
                            top: 1.29,
                            child: Image.asset(
                              "assets/Button_shadow.png",
                              height: 10.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // card container icon
  cardContainerIcon() {
    return SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 28.w, top: 4.h),
            child: Container(
              height: 19.h,
              width: 96.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(14.r),
                ),
                border: Border.all(color: AppColors.textPrimary, width: 2.w),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                ),
                child: Text(
                  "€00",
                  style: AppTextStyle.headingMedium
                      .copyWith(color: AppColors.textOnPrimary),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0.w,
            child: Container(
              color: Colors.transparent,
              height: 25.h,
              // width: 80.w,
              child: SvgPicture.asset(AppAssets.kidCardICon, height: 25.h),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonController extends GetxController {
  var clickedIndex = 0.obs; // Observable for the text

  final List<String> notesList = [
    "assets/note5.png",
    "assets/note10.png",
    "assets/note20.png",
    "assets/note50.png",
    "assets/note100.png",
    "assets/note200.png"
  ];
  final List<String> coinList = [
    "assets/1euro.png",
    "assets/2euros.png",
    "assets/50cents-1.png",
    "assets/50cents-2.png",
    "assets/50cents-3.png",
    "assets/50cents-4.png",
    "assets/50cents-5.png",
    "assets/50cents.png",
  ];
}
