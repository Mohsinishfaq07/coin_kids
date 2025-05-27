import 'dart:math';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:avatar_glow/avatar_glow.dart';

class PulsingAddButton extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;
  final bool showAnimation;

  const PulsingAddButton({
    super.key,
    required this.size,
    required this.showAnimation,
    this.onTap,
  });

  @override
  State<PulsingAddButton> createState() => _PulsingAddButtonState();
}

class _PulsingAddButtonState extends State<PulsingAddButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    if (widget.showAnimation) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulsingAddButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showAnimation != oldWidget.showAnimation) {
      if (widget.showAnimation) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.showAnimation ? _animation.value : 1.0,
            child: child,
          );
        },
        child: SvgPicture.asset(
          Assets.icAddIcon,
          height: widget.size,
          width: widget.size,
        ),
      ),
    );
  }
}

class MoneyWidget extends StatelessWidget {
  static final _scaleNotifier = ValueNotifier<double>(1.0);
  
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
  final bool showGlowAnimation;

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
    this.showGlowAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final containerHeight = 30.r;
    final defaultIconSize = 28.r;
    final addButtonSize = 24.r;

    return SizedBox(
      // height: containerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildMainContent(containerHeight, defaultIconSize),
          if (showAddButton && onAddTap != null)
            Positioned(
              left: -addButtonSize / 2,
              top: (containerHeight / 2) - (addButtonSize / 2),
              child: showGlowAnimation 
                ? AvatarGlow(
                    glowColor: AppColors.btnColorGreen,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    animate: true,
                    startDelay: Duration(seconds: 1),
                    child: _buildAddButton(addButtonSize),
                  )
                : _buildAddButton(addButtonSize),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(double size) {
    return PulsingAddButton(
      size: size,
      onTap: onAddTap,
      showAnimation: showGlowAnimation,
    );
  }

  static bool _isPressed = false;

  Widget _buildMainContent(double containerHeight, double defaultIconSize) {
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
                    width: min(110.w, Get.width / 6),
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
                        final textStyle = Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: AppColors.textOnPrimary,
                              fontSize: 18.sp,
                            );

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
