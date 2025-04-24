import 'package:auto_size_text/auto_size_text.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum IconPosition { left, right, center }

class KidButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;
  final Color baseColor;
  final Color? iconColor;
  final String? iconPath;
  final IconPosition iconPosition;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool showShadowOverlay;
  final double? iconSize;
  final bool showTitleBelow;
  final double? titleSpacing;
  final TextStyle? textStyle;
  final TextStyle? belowTextStyle;
  final double? maxWidth;

  const KidButton({
    super.key,
    required this.onTap,
    this.text,
    required this.baseColor,
    this.iconPath,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height = 64,
    this.fontSize,
    this.showShadowOverlay = true,
    this.iconSize,
    this.showTitleBelow = false,
    this.titleSpacing,
    this.textStyle,
    this.belowTextStyle,
    this.maxWidth = 300,
    this.iconColor,
  });

  // Factory constructor for icon-only button
  factory KidButton.iconOnly({
    Key? key,
    required VoidCallback onTap,
    required Color baseColor,
    Color? iconColor,
    required String iconPath,
    double size = 50,
    bool showShadowOverlay = true,
    double? iconSize = 30,
  }) {
    return KidButton(
      key: key,
      onTap: onTap,
      baseColor: baseColor,
      iconPath: iconPath,
      iconPosition: IconPosition.center,
      width: size,
      height: size,
      iconColor: iconColor,
      showShadowOverlay: showShadowOverlay,
      iconSize: iconSize ?? (size * 0.5),
    );
  }

  // New factory constructor for icon with title below
  factory KidButton.iconWithTitle({
    Key? key,
    required VoidCallback onTap,
    required Color baseColor,
    Color? iconColor,
    required String iconPath,
    required String title,
    double size = 60,
    double? iconSize,
    double? fontSize,
    double titleSpacing = 8,
    bool showShadowOverlay = true,
    TextStyle? belowTextStyle,
  }) {
    return KidButton(
      key: key,
      onTap: onTap,
      baseColor: baseColor,
      iconPath: iconPath,
      text: title,
      iconPosition: IconPosition.center,
      width: size,
      height: size,
      iconColor: iconColor,
      showShadowOverlay: showShadowOverlay,
      iconSize: iconSize ?? (size * 0.5),
      showTitleBelow: true,
      fontSize: fontSize ?? 14,
      titleSpacing: titleSpacing,
      belowTextStyle: belowTextStyle,
    );
  }

  Color _getDarkerShade(Color color) {
    final HSLColor hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    if (showTitleBelow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(true),
          SizedBox(height: titleSpacing ?? 8),
          if (text != null)
            Text(
              text!,
              style: belowTextStyle ??
                  AppTextStyle.bodySmall.copyWith(
                    fontSize: fontSize,
                    color: baseColor,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
        ],
      );
    }
    return _buildButton(text == null);
  }

  Widget _buildButton(bool isIconOnly) {
    final borderColor = _getDarkerShade(baseColor);

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate text width with padding buffer
          final TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: text ?? '',
              style: textStyle ??
                  AppTextStyle.headingMedium.copyWith(
                    color: Colors.white,
                    fontSize: fontSize ?? 22.sp,
                  ),
            ),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: double.infinity);

          // Calculate icon width if present
          double iconWidth = 0;
          if (iconPath != null) {
            iconWidth = (iconSize ?? (height! * 0.375)) + 8; // Icon + spacing
          }

          // Calculate total content width with proper padding
          double contentWidth = textPainter.width + iconWidth + 32; // Increased horizontal padding

          // Add extra buffer for text rendering
          if (text != null) {
            contentWidth += 18.w; // Additional buffer for text
          }

          // Determine final width based on the three cases:
          double finalWidth;

          if (width != null) {
            // Case 2: Fixed width provided
            finalWidth = width!;
          } else if (maxWidth != null && contentWidth > maxWidth!) {
            // Case 3: Content exceeds maxWidth
            finalWidth = maxWidth!;
          } else {
            // Case 1: Content-based width with proper padding
            finalWidth = contentWidth;
          }

          return Container(
            width: finalWidth,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: baseColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 2.22.w,
                  color: borderColor,
                ),
                borderRadius: BorderRadius.circular(isIconOnly ? finalWidth / 2 : 14),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isIconOnly ? 2 : 16, // Increased padding
                    ),
                    child: Row(
                      mainAxisAlignment: _getMainAxisAlignment(),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _buildContent(isIconOnly, finalWidth),
                    ),
                  ),
                ),
                if (showShadowOverlay)
                  Positioned(
                    left: 1.w,
                    top: 1.2.h,
                    child: Image.asset(
                      Assets.icShine,
                      height: height! * 0.22.h,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  MainAxisAlignment _getMainAxisAlignment() {
    if (text == null || iconPosition == IconPosition.center) {
      return MainAxisAlignment.center;
    }
    return MainAxisAlignment.center;
  }

  Widget _buildText(bool shouldEllipsize, TextStyle textStyle) {
    if (width != null) {
      return Flexible(
        child: AutoSizeText(
          text!,
          style: textStyle,
          maxLines: 1,
          textAlign: TextAlign.center,
          minFontSize: 10,
          maxFontSize: fontSize?.toDouble() ?? 22,
          stepGranularity: 0.5,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Expanded(
      child: Text(
        text!,
        style: textStyle,
        overflow: shouldEllipsize ? TextOverflow.ellipsis : TextOverflow.visible,
        softWrap: !shouldEllipsize,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildContent(bool isIconOnly, double containerWidth) {
    if (isIconOnly && iconPath != null) {
      return [_buildIcon(isIconOnly)];
    }

    final List<Widget> widgets = [];
    final mTextStyle = textStyle ??
        AppTextStyle.headingMedium.copyWith(
          color: Colors.white,
          fontSize: fontSize ?? 22.sp,
        );

    final double spacing = 4.w;

    if (iconPath != null && (iconPosition == IconPosition.left || iconPosition == IconPosition.center)) {
      widgets.add(_buildIcon(isIconOnly));
      widgets.add(SizedBox(width: spacing));
    }

    if (text != null) {
      final bool shouldEllipsize = maxWidth != null && containerWidth >= maxWidth!;
      widgets.add(_buildText(shouldEllipsize, mTextStyle));
    }

    if (iconPath != null && iconPosition == IconPosition.right) {
      widgets.add(SizedBox(width: spacing));
      widgets.add(_buildIcon(isIconOnly));
    }

    return widgets;
  }

  Widget _buildIcon(bool isIconOnly) {
    final double iconHeight = iconSize ?? (isIconOnly ? height! * 0.5 : height! * 0.375);

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          if (isIconOnly)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(2, 4),
            ),
        ],
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        iconPath!,
        fit: BoxFit.cover,
        height: iconHeight,
        colorFilter: iconColor == null ? null : ColorFilter.mode(iconColor!, BlendMode.srcIn),
      ),
    );
  }
}

// Regular button with text and icon
// KidButton(
//   onTap: () {},
//   text: 'Next',
//   baseColor: AppColors.colorPrimary,
//   iconPath: AppAssets.arrowRight,
//   iconPosition: IconPosition.right,
// );

// Regular button with text and icon
// KidButton(
//   onTap: () {},
//   text: 'Next',
//   baseColor: AppColors.colorPrimary,
//   iconPath: AppAssets.arrowRight,
//   iconPosition: IconPosition.left,
// );

// // Icon-only button using factory constructor
// KidButton.iconOnly(
//   onTap: () {},
//   baseColor: AppColors.colorPrimary,
//   iconPath: AppAssets.homeIcon,
//   size: 40,
// );

// // Icon-only button using regular constructor
// KidButton(
//   onTap: () {},
//   baseColor: AppColors.colorPrimary,
//   iconPath: AppAssets.homeIcon,
//   width: 40,
//   height: 40,
//   iconPosition: IconPosition.center,
// );

// /**/Using custom text styles
// KidButton.iconWithTitle(
// onTap: () {},
// baseColor: AppColors.colorPrimary,
// iconPath: 'assets/notes.svg',
// title: 'Bills',
// size: 60,
// belowTextStyle: AppTextStyle.headingSmall.copyWith(
// color: AppColors.colorPrimary,
// fontWeight: FontWeight.w700,
// ),
// );
//
// // Regular button with custom text style
// KidButton(
// onTap: () {},
// text: 'Next',
// baseColor: AppColors.colorPrimary,
// textStyle: AppTextStyle.bodyLarge.copyWith(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// ),
// );
//
// // For money type selector with custom styling
// KidButton.iconWithTitle(
// onTap: () => controller.isShowingBills.value = true,
// baseColor: controller.isShowingBills.value
// ? AppColors.colorPrimary
//     : AppColors.iconDisabled,
// iconPath: "assets/notes.svg",
// title: "Bills",
// size: 60.w,
// belowTextStyle: AppTextStyle.headingSmall.copyWith(
// color: controller.isShowingBills.value
// ? AppColors.colorPrimary
//     : AppColors.iconDisabled,
// fontWeight: FontWeight.w600,
// ),
// );
