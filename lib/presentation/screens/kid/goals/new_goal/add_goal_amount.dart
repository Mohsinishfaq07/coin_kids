import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart' show ToastUtil;
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddGoalAmountScreen extends GetView<KidGoalsController> {
  const AddGoalAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(
              image: AssetImage(
                Assets.kidBg,
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 40.h),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How much does it cost 💸',
                    style: AppTextStyle.headingLarge,
                  ),
                  SizedBox(height: 20.h),
                  KidTextField(
                    hintText: 0.toMoneyFormat(),
                    onChange: (value) {
                      double? parsedValue = double.tryParse(value);

                      controller.setAmount(parsedValue ?? 0.0);
                    },
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 32.w, bottom: 12.h),
              child: Align(
                alignment: Alignment.bottomRight,
                child: KidButton(
                  onTap: () {
                    if (controller.newGoal.value.targetAmount == 0.0) {
                      ToastUtil.showToast('Goal Amount Could Not be empty');
                    } else {
                      Get.toNamed(Routes.kidAddGoalImage);
                    }
                  },
                  baseColor: AppColors.btnColorGreen,
                  text: "Next",
                  iconPath: Assets.icNext,
                  iconPosition: IconPosition.right,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
