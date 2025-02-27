import 'package:cached_network_image/cached_network_image.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/presentation/components/common/custom_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalListItem extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback? onTap;

  const GoalListItem({
    Key? key,
    required this.goal,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate progress percentage
    final progress = goal.savedAmount / goal.targetAmount;
    // final progress = 0.5;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Image Row
            Row(
              children: [
                // Goal Image
                Container(
                  height: 48.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: goal.photo != null
                        ? CachedNetworkImage(
                            imageUrl: goal.photo!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.buttonPrimary,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                color: AppColors.iconPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.error_outline,
                                color: AppColors.iconPrimary,
                                size: 24.sp,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image,
                              color: Colors.grey[400],
                              size: 24.sp,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Goal Title
                Expanded(
                  child: Text(
                    goal.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            // New Custom Progress Bar
            CustomProgressBar(
              progress: progress,
              currentValue: goal.savedAmount,
              totalValue: goal.targetAmount,
            ),

            SizedBox(height: 16.h), // Increased spacing for dot indicator value
          ],
        ),
      ),
    );
  }
}
