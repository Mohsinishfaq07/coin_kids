import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../../app_assets.dart';
import '../../../../../theme/color_theme.dart';
import '../../../../../theme/text_theme.dart';
import '../../custom_widgets/kid_text_field.dart';
import 'goal_image.dart';

class AddGoalAmount extends StatelessWidget {
  const AddGoalAmount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    KidGoalsController kidGoalsController = Get.put(KidGoalsController());
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: kidBackButton(
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                      SpendingCardContainer()
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'How much does it cost 💸',
                  style: AppTextStyle.headingLarge,
                ),
                SizedBox(height: 20.h),
                KidCustomTextField(
                  hintText: "000.00 €",
                  onChange: (value) {
                    kidGoalsController.goalAmount.value = value;
                  },
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w, top: 16.h),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GreenNextButton(
                      onTap: () {
                        if (kidGoalsController.goalAmount.value.isEmpty) {
                          Fluttertoast.showToast(
                            msg:
                                'Goal Amount Could Not be empty ', // Message to display
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: AppColors.textHighlighted,
                            textColor: Colors.white,
                            fontSize: 16.sp,
                          );
                        } else {
                          kidGoalsController.goalAmount.value;
                          Get.to(() => AddGoalImage());
                        }
                      },
                      buttonText: 'Next',
                      // color: Color(0xFF19B859),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
