import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/base/kid_onboarding_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidAgeScreen extends GetView<KidOnboardingController> {
  const KidAgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KidOnboardingBaseScreen(
      showBackButton: true,
      onBackPressed: () => controller.currentStep.value = OnboardingStep.name,
      title: 'Hi ${controller.name}!',
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left spacer (same width as button)
          Padding(
            padding: EdgeInsets.all(12.w),
            child: SizedBox(width: 120.w),
          ),

          // Center GridView
          Expanded(
            child: Column(
              children: [
                Text(
                  "How old are you?",
                  style: AppTextStyle.headingMedium,
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = 50.w;
                      final availableWidth = constraints.maxWidth;
                      final crossAxisCount = (availableWidth / (itemWidth + 16.w)).floor();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 1,
                        ),
                        itemCount: controller.ageList.length,
                        itemBuilder: (context, index) => _buildAgeOption(controller.ageList[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: KidButton(
              onTap: () async {
                // Track age step completion
                await controller.analytics.buttonClicked(AnalyticsEventNames.kidOnBoardingAgeStepsClicked,AnalyticsScreenNames.kidOnboardingAgeScreen,);

                // await controller.analytics.logOnboardingStepComplete('age', parameters: {
                //   'selected_age': controller.selectedAge.toString(),
                // });
                controller.proceedToAvatar();
              },
              text: 'Next',
              baseColor: AppColors.btnColorGreen,
              iconPath: Assets.icNext,
              iconPosition: IconPosition.right,
              // width: 120.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeOption(String age) {
    return Obx(() {
      final isSelected = controller.selectedAge.toString() == age || (age == '14+' && controller.selectedAge >= 14);

      return GestureDetector(
        onTap: () => controller.setAge(age),
        child: Container(
          height: 70.h,
          width: 70.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.colorPrimary : Colors.white,
            border: Border.all(
              color: AppColors.colorPrimary,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              age,
              style: AppTextStyle.headingMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      );
    });
  }
}
