import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget kidBackButton({
  required Function() onTap,
  String svgAsset = "assets/backButton.svg", // Default SVG
  double? svgHeight, // Optional custom height
  double? svgWidth,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFFF9E29),
        borderRadius: BorderRadius.circular(30.r), // Rounded corners
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
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(2, 4),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  svgAsset, // Uses default or user-provided SVG
                  height:
                      svgHeight ?? 10.h, // Use default height if not provided
                  width: svgWidth ?? 10.w,
                  fit: BoxFit.contain,
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
            ),
          ),
        ],
      ),
    ),
  );
}
