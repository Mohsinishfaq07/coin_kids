import 'dart:io';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/save_goal_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/add_goal_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_name.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GoalsScreen extends StatelessWidget {
  final String currentKidId;

  GoalsScreen({required this.currentKidId});

  @override
  Widget build(BuildContext context) {
    final kidGoalController = Get.put(KidGoalsController());
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('goals')
          .where('kidId', isEqualTo: currentKidId)
          .where('deleted', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return AddGoalWidget();
        }

        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  // color: Colors.green,
                  height: 100.h,
                  width: double.infinity,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width, // Restrict width
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true, // Prevents infinite height issue
                      // Prevents conflict with ScrollView
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final goal = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        final goalId = goal['goalId']; // Goal ID

                        return FutureBuilder<File?>(
                          future: kidGoalController.getImageFromPrefs(goalId),
                          builder: (context, imageSnapshot) {
                            if (imageSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            File? imageFile = imageSnapshot.data;
                            return GoalCard(goal: goal, imageFile: imageFile);
                          },
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: addGoalButton(
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
  }
}

class GoalCard extends StatelessWidget {
  final Map<String, dynamic> goal;
  final File? imageFile; // Image File

  GoalCard({required this.goal, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                SizedBox(height: 2.h),
                Text(
                  goal['name'] ?? 'No Name',
                  style: AppTextStyle.headingMedium
                      .copyWith(color: AppColors.iconPrimary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),

                // Image Handling
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
                    : Icon(Icons.image, size: 60.h, color: Colors.grey),

                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "€${goal['amount']}",
                          style: AppTextStyle.headingMedium
                              .copyWith(color: AppColors.iconPrimary),
                        ),

                        // Status
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
                          color: AppColors
                              .iconPrimary, // Background color (optional)
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10, // Blur radius for the shadow
                              offset:
                                  const Offset(2, 4), // Shadow position (x, y)
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8.r),
                          shape: BoxShape
                              .rectangle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.h),
                          child: SvgPicture.asset(
                            "assets/arrorDirectionNoShadow.svg", // Arrow icon asset
                            height: 2.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Amount
              ],
            ),
          ),
        ),
      ),
    );
  }
}
