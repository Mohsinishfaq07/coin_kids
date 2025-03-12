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
    Key? key,
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
  }) : super(key: key);

  String _getJarAsset() {
    switch (jarState) {
      case JarState.null_jar:
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

  @override
  Widget build(BuildContext context) {
    double width = height * 0.8;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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

            // Amount Display with fixed width and marquee
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
                      final textStyle = AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      );

                      // Check if text would overflow
                      final textPainter = TextPainter(
                        text: TextSpan(text: text, style: textStyle),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: double.infinity);

                      final wouldOverflow = textPainter.width > constraints.maxWidth;

                      return SizedBox(
                        height: moneyTextBoxSize.toDouble(),
                        width: constraints.maxWidth,
                        child: wouldOverflow
                            ? Marquee(
                                text: text,
                                style: textStyle,
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                blankSpace: 20,
                                velocity: 30.0,
                                accelerationDuration: const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              )
                            : Text(
                                text,
                                style: textStyle,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                    // Tag background
                    SvgPicture.asset(
                      Assets.jarTag,
                      width: tagWidth ?? width * 0.9,
                    ),

                    // Jar name text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        jarName,
                        style: textStyle ??
                            AppTextStyle.bodyMedium.copyWith(
                              color: textColor ?? AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
