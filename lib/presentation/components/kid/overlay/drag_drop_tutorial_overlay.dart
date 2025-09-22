import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DragDropTutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final Offset startPosition;
  final Offset endPosition;

  const DragDropTutorialOverlay({
    super.key,
    required this.onComplete,
    required this.startPosition,
    required this.endPosition,
  });

  @override
  State<DragDropTutorialOverlay> createState() => _DragDropTutorialOverlayState();
}

class _DragDropTutorialOverlayState extends State<DragDropTutorialOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  double _dragAccumulatedDx = 0.0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Forward animation
      reverseDuration: const Duration(milliseconds: 300), // Quick reverse
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInQuad, // Faster reverse animation
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward(); // Continue animation until user taps
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        if (_completed) return;
        _dragAccumulatedDx += details.delta.dx;
        if (_dragAccumulatedDx.abs() > 40) {
          _completed = true;
          widget.onComplete();
        }
      },
      onHorizontalDragEnd: (_) {
        _dragAccumulatedDx = 0.0;
      },
      child: Stack(
        children: [
          // Semi-transparent overlay
          Container(
            width: Get.width,
            height: Get.height,
            color: Colors.black54,
            child: Padding(
              padding: EdgeInsets.only(top: 50.h), // Position at top of screen
              child: Text(
                'Drag the money to the jar!',
                textAlign: TextAlign.center,
                style: AppTextStyle.headingMedium.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                ),
              ),
            ),
          ),

          // Animated hand cursor with coin
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _positionAnimation.value.dx,
                top: _positionAnimation.value.dy,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      Assets.icHand, // Add hand cursor asset
                      width: 80.w,
                      height: 80.w,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
