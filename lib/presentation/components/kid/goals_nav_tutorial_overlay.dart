import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class GoalsNavTutorialOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final VoidCallback onComplete;

  const GoalsNavTutorialOverlay({
    super.key,
    required this.targetKey,
    required this.onComplete,
  });

  @override
  State<GoalsNavTutorialOverlay> createState() => _GoalsNavTutorialOverlayState();
}

class _GoalsNavTutorialOverlayState extends State<GoalsNavTutorialOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onComplete,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: Get.width,
          height: Get.height,
          color: Colors.black.withOpacity(0.75),
          child: Stack(
            children: [
              Positioned(
                left: 30.w,
                bottom: Get.height * 0.35,
                child: Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child: Lottie.asset(
                        'assets/new_tap.json',
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                    Text(" <<< Tap to add the  Goals  ",style: AppTextStyle.headingLarge.copyWith(color: AppColors.cardBorder),)
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