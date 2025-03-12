import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color_theme.dart';

class RotationInstruction extends StatelessWidget {
  final bool toPortrait;

  const RotationInstruction({
    Key? key,
    this.toPortrait = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                toPortrait ? Assets.icRotatePortrait : Assets.icRotateLandscape,
                width: 100.w,
                height: 100.w,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  toPortrait ? 'Please rotate your device to portrait mode' : 'Please rotate your device to landscape mode',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
