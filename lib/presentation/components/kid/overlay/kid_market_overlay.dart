import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;


class KidMarketOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? offsetX;
  final double? offsetY;


  const KidMarketOverlay({
    super.key,
    required this.targetKey,
    required this.onTap,
    this.width,
    this.height,
    this.offsetX,
    this.offsetY,
  });

  @override
  State<KidMarketOverlay> createState() => _HandPointerOverlayState();
}

class _HandPointerOverlayState extends State<KidMarketOverlay> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: widget.onTap,
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