import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/components/kid/spending_card_container.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
                    // Attempt to parse the value as a double
                    double? parsedValue = double.tryParse(value);

                    // If parsing fails (i.e., parsedValue is null), set a default value (e.g., 0.0)
                    kidGoalsController.goalAmount.value = parsedValue ?? 0.0;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w, top: 16.h),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GreenNextButton(
                      showSuffix: true,
                      onTap: () {
                        if (kidGoalsController.goalAmount.value == 0.0) {
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
