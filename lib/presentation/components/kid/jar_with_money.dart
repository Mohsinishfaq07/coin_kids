import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';

class JarWithMoneyTitle extends StatelessWidget {
  final String JarTitle;
  final double amount;
  final String color;

  const JarWithMoneyTitle({
    required this.JarTitle,
    required this.color,
    super.key,
    required this.amount,
  });

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", ""); // Remove the "#" if present
    return Color(int.parse(
        "0xFF$hex")); // Add the alpha value 'FF' to make it fully opaque
  }

  @override
  Widget build(BuildContext context) {
    Color jarColor = hexToColor(color);
    String amountText = '$amount€'; // Convert to String for length check

    // Calculate text width
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: amountText,
        style: TextStyle(
          fontSize: 15.83.sp,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double textWidth = textPainter.width; // Actual text width
    double containerWidth = 90.w; // Container width
    double allowedWidth = containerWidth - 6.w; // Allowed text width

    return Stack(
      children: [
        SvgPicture.asset(
          AppAssets.jarBackgroundSvg,
          color: jarColor,
          height: 100.h,
          width: 138.w,
        ),
        Image.asset(
          AppAssets.jarOutLinePng,
          height: 100.h,
          width: 140.w,
          color: Colors.white,
        ),
        Positioned(
          bottom: 36.h,
          left: 20.w,
          right: 0.w,
          child: Text(
            JarTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.iconPrimaryVariant,
              fontSize: 18.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w800,
              height: 2.44,
            ),
          ),
        ),
        Positioned(
          bottom: 0.h,
          left: 26.w,
          child: Center(
            child: Container(
              width: containerWidth,
              height: 16.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.53.w, color: jarColor),
                  borderRadius: BorderRadius.circular(51.33.r),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F6169D3),
                    blurRadius: 2.60,
                    offset: Offset(-1.30, 1.95),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: textWidth > allowedWidth
                  ? Marquee(
                      text: amountText,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                      velocity: 10.0,
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      pauseAfterRound: Duration(seconds: 1),
                      blankSpace: 7 * 15.83.sp * 0.6,
                      style: TextStyle(
                        color: jarColor,
                        fontSize: 15.83.sp,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : Text(
                      amountText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.iconPrimaryVariant,
                        fontSize: 15.83.sp,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
