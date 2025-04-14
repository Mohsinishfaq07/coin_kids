import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final bool isConnected;

  const GoalCard({required this.goal, required this.isConnected, super.key});

  Color _getStatusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.completed:
        return isConnected
            ? AppColors.buttonSecondary
            : AppColors.btnColorGreen;
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
        return isConnected ? 'Waiting Approval' : 'Completed';
      case GoalStatus.inProgress:
        return 'In Progress';
      case GoalStatus.rejected:
        return 'Rejected';
      case GoalStatus.approved:
        return 'Approved';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.kidGoalDetailsScreen, arguments: goal.id!);
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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.r)),
                  color: AppColors.iconDisabled.withValues(alpha: 0.1),
                ),
                child: goal.photo != null && goal.photo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12.r)),
                        child: CachedNetworkImageWidget(
                          imageUrl: goal.photo!,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: REdgeInsets.all(6.h),
                          child: SvgPicture.asset(
                            Assets.phGoalImage,
                          ),
                        ),
                      ),
              ),
            ),
            // Content Container
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Container at the top
                  
                      // Title
                      Text(
                        goal.title,
                        style: AppTextStyle.headingSmall.copyWith(
                            fontWeight: MyFontWeight.bold.fontWeight,
                            color: AppColors.textPrimary,
                            fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // if (goal.status != GoalStatus.approved &&
                      //     goal.status != GoalStatus.rejected &&
                      //     goal.status != GoalStatus.completed)
                      //   // Progress Bar
                      //   ClipRRect(
                      //     borderRadius: BorderRadius.circular(10.r),
                      //     child: LinearProgressIndicator(
                      //       value: progress,
                      //       backgroundColor:
                      //           AppColors.colorPrimary.withValues(alpha: 0.2),
                      //       valueColor: AlwaysStoppedAnimation<Color>(
                      //         _getStatusColor(goal.status),
                      //       ),
                      //       minHeight: 6.h,
                      //     ),
                      //   ),
                      goal.status != GoalStatus.approved &&
                              goal.status != GoalStatus.rejected &&
                              goal.status != GoalStatus.completed
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor:
                                    AppColors.colorPrimary.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getStatusColor(goal.status),
                                ),
                                minHeight: 6.h,
                              ),
                            )
                          : const SizedBox.shrink(),
                      // SizedBox(height: 4.h),
                      // Amount Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (goal.status != GoalStatus.approved &&
                              goal.status != GoalStatus.rejected &&
                              goal.status != GoalStatus.completed)
                            SizedBox(),
                          Text(goal.targetAmount.toMoneyFormat(),
                              style: AppTextStyle.bodySmall.copyWith(
                                color: _getStatusColor(goal.status),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              )),
                  
                          // Text(
                          //   goal.savedAmount.toMoneyFormat(),
                          //   style: AppTextStyle.bodySmall.copyWith(
                          //     color: AppColors.textPrimary,
                          //     fontSize: 11,
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(goal.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _getStatusText(goal.status),
                          style: AppTextStyle.bodySmall.copyWith(
                            color: _getStatusColor(goal.status),
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
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
