import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/screens/kid/goals/new_goal/add_goal_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoGoalsWidget extends StatelessWidget {
  const NoGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'Create a saving goal! 🎯',
                  style: AppTextStyle.headingLarge,
                ),
                SizedBox(height: 18.h),
                KidButton(
                  baseColor: AppColors.btnColorOrange,
                  text: 'Add new Goal',
                  iconPath: Assets.icAdd,
                  iconPosition: IconPosition.left,
                  onTap: () {
                    Get.to(() => AddGoalNameScreen());
                  },
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
