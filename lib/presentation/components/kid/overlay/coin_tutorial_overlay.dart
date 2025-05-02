import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CoinTutorialOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final VoidCallback onComplete;

  const CoinTutorialOverlay({
    super.key,
    required this.targetKey,
    required this.onComplete,
  });

  @override
  State<CoinTutorialOverlay> createState() => _CoinTutorialOverlayState();
}

class _CoinTutorialOverlayState extends State<CoinTutorialOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onComplete,
      //  onTapDown: (_) => widget.onComplete(),
        child: SizedBox(
          width: Get.width,
          height: Get.height,
      //    color: Colors.black.withOpacity(0.75),
          child: Stack(
            children: [
              // Hand pointer animation positioned at the left side
              Positioned(
                left: 54.w,
                top: Get.height * 0.50,
                child: SizedBox(
                  width: 80.w,
                  height: 80.w,
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
      ),
    );
  }
} 