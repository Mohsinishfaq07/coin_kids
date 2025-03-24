import 'package:auto_size_text/auto_size_text.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

class JarWidget extends StatelessWidget {
  final JarState jarState;
  final String jarName;
  final double height;
  final VoidCallback? onTap;
  final bool showTag;
  final Color? jarColor;
  final Color? tagColor;
  final Color? textColor;
  final String? colorHex;
  final TextStyle? textStyle;
  final double? tagTopPosition;
  final double? tagWidth;
  final double? amount;
  final bool showAmount;

  final int moneyTextBoxSize = 20;

  const JarWidget({
    super.key,
    required this.jarState,
    required this.jarName,
    this.height = 150,
    this.onTap,
    this.showTag = true,
    this.jarColor,
    this.tagColor,
    this.textColor,
    this.colorHex,
    this.textStyle,
    this.tagTopPosition,
    this.tagWidth,
    this.amount,
    this.showAmount = true,
  });

  String _getJarAsset() {
    switch (jarState) {
      case JarState.nullJar:
        return Assets.jarNull;
      case JarState.empty:
      case JarState.filled:
        return Assets.jarBase;
    }
  }

  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1, 7), radix: 16) + 0xFF000000);
    }
    return Color(int.parse(colorString));
  }

  Color? _getColor(Color? color) {
    return color ?? _parseColor(colorHex);
  }

  // Helper method to ensure font size is multiple of step granularity
  double _adjustFontSize(double fontSize, double stepGranularity) {
    return (fontSize / stepGranularity).floor() * stepGranularity;
  }

  Widget _buildAmountText(String text, TextStyle baseStyle, double containerWidth, double containerHeight) {
    // Calculate if text would fit at minimum size
    final textSpan = TextSpan(
      text: text,
      style: baseStyle.copyWith(fontSize: 8), // Check with minimum font size
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: containerWidth);

    // If text is too long even at minimum size, use marquee
    if (textPainter.width > containerWidth) {
      return SizedBox(
        height: containerHeight,
        width: containerWidth,
        child: Marquee(
          text: text,
          style: baseStyle.copyWith(fontSize: 8),
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          blankSpace: 20.0,
          velocity: 30.0,
          startPadding: 10.0,
          accelerationDuration: const Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: const Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      );
    }

    // Otherwise use AutoSizeText
    return Center(
      child: AutoSizeText(
        text,
        style: baseStyle,
        maxLines: 1,
        minFontSize: 8,
        maxFontSize: _adjustFontSize(baseStyle.fontSize ?? 14, 0.5),
        stepGranularity: 0.5,
        overflow: TextOverflow.visible,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = height * 0.8;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height + moneyTextBoxSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Base Empty Jar
            Image.asset(
              _getJarAsset(),
              width: width,
              height: height,
              color: _getColor(jarColor),
              colorBlendMode: BlendMode.srcIn,
            ),

            Image.asset(
              Assets.jarShadow,
              width: width,
              height: height,
            ),

            // Money Image (only for filled state)
            if (jarState == JarState.filled)
              Positioned(
                bottom: height * 0.20,
                child: Image.asset(
                  Assets.jarMoney,
                  width: width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),

            // Amount Display with auto-sizing text and marquee
            if (showAmount && amount != null)
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  constraints: BoxConstraints(
                    maxWidth: width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.iconPrimaryVariant,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final text = '${amount?.toMoneyFormat(showSymbol: true)}';
                      final baseStyle = AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      );

                      return _buildAmountText(
                        text,
                        baseStyle,
                        constraints.maxWidth,
                        moneyTextBoxSize.toDouble(),
                      );
                    },
                  ),
                ),
              ),

            // Jar Tag with Name
            if (showTag)
              Positioned(
                top: tagTopPosition ?? height * 0.45,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.jarTag,
                      width: tagWidth ?? width * 0.9,
                    ),

                    // Jar name text with auto-sizing and marquee
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: (tagWidth ?? width * 0.9) - 16,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final baseStyle = textStyle ??
                                AppTextStyle.bodyMedium.copyWith(
                                  color: textColor ?? AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                );

                            return _buildAmountText(
                              jarName,
                              baseStyle,
                              constraints.maxWidth,
                              24, // Height for jar name text
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
