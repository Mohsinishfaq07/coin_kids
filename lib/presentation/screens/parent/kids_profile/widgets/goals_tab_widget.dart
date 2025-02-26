import 'package:cached_network_image/cached_network_image.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/parent/notification/empty_state.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GoalsTabWidget extends GetView<KidProfileController> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () {
          if (controller.isGoalsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.goals.isEmpty) {
            return buildGoalsEmptyState(controller);
          }

          return ListView.builder(
            itemCount: controller.goals.length,
            itemBuilder: (context, index) {
              var goalData = controller.goals[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: goalData.photo!,
                    height: 60.h,
                    width: 60.w,
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
                        borderRadius: BorderRadius.circular(60.r),
                      ),
                      child: Icon(
                        Icons.error_outline,
                        color: AppColors.iconPrimary,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  title: Text(
                    goalData.title ?? 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    goalData.targetAmount.toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
