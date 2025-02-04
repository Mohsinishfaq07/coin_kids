import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/add_goal_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:get/get.dart';

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
