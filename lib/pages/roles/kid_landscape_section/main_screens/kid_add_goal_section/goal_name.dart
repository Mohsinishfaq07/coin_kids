import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_ammount.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app_assets.dart';
import '../../../../../theme/color_theme.dart';
import '../../../../../theme/text_theme.dart';
import '../../custom_widgets/kid_text_field.dart';
import '../kid_home_screen.dart';

class KidAddGoal extends StatelessWidget {
  final String childMoney;
  const KidAddGoal({super.key, required this.childMoney});

  @override
  Widget build(BuildContext context) {
    KidGoalsController kidGoalsController = Get.put(KidGoalsController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            child: SvgPicture.asset(AppAssets.kidSectionBackIconSvg),
          ),
        ),
        title: Text(
          'Name Your Goal',
          style: AppTextStyle.headingLarge,
        ),
        actions: [cardContainerIcon()],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.background,
            image: DecorationImage(
              image: AssetImage(AppAssets.kidSectionBG),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'What are you saving for 🎯',
                style: AppTextStyle.headingLarge,
              ),
              KidCustomTextField(
                hintText: "e.g Electric Bike",
                onChange: (value) {
                  kidGoalsController.goalName.value = value;
                },
              ),
              kidCustomButton(
                  onTap: () {
                    Get.log(
                        'log: goal name controller:${kidGoalsController.goalName.value}');
                    if (kidGoalsController.goalName.value.isNotEmpty) {
                      Get.to(() => KidAddGoalAmount());
                    }
                  },
                  color: Color(0xFF19B859),
                  buttonTitle: 'Next')
            ],
          ),
        ),
      ),
    );
  }
}

kidCustomButton(
    {required Function() onTap,
    required Color color,
    required String buttonTitle}) {
  return Padding(
    padding: EdgeInsets.only(right: 20.w),
    child: Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120.w,
          height: 42.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.22.w, color: color),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20.w,
                right: 12.w,
                top: 4.h,
                bottom: 4.h,
                child: Row(
                  children: [
                    Text(
                      buttonTitle,
                      style: AppTextStyle.headingMedium.copyWith(
                          color: AppColors.textOnPrimary, fontSize: 22.sp),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.transparent, // Background color (optional)
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              blurRadius: 10, // Blur radius for the shadow
                              offset:
                                  const Offset(2, 4), // Shadow position (x, y)
                            ),
                          ],
                          shape: BoxShape
                              .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                        ),
                        child: SvgPicture.asset(
                          "assets/arrorDirectionNoShadow.svg",
                          height: 12.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 1,
                  top: 1.29,
                  child: Image.asset(
                    "assets/Button_shadow.png",
                    height: 10.h,
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}
