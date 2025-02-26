import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;  
  final Size size;
  final Color innerShadowColor;
  final Offset innerShadowOffset;
  final double innerBlurRadius;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.size = const Size(320, 50),
    this.backgroundColor = AppColors.iconPrimary,
    this.foregroundColor = Colors.white,
    this.innerShadowColor = const Color.fromARGB(63, 13, 13, 13),
    this.innerShadowOffset = const Offset(0, -2),
    this.innerBlurRadius = 3,
  });

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      shadows: [
        Shadow(
            color: innerShadowColor,
            blurRadius: innerBlurRadius,
            offset: innerShadowOffset)
      ],
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: SizedBox(
          height: size.height.h,
          width: size.width.w,
          child: ElevatedButton(
            onPressed: onPressed,
            style: IconButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              elevation: 3,
            ),
            child: Text(
              text,
              style: AppTextStyle.labelLarge,
            ),
          ),
        ),
      ),
    );
  }
}
