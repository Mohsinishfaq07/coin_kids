import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GoalCard extends StatelessWidget {
  final Map<String, dynamic> goal;
  final File? imageFile; // Image File

  GoalCard({required this.goal, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: SizedBox(
        height: 145.h,
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: Color(0xFFEDFAFF),
              ),
              height: 120.h,
              width: 180.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Text(
                          goal['name'] ?? 'No Name',
                          style: AppTextStyle.headingMedium
                              .copyWith(color: AppColors.iconPrimary),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Image Handling
                      imageFile != null
                          ? Container(
                              height: 70.h,
                              width: 60.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(imageFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Icon(Icons.image, size: 60.h, color: Colors.grey),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              "€${goal['amount']}.00",
                              style: AppTextStyle.headingMedium
                                  .copyWith(color: AppColors.iconPrimary),
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                      // Amount
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: -0.4.h,
          //   left: 26.w,
          //   child: Row(
          //     children: [
          //       CustomIconButton(
          //           iconPath: "assets/pencil_svgrepo.com.svg",
          //           label: 'Edit',
          //           onTap: () => Get.to(EditGoal())),
          //       SizedBox(
          //         width: 36.w,
          //       ),
          //       CustomIconButton(
          //         iconPath: "assets/Group 1000005783.svg",
          //         label: 'Delete',
          //         onTap: () {},
          //       ),
          //     ],
          //   ),
          // )
        ]),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const CustomIconButton({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          kidBackButton(
            buttonHeight: 26.h,
            buttonWidth: 26.h,
            backgroundColor: AppColors.buttonPrimary,
            borderColor: Colors.white,
            svgAsset: iconPath,
            iconColor: Colors.white,
            svgHeight: 40.h,
            onTap: () {},
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            label,
            style: AppTextStyle.headingSmall,
          ),
        ],
      ),
    );
  }
}

class SliderController extends GetxController {
  // Declare the slider value as an RxDouble
  var sliderValue = 0.0.obs; // .obs makes it reactive

  // Function to update slider value
  void updateValue(double value) {
    sliderValue.value = value;
  }

  // Function to set the goal amount (max value)
  void setGoalAmount(double amount) {
    // If you want to update slider value to 0 when the goalAmount is set
    sliderValue.value = 0.0;
  }
}

class CustomSlider extends StatelessWidget {
  final SliderController sliderController = Get.put(SliderController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Markers (flags) above the slider
            Positioned(
              top: -25, // Adjust flag position
              left: 30,
              child: SvgPicture.asset('assets/flag_yellow.svg', width: 20),
            ),
            Positioned(
              top: -25,
              left: 150,
              child: SvgPicture.asset('assets/flag_blue.svg', width: 20),
            ),
            Positioned(
              top: -25,
              right: 30,
              child: SvgPicture.asset('assets/flag_green.svg', width: 20),
            ),

            // Slider
            Obx(
              () => SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10, // Increase track size
                  activeTrackColor: Colors.purple,
                  inactiveTrackColor: Colors.pink.shade100,
                  thumbShape: CustomSliderThumb(), // Custom thumb
                ),
                child: Slider(
                  value: sliderController.sliderValue.value,
                  min: 0,
                  max: 100,
                  divisions: 4,
                  onChanged: (double value) {
                    sliderController.updateValue(value);
                  },
                ),
              ),
            ),
          ],
        ),

        // Labels below the slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelBox("€0"),
              LabelBox("€25"),
              LabelBox("€50"),
              LabelBox("€100"),
            ],
          ),
        ),
      ],
    );
  }
}

// 🟡 Custom Thumb with an SVG image
class CustomSliderThumb extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(40, 40); // Adjust thumb size
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw the coin SVG image
    final svgPath = 'assets/coin.svg'; // Use your coin image
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas tempCanvas = Canvas(recorder);
    final ui.Picture picture = recorder.endRecording();

    canvas.drawPicture(picture);
  }
}

// 🟡 Label Box Widget
class LabelBox extends StatelessWidget {
  final String text;
  const LabelBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
