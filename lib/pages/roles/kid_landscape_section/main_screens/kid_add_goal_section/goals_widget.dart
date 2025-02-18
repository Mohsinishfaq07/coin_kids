import 'dart:io';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/add_goal_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_progress.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/save_goal_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_name.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GoalsWidget extends StatelessWidget {
  final String currentKidId;

  GoalsWidget({required this.currentKidId});
  final KidGoalsController kidGoalController = Get.put(KidGoalsController());

  @override
  Widget build(BuildContext context) {
    // final kidGoalController = Get.put(KidGoalsController());
    kidGoalController.fetchGoals(currentKidId);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, kidSnapshot) {
        if (kidSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!kidSnapshot.hasData || kidSnapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Kids Found"));
        }

        final kidId = kidSnapshot.data!.docs.first.id;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('goals')
              .where('kidId', isEqualTo: kidId)
              .where('deleted', isEqualTo: false)
              .snapshots(),
          builder: (context, goalSnapshot) {
            if (goalSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!goalSnapshot.hasData || goalSnapshot.data!.docs.isEmpty) {
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
                        itemCount: goalSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final goal = goalSnapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          final goalId = goal['goalId'];

                          return FutureBuilder<File?>(
                            future: kidGoalController.getImageFromPrefs(goalId),
                            builder: (context, imageSnapshot) {
                              if (imageSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
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
  final Map<String, dynamic> goal;
  final File? imageFile;

  GoalCard({required this.goal, this.imageFile});
  String _truncateGoalName(String name) {
    if (name.length > 10) {
      return name.substring(0, 10) + "...";
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GoalProgress(
              isCompleted: (goal['completed'] as bool).obs,
              goalId: goal['goalId'],
              fromHome: true.obs,
              //completed: goal['completed']
            ));
      },
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Color(0xFFEDFAFF),
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
                    _truncateGoalName(goal['name'] ?? 'No Name'),
                    style: AppTextStyle.headingMedium
                        .copyWith(color: AppColors.iconPrimary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  imageFile != null
                      ? Container(
                          height: 50.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(imageFile!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Icon(Icons.image, size: 45.h, color: Colors.grey),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "€${goal['amount']}",
                            style: AppTextStyle.headingMedium
                                .copyWith(color: AppColors.iconPrimary),
                          ),
                          Text(
                            goal['completed']
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
