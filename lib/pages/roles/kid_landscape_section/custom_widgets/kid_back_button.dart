import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget kidBackButton({
  required Function() onTap,
  String svgAsset = "assets/backButton.svg", // Default SVG
  double? svgHeight, // Optional custom height
  double? svgWidth,
  double? buttonHeight = 40,
  double? buttonWidth = 40,
  Color? backgroundColor = const Color(0xFFFF9E29),
  Color borderColor = const Color(0xFFD67513),
  Color? iconColor = Colors.white,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: buttonWidth,
      height: buttonHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.r), // Rounded corners
        border: Border.all(
          width: 2.22.w,
          color: borderColor,
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
                  color: iconColor,
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
