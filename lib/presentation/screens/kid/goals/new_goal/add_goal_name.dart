import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddGoalNameScreen extends GetView<KidGoalsController> {
  const AddGoalNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.appBar.configureForGoalSetup();
    });

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: 24.w,
          bottom: 24.w,
          left: 24.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KidButton(
              iconPosition: IconPosition.right,
              iconPath: Assets.icNext,
              onTap: () async {
                await controller.analytics.buttonClicked(AnalyticsEventNames.goalNameNextButtonClicked,AnalyticsScreenNames.kidGoalsNameScreen,AnalyticsScreenNames.kidGoalsAmountScreen);

                if (controller.newGoal.value.title.isEmpty) {
                  ToastUtil.showToast('Goal Name Could Not be empty');
                } else {
                  Get.toNamed(Routes.kidAddGoalAmount);
                }
              },
              text: 'Next',
              baseColor: AppColors.btnColorGreen,
            ),
          ],
        ),
      ),
      appBar: KidAppBarComponent(
        onBackPressed: () async{
          await controller.analytics.backPressClicked(AnalyticsScreenNames.kidGoalsNameScreen,AnalyticsScreenNames.kidGoalsScreen);

          controller.appBarController.resetToDefault();
          Get.back();
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(
            image: AssetImage(Assets.kidBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Center(
                  child: Text(
                    'What are you saving for 🎯',
                    style: AppTextStyle.headingLarge,
                  ),
                ),
                SizedBox(height: 30.h),
                KidTextField(
                  keyboardType: TextInputType.name,
                  hintText: "e.g Electric Bike ",
                  onChange: (val) {
                    controller.setTitle(val.trim());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
