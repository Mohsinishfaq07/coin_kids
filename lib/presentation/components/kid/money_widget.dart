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
  final VoidCallback? onCardTap;
  final String? rightIconPath;
  final bool showAddButton;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final double? iconSize;
  final bool isLocked;
  final Key? showcaseKey;
  final bool showSymbol;
  final bool showDecimals;

  const MoneyWidget({
    super.key,
    required this.amount,
    this.onAddTap,
    this.onCardTap,
    this.rightIconPath,
    this.showAddButton = true,
    this.backgroundColor = const Color(0xFF015486),
    this.borderRadius,
    this.iconSize,
    this.isLocked = false,
    this.showcaseKey,
    this.showSymbol = true,
    this.showDecimals = true,
  });

  @override
  Widget build(BuildContext context) {
    final containerHeight = 30.r;
    final defaultIconSize = 28.r;
    final addButtonSize = 24.r;

    Widget moneyCard = SizedBox(
      height: containerHeight,
      child: Stack(
        children: [
          SizedBox(
            height: containerHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: onCardTap,
                  child: Container(
                    height: containerHeight,
                    width: min(100.w, Get.width / 6),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final text = amount.toMoneyFormat(
                          showSymbol: showSymbol,
                          showDecimals: showDecimals,
                        );
                        // final textStyle = AppTextStyle.headingMedium.copyWith(
                        //   color: AppColors.textOnPrimary,
                        // );
                        final textStyle =   Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,fontSize: 18.sp,);

                        final textPainter = TextPainter(
                          text: TextSpan(text: text, style: textStyle),
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: double.infinity);

                        final wouldOverflow =
                            textPainter.width > (constraints.maxWidth - 24.w);

                        return SizedBox(
                          height: containerHeight,
                          width: constraints.maxWidth - 24.w,
                          child: wouldOverflow
                              ? Center(
                                  child: Marquee(
                                    text: text,
                                    style: textStyle,
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    blankSpace: 20.w,
                                    velocity: 30.0,
                                    accelerationDuration:
                                        const Duration(seconds: 1),
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration:
                                        const Duration(milliseconds: 500),
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
                ),
                if (isLocked)
                  Container(
                    height: containerHeight,
                    width: min(100.w, Get.width / 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color(0xff000000).withValues(alpha: 0.7),
                    ),
                    child: Center(
                      child: Image.asset(Assets.icBtnLock),
                    ),
                  ),
                if (rightIconPath != null)
                  Positioned(
                    right: -(iconSize ?? defaultIconSize) / 2,
                    top: (containerHeight / 2) -
                        ((iconSize ?? defaultIconSize) / 2),
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
        ],
      ),
    );

    if (showcaseKey != null) {
      return moneyCard;
    }

    return moneyCard;
  }
}
