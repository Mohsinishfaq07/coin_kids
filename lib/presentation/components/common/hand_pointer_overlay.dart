import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HandPointerOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? offsetX;
  final double? offsetY;

  const HandPointerOverlay({
    super.key,
    required this.targetKey,
    required this.onTap,
    this.width,
    this.height,
    this.offsetX,
    this.offsetY,
  });

  @override
  State<HandPointerOverlay> createState() => _HandPointerOverlayState();
}

class _HandPointerOverlayState extends State<HandPointerOverlay> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 60.w,
      height: widget.height ?? 60.w,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Lottie.asset(
          'assets/new_tap.json',
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
} 