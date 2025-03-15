import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ParentFeedbackScreen extends GetView<ParentFeedbackController> {
  const ParentFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ParentAppBar(
        title: "Feedback",
        centerTitle: false,
        showBackButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Share Your Experience",
                        style: AppTextStyle.headingMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Your feedback helps us improve and provide better service.",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "What would you like to share about?",
                        style: AppTextStyle.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(() => Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: controller.feedbackCategories.map((category) {
                              final isSelected = controller.selectedCategories.contains(category);
                              return GestureDetector(
                                onTap: () => controller.toggleCategory(category),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.buttonPrimary : Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: isSelected ? AppColors.buttonPrimary : AppColors.strokeColor,
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      color: isSelected ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                      SizedBox(height: 24.h),
                      Text(
                        "Your Feedback",
                        style: AppTextStyle.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.strokeColor),
                        ),
                        child: TextField(
                          onChanged: (value) => controller.feedbackText.value = value,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Type your feedback here...',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: AppButton(
                  size: Size(0.8.sw,50),
                  backgroundColor: AppColors.buttonPrimary,
                  onPressed: controller.submitFeedback,
                  child: Text(
                    "Send Feedback",
                    style: AppTextStyle.appButton,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
