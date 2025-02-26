import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/theme/color_theme.dart';

class AppShowCaseWidget extends StatelessWidget {
  final GlobalKey showcaseKey;
  final Widget child;
  final String description;
  final VoidCallback? onTargetClick;
  final double? height;
  final double? width;
  final String backgroundImage;
  final TooltipPosition tooltipPosition;
  final bool disposeOnTap;
  final bool disableDefaultTargetGestures;

  const AppShowCaseWidget({
    super.key,
    required this.showcaseKey,
    required this.child,
    required this.description,
    this.onTargetClick,
    this.height = 90,
    this.width = 300,
    this.backgroundImage =
        "assets/center_spot_light_background.png", // Default image
    this.tooltipPosition = TooltipPosition.top,
    this.disposeOnTap = false,
    this.disableDefaultTargetGestures = false,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: showcaseKey,
      targetShapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      tooltipPosition: tooltipPosition,
      disableBarrierInteraction: true,
      disposeOnTap: disposeOnTap,
      onTargetClick: onTargetClick,
      enableAutoScroll: true,
      targetPadding: EdgeInsets.all(12),
      disableDefaultTargetGestures: disableDefaultTargetGestures,
      container: Container(
        alignment: Alignment.center,
        width: width?.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Positioned(

              top: 20.h,


              child: Center(
                child: Text(
                  description,
                  style: AppTextStyle.headingMedium.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      height: height?.h,
      width: width?.w,
      overlayColor: Colors.black.withOpacity(0.5),
      overlayOpacity: 0.5,
      child: child,
    );
  }
}
