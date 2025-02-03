import 'package:coin_kids/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class KidCloseButton extends StatelessWidget {
  final VoidCallback onTap;
  final String svgAsset;
  final double? svgHeight;
  final double? svgWidth;

  const KidCloseButton({
    Key? key,
    required this.onTap,
    this.svgAsset =  AppAssets.kidCrossIcons, // Default SVG icon
    this.svgHeight,
    this.svgWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFFF9E29),
            width: 3.w,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          width: 30.w,
          height: 30.w,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9E29),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              width: 2.22.w,
              color: const Color(0xFFD67513),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 2.w,
                right: 2.w,
                top: 3.h,
                bottom: 1.h,
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
                      svgAsset,
                      height:
                          svgHeight ?? 20.h, // Default height if not provided
                      width: svgWidth ?? 20.w, // Default width if not provided
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.1,
                top: 0.2.h,
                child: Image.asset(
                  "assets/Button_shadow.png",
                  height: 6.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
