import 'dart:io';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/components/kid/add_goal_button.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_progress.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/screens/kid/goals/save_goal_widget.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'goal_name.dart';

class GoalsWidget extends StatelessWidget {
  final String currentKidId;

  GoalsWidget({required this.currentKidId});

  final KidGoalsController kidGoalController = Get.put(KidGoalsController());
  final GoalService _goalService = Get.find<GoalService>();
  final KidService _kidService = Get.find<KidService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KidModel?>(
      future: _kidService.fetchKidById(currentKidId),
      builder: (context, kidSnapshot) {
        if (kidSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (kidSnapshot.hasError) {
          return Center(child: Text("Error: ${kidSnapshot.error}"));
        }

        final kid = kidSnapshot.data;
        if (kid == null) {
          return const Center(child: Text("Kid not found"));
        }

        return StreamBuilder<List<GoalModel>>(
          stream: _goalService.streamUserGoals(kid.kidId),
          builder: (context, goalSnapshot) {
            if (goalSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (goalSnapshot.hasError) {
              return Center(child: Text("Error: ${goalSnapshot.error}"));
            }

            final goals = goalSnapshot.data ?? [];
            if (goals.isEmpty) {
              return AddGoalWidget();
            }

            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 100.h,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          return FutureBuilder<File?>(
                            future:
                                kidGoalController.getImageFromPrefs(goal.id!),
                            builder: (context, imageSnapshot) {
                              if (imageSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              File? imageFile = imageSnapshot.data;
                              return GoalCard(goal: goal, imageFile: imageFile);
                            },
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AddGoalButton(
                        onTap: () {
                          Get.to(() => AddGoalName());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final File? imageFile;

  const GoalCard({Key? key, required this.goal, this.imageFile})
      : super(key: key);

  String _truncateGoalName(String name) {
    if (name.length > 10) {
      return '${name.substring(0, 10)}...';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GoalProgress(
              isCompleted: (goal.status == GoalStatus.completed).obs,
              goalId: goal.id!,
              fromHome: true.obs,
            ));
      },
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xFFEDFAFF),
          ),
          height: 60.h,
          width: 150.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _truncateGoalName(goal.title),
                    style: AppTextStyle.headingMedium
                        .copyWith(color: AppColors.iconPrimary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  if (imageFile != null)
                    Container(
                      height: 50.h,
                      width: 40.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Icon(Icons.image, size: 45.h, color: Colors.grey),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.formattedTargetAmount,
                            style: AppTextStyle.headingMedium
                                .copyWith(color: AppColors.iconPrimary),
                          ),
                          Text(
                            goal.status == GoalStatus.completed
                                ? "Goal Achieved"
                                : "Goal Not Achieved",
                            style: AppTextStyle.bodySmall
                                .copyWith(color: AppColors.textHighlighted),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          height: 15.h,
                          width: 15.h,
                          decoration: BoxDecoration(
                            color: AppColors.iconPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(2, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5.h),
                            child: SvgPicture.asset(
                              "assets/arrorDirectionNoShadow.svg",
                              height: 2.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
