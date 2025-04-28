import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

class MarketWishlistTutorialOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final VoidCallback onComplete;

  const MarketWishlistTutorialOverlay({
    super.key,
    required this.targetKey,
    required this.onComplete,
  });

  @override
  State<MarketWishlistTutorialOverlay> createState() => _MarketWishlistTutorialOverlayState();
}

class _MarketWishlistTutorialOverlayState extends State<MarketWishlistTutorialOverlay> {
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
          //color: Colors.black.withOpacity(0.75),
          child: Stack(
            children: [
              Positioned(
                right: -0.w,
                top: 0.10.sh,
              //  bottom: Get.height * 0.32,
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: AppColors.buttonPrimary,

                            borderRadius: BorderRadius.circular(16)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(" Check your wishlist here! ",style: AppTextStyle.headingMedium.copyWith(color: Colors.white),),
                        )),
                    SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child: Transform(
                        alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
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
            ],
          ),
        ),
      ),
    );

  }
} 