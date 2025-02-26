import 'package:coin_kids/presentation/components/kid/add_goal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:get/get.dart';

import 'goal_name.dart';

class AddGoalWidget extends StatelessWidget {
  const AddGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Text(
                'Create a save goal! 🎯',
                style: AppTextStyle.headingLarge,
              ),
              SizedBox(height: 30.h),
              AddGoalButton(
                onTap: () {
                  Get.to(() => AddGoalName());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
