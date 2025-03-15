import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color foregroundColor;
  final Size? size;
  final Color innerShadowColor;
  final Offset innerShadowOffset;
  final double innerBlurRadius;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.innerShadowColor = const Color.fromARGB(63, 13, 13, 13),
    this.innerShadowOffset = const Offset(0, -2),
    this.innerBlurRadius = 3,
  });

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      shadows: [Shadow(color: innerShadowColor, blurRadius: innerBlurRadius, offset: innerShadowOffset)],
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: size != null
            ? SizedBox(
                height: size?.height.h,
                width: size?.width.w,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: IconButton.styleFrom(
                    backgroundColor: backgroundColor ?? AppColors.colorPrimary,
                    foregroundColor: foregroundColor,
                    elevation: 3,
                  ),
                  child: child,
                ),
              )
            : SizedBox(
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: IconButton.styleFrom(
                    backgroundColor: backgroundColor ?? AppColors.colorPrimary,
                    foregroundColor: foregroundColor,
                    elevation: 3,
                  ),
                  child: child,
                ),
              ),
      ),
    );
  }
}
