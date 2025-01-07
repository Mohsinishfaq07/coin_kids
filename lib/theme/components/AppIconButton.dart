import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//USAGE
// AppIconButton(
//                                   onPressed: () {
//                                     print("Button Pressed");
//                                   },
//                                   icon: const Icon(Icons.arrow_forward_rounded),
//                                   outerShadowColor: Colors.black.withOpacity(0.3),
//                                   outerShadowOffset: const Offset(0, 3),
//                                   outerBlurRadius: 4.0,
//                                   innerShadowColor: Colors.black.withOpacity(0.3),
//                                   innerShadowOffset: const Offset(0, -2),
//                                   innerBlurRadius: 3,
//                                 ),

class AppIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color backgroundColor;
  final Color foregroundColor;

  // Outer Shadow Properties
  final Color outerShadowColor;
  final Offset outerShadowOffset;
  final double outerBlurRadius;

  // Inner Shadow Properties
  final Color innerShadowColor;
  final Offset innerShadowOffset;
  final double innerBlurRadius;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = AppColors.iconPrimary,
    this.foregroundColor = Colors.white,
    // Outer Shadow Defaults
    this.outerShadowColor = const Color.fromARGB(63, 13, 13, 13),
    this.outerShadowOffset = const Offset(0, 3),
    this.outerBlurRadius = 4,
    // Inner Shadow Defaults
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
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: outerShadowColor,
                blurRadius: outerBlurRadius,
                offset: outerShadowOffset,
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
            style: IconButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
