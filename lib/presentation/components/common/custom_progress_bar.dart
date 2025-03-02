import 'dart:ui';

import 'package:coin_kids/core/extention/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;
  final double currentValue;
  final double totalValue;
  final double height;
  final String dotIndicatorPath;
  final String flagIconPath;

  const CustomProgressBar({
    Key? key,
    required this.progress,
    required this.currentValue,
    required this.totalValue,
    this.height = 12,
    this.dotIndicatorPath = 'assets/dot_indicator.svg',
    this.flagIconPath = 'assets/flag.svg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final dotSize = 22.h;
        final verticalOffset = (dotSize - height.h) / 2;

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              progress >= 1.0
                  ? Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset(
                        flagIconPath,
                        height: 24.h,
                        width: 24.w,
                      ),
                    )
                  : Text(
                      '${totalValue.toMoneyFormat()}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
              SizedBox(height: 8.h),
              Container(
                child: Stack(
                  children: [
                    // Progress Bar
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: verticalOffset),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Background Bar
                          Container(
                            height: height.h,
                            width: maxWidth,
                            decoration: BoxDecoration(
                              color: AppColors.buttonPrimary.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(height.h / 2),
                            ),
                          ),

                          // Progress Fill
                          FractionallySizedBox(
                            widthFactor: progress.clamp(0.0, 1.0),
                            child: Container(
                              height: height.h,
                              decoration: BoxDecoration(
                                color: AppColors.buttonPrimary,
                                borderRadius: BorderRadius.circular(height.h / 2),
                              ),
                            ),
                          ),

                          // Milestone Lines at exact positions
                          Positioned(
                            left: maxWidth * 0.25,
                            child: _buildMilestoneLine(),
                          ),
                          Positioned(
                            left: maxWidth * 0.5,
                            child: _buildMilestoneLine(),
                          ),
                          Positioned(
                            left: maxWidth * 0.75,
                            child: _buildMilestoneLine(),
                          ),

                          // Current Value Indicator
                          if (progress > 0 && progress < 1.0)
                            Positioned(
                              left: (maxWidth * progress) - (dotSize / 2),
                              top: -verticalOffset,
                              child: SvgPicture.asset(
                                dotIndicatorPath,
                                height: dotSize,
                                width: dotSize,
                              ),
                            ), // Current Value Indicator

                          if (progress > 0 && progress < 1.0)
                            Positioned(
                              left: (maxWidth * progress) - ((dotSize + 20) / 2),
                              top: -verticalOffset + dotSize,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)), color: AppColors.buttonSecondary),
                                child: Text(
                                  '€${currentValue.toStringAsFixed(0)}',
                                  style: AppTextStyle.bodySmall.copyWith(color: AppColors.iconPrimary, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMilestoneLine() {
    return Container(
      height: height.h,
      width: 2.w,
      child: CustomPaint(
        painter: DottedLinePainter(
          color: Colors.orange,
          dotSize: 2.h,
          spacing: 2.h,
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotSize;
  final double spacing;

  DottedLinePainter({
    required this.color,
    required this.dotSize,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dotSize
      ..strokeCap = StrokeCap.square;

    double currentY = 2;
    while (currentY < size.height) {
      canvas.drawPoints(
        PointMode.points,
        [Offset(size.width / 2, currentY)],
        paint,
      );
      currentY += dotSize + spacing;
    }
  }

  @override
  bool shouldRepaint(DottedLinePainter oldDelegate) => color != oldDelegate.color || dotSize != oldDelegate.dotSize || spacing != oldDelegate.spacing;
}
