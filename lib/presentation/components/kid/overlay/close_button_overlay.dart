import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;


class CloseButtonOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? offsetX;
  final double? offsetY;
  final VoidCallback? onComplete;

  const CloseButtonOverlay({
    super.key,
    required this.targetKey,
    required this.onTap,
    this.width,
    this.height,
    this.offsetX,
    this.offsetY,
    this.onComplete,
  });

  @override
  State<CloseButtonOverlay> createState() => _HandPointerOverlayState();
}

class _HandPointerOverlayState extends State<CloseButtonOverlay> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: () {
      widget.onTap(); // <--- this is the main important one
      if (widget.onComplete != null) {
        widget.onComplete!(); // optional if someone passed it
      }},
      // onTap: widget.onComplete!,
      child: SizedBox(
        width: 60.w,
        height: 60.w,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Lottie.asset(
            'assets/new_tap.json',
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
    );
  }
}