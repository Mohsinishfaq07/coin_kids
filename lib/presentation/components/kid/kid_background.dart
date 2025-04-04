import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';

class KidBackground extends StatelessWidget {
  final Widget child;

  const KidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration:   BoxDecoration(
        gradient: AppColors.background,
        image: DecorationImage(
          image: AssetImage(Assets.kidBg),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}