import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
    return GestureDetector(
      onTapDown: (_) => widget.onComplete(),
      child: Stack(
        children: [
          // Semi-transparent overlay with darker background
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.black.withOpacity(0.75), // Darker background


            ),
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Text(
                'Check your wishlist here!',
                textAlign: TextAlign.center,
                style: AppTextStyle.headingMedium.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                ),
              ),
            ),
          ),

          // Hand pointer animation positioned for the wishlist button
          Positioned(
            right: -10.w,
            top: 0.10.sh,
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
    );
  }
} 