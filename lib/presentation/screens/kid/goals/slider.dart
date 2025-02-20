import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalCard extends StatelessWidget {
  final Map<String, dynamic> goal;
  final File? imageFile; // Image File

  GoalCard({required this.goal, this.imageFile});
  String _truncateGoalName(String name) {
    if (name.length > 10) {
      return name.substring(0, 10) + "...";
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: SizedBox(
        height: 145.h,
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: Color(0xFFEDFAFF),
              ),
              height: 120.h,
              width: 180.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Text(
                          _truncateGoalName(goal['name'] ?? 'No Name'),
                          style: AppTextStyle.headingMedium
                              .copyWith(color: AppColors.iconPrimary),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Image Handling
                      imageFile != null
                          ? Container(
                              height: 70.h,
                              width: 60.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(imageFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Icon(Icons.image, size: 60.h, color: Colors.grey),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              "€${goal['amount']}.00",
                              style: AppTextStyle.headingMedium
                                  .copyWith(color: AppColors.iconPrimary),
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                      // Amount
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
