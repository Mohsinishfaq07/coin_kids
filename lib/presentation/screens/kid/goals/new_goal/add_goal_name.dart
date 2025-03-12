import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/screens/kid/goals/new_goal/add_goal_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddGoalNameScreen extends GetView<KidGoalsController> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.appBar.configureForGoalSetup();
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: KidAppBarComponent(
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(image: AssetImage(Assets.kidBg), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 40.h),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'What are you saving for 🎯',
                    style: AppTextStyle.headingLarge,
                  ),
                  SizedBox(height: 20.h),
                  KidTextField(
                    keyboardType: TextInputType.name,
                    hintText: "e.g Electric Bike ",
                    onChange: (val) {
                      controller.setTitle(val.trim());
                      print("TITLE IS" + controller.newGoal.value.title);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 32.w, bottom: 12.h),
              child: Align(
                alignment: Alignment.bottomRight,
                child: KidButton(
                  iconPosition: IconPosition.right,
                  iconPath: Assets.icNext,
                  onTap: () async {
                    if (controller.newGoal.value.title.isEmpty) {
                      ToastUtil.showToast('Goal Name Could Not be empty');
                    } else {
                      Get.to(() => AddGoalAmountScreen());
                    }
                  },
                  text: 'Next',
                  baseColor: AppColors.btnColorGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
