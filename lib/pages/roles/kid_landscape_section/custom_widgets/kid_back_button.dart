import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

kidBackButton({required Function() onTap}) {
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
                    color: Colors.transparent, // Background color (optional)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 10, // Blur radius for the shadow
                        offset: Offset(2, 4), // Shadow position (x, y)
                      ),
                    ],
                    shape: BoxShape
                        .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                  ),
                  child: SvgPicture.asset(
                    "assets/backButton.svg",

                    height: 10.h,
                    width: 10.w,
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
      ));
}
