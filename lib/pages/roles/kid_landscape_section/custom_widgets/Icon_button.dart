import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const CustomIconButton({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          kidBackButton(
            buttonHeight: 26.h,
            buttonWidth: 26.h,
            backgroundColor: AppColors.buttonPrimary,
            borderColor: AppColors.buttonPrimary,
            svgAsset: iconPath,
            iconColor: Colors.white,
            svgHeight: 40.h,
            onTap: onTap,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            label,
            style: AppTextStyle.headingSmall,
          ),
        ],
      ),
    );
  }
}
