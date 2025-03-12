import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/cached_network_image_widget.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;

  const GoalCard({required this.goal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        Get.to(
          () => GoalDetailsScreen(goalId: goal.id!, fromHome: true),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  color: AppColors.iconDisabled.withValues(alpha: 0.2),
                ),
                child: goal.photo != null && goal.photo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                        child: CachedNetworkImageWidget(
                          imageUrl: goal.photo!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Image.asset(
                          Assets.phProducts,
                        ),
                      ),
              ),
            ),
            // Content Container
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      goal.title,
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Progress Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.colorPrimary.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 1.0 ? AppColors.notificationPositive : AppColors.colorPrimary,
                            ),
                            minHeight: 8.h,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // Amount Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goal.savedAmount.toMoneyFormat(),
                              style: AppTextStyle.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              goal.targetAmount.toMoneyFormat(),
                              style: AppTextStyle.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
