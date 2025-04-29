import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class GoalsAddTutorialOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final VoidCallback onComplete;

  const GoalsAddTutorialOverlay({
    super.key,
    required this.targetKey,
    required this.onComplete,
  });

  @override
  State<GoalsAddTutorialOverlay> createState() => _GoalsAddTutorialOverlayState();
}

class _GoalsAddTutorialOverlayState extends State<GoalsAddTutorialOverlay> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTapDown: (_) => widget.onComplete(),
        child: Stack(
          children: [
            // Semi-transparent overlay with darker background
            Container(margin:EdgeInsets.all( 20.h) ,
              padding: EdgeInsets.all( 20.h) ,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
               // color: Colors.black.withOpacity(0.15), // Darker background

              ),
              child: Text(
                '',
                textAlign: TextAlign.center,
                style: AppTextStyle.headingMedium.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                ),
              ),
            ),

            // Hand pointer animation
            Positioned(
              bottom: 70.h,

              left: 40.w,
              right: 10.w,
              child: SizedBox(
                width: 60.w,
                height: 60.w,
                child: Lottie.asset(
                  'assets/new_tap.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 