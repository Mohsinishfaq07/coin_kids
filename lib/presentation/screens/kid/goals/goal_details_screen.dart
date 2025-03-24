import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/cached_network_image_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/screens/kid/goals/widgets/goal_progress_widget.dart';
import 'package:coin_kids/presentation/screens/kid/goals/widgets/goal_timeline_widget.dart' show GoalTimelineWidget;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GoalDetailsScreen extends GetView<KidGoalsController> {
  final String goalId;

  GoalDetailsScreen({
    super.key,
  }) : goalId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.appBar.configureForGoalSetup();
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: KidAppBarComponent(
        onBackPressed: () {
          controller.appBar.resetToDefault();
          Get.back();
        },
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(
            image: AssetImage(Assets.kidBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          var goal = controller.goals.firstWhere((item) => item.id == goalId);
          return Row(
            children: [
              // Left side with goal card (35% width)
              Container(
                color: AppColors.iconPrimary,
                width: MediaQuery.of(context).size.width * 0.35,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: GoalCard(goal: goal),
                  ),
                ),
              ),
              // Right side with controls
              Expanded(
                child: goal.savedAmount != goal.targetAmount ? GoalProgressWidget(goal) : GoalTimelineWidget(goal: goal),
                // child: GoalTimelineScreen(goal: goal),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final GoalModel goal;

  const GoalCard({required this.goal, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.6.sh,
      width: 0.25.sw,
      decoration: BoxDecoration(
        color: Color(0xFFEDFAFF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFCBE5F4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              goal.title,
              style: AppTextStyle.headingMedium.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.colorPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Image Container
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
              child: goal.photo != null && goal.photo!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                      child: CachedNetworkImageWidget(
                        imageUrl: goal.photo!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Assets.phGoalImage2.endsWith("svg")
                          ? SvgPicture.asset(
                              Assets.phGoalImage2,
                            )
                          : Image.asset(
                              Assets.phGoalImage2,
                            ),
                    ),
            ),
          ),
          // Content Container
          Text(
            goal.targetAmount.toMoneyFormat(),
            style: AppTextStyle.headingMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 4.h,
          )
        ],
      ),
    );
  }
}
