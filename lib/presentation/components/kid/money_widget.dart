import 'dart:math';

import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class MoneyWidget extends StatelessWidget {
  final double amount;
  final VoidCallback? onAddTap;
  final String? rightIconPath;
  final bool showAddButton;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final double? iconSize;
  final isLocked;

  const MoneyWidget({
    Key? key,
    required this.amount,
    this.onAddTap,
    this.rightIconPath,
    this.showAddButton = true,
    this.backgroundColor = const Color(0xFF015486),
    this.borderRadius,
    this.iconSize,
    this.isLocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerHeight = 19.h;
    final defaultIconSize = 36.r;
    final addButtonSize = 24.r;

    return Container(
      height: containerHeight,
      child: Stack(
        children: [
          SizedBox(
            height: containerHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: containerHeight,
                  width: min(100.w, Get.width / 6),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final text = amount.toMoneyFormat();
                      final textStyle = AppTextStyle.headingMedium.copyWith(
                        color: AppColors.textOnPrimary,
                      );

                      final textPainter = TextPainter(
                        text: TextSpan(text: text, style: textStyle),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: double.infinity);

                      final wouldOverflow = textPainter.width > (constraints.maxWidth - 24.w);

                      return SizedBox(
                        height: containerHeight,
                        width: constraints.maxWidth - 24.w,
                        child: wouldOverflow
                            ? Center(
                                child: Marquee(
                                  text: text,
                                  style: textStyle,
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 20.w,
                                  velocity: 30.0,
                                  accelerationDuration: const Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration: const Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              )
                            : Center(
                                child: Text(
                                  text,
                                  style: textStyle,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      );
                    },
                  ),
                ),
                if (rightIconPath != null)
                  Positioned(
                    right: -(iconSize ?? defaultIconSize) / 2,
                    top: 0.h,
                    child: SvgPicture.asset(
                      rightIconPath!,
                      height: iconSize ?? defaultIconSize,
                      width: iconSize ?? defaultIconSize,
                    ),
                  ),
                if (showAddButton && onAddTap != null)
                  Positioned(
                    left: -addButtonSize / 2,
                    top: (containerHeight / 2) - (addButtonSize / 2),
                    child: GestureDetector(
                      onTap: onAddTap,
                      child: SvgPicture.asset(
                        Assets.icAddIcon,
                        height: addButtonSize,
                        width: addButtonSize,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isLocked)
            Container(
              height: containerHeight,
              width: min(100.w, Get.width / 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: const Color(0xff000000).withValues(alpha: 0.46)),
            ),
          if (isLocked)
            Positioned(
              left: min(100.w, Get.width / 6) / 2 - 12,
              top: 4,
              child: Center(
                child: SvgPicture.asset(Assets.icLock),
              ),
            )
        ],
      ),
    );
  }
}
