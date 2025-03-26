import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalListItem extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onTap;
  final VoidCallback? onReject;
  final VoidCallback? onBuy;

  const GoalListItem({
    super.key,
    required this.goal,
    required this.onTap,
    this.onReject,
    this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _getStatusColor(goal.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                _getStatusText(goal.status),
                style: AppTextStyle.bodySmall.copyWith(
                  color: _getStatusColor(goal.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                if (goal.photo != null && goal.photo!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      goal.photo!,
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: AppTextStyle.headingSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (goal.status != GoalStatus.approved &&
                          goal.status != GoalStatus.rejected )
                        LinearProgressIndicator(
                          value: goal.savedAmount / goal.targetAmount,
                          backgroundColor:
                              AppColors.colorPrimary.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _getStatusColor(goal.status)),
                          minHeight: 8.h,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                        ),
                      if (goal.status == GoalStatus.approved) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Goal Approved',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.btnColorGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (goal.status == GoalStatus.rejected) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Goal Rejected',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.critical,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Target',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      goal.targetAmount.toMoneyFormat(),
                      style: AppTextStyle.headingSmall.copyWith(
                        color: _getStatusColor(goal.status),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (goal.status == GoalStatus.completed) ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: onReject ?? () {},
                      backgroundColor: AppColors.critical,
                      child: Text(
                        "Reject",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppButton(
                      onPressed: onBuy ?? () {},
                      backgroundColor: AppColors.btnColorGreen,
                      child: Text(
                        "Approve",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.completed:
        return AppColors.btnColorGreen;
      case GoalStatus.inProgress:
        return AppColors.colorPrimary;
      case GoalStatus.rejected:
        return AppColors.critical;
      case GoalStatus.approved:
        return AppColors.btnColorGreen;
      }
  }

  String _getStatusText(GoalStatus status) {
    switch (status) {
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.inProgress:
        return 'In Progress';
      case GoalStatus.rejected:
        return 'Rejected';
      case GoalStatus.approved:
        return 'Approved';
      default:
        return '';
    }
  }
}
