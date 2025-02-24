import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GreenNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final bool showPrefix;
  final String prefixSvg;
  final bool showSuffix;
  final String suffixSvg;

  const GreenNextButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    this.backgroundColor, // Optional custom background color
    this.borderColor, // Optional custom border color
    this.textColor,
    this.width,
    this.showPrefix = false, // Default: false
    this.prefixSvg = "assets/kidRoleIcons/kidCrossButton.svg",
    this.showSuffix = false,
    this.suffixSvg = "assets/arrorDirectionNoShadow.svg",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 120.w,
        height: 32.h,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor ?? const Color(0xFF19B859),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.22.w,
              color: borderColor ?? const Color(0xFF0E9454),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20.w,
              right: 12.w,
              top: 4.h,
              bottom: 4.h,
              child: Row(
                children: [
                  if (showPrefix)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.transparent, // Background color (optional)
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10, // Blur radius for the shadow
                              offset:
                                  const Offset(2, 4), // Shadow position (x, y)
                            ),
                          ],
                          shape: BoxShape
                              .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                        ),
                        child: SvgPicture.asset(
                          prefixSvg, // Arrow icon asset
                          height: 12.h,
                        ),
                      ),
                    ),
                  if (showPrefix)
                    SizedBox(
                      width: 6.w,
                    ),
                  Text(
                    buttonText,
                    style: AppTextStyle.headingMedium.copyWith(
                      color: textColor ?? AppColors.textOnPrimary,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  if (showSuffix)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.transparent, // Background color (optional)
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10, // Blur radius for the shadow
                              offset:
                                  const Offset(2, 4), // Shadow position (x, y)
                            ),
                          ],
                          shape: BoxShape
                              .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                        ),
                        child: SvgPicture.asset(
                          suffixSvg, // Arrow icon asset
                          height: 12.h,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              left: 1,
              top: 1.29,
              child: Image.asset(
                "assets/button_shadow.png", // Shadow image
                height: 10.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
