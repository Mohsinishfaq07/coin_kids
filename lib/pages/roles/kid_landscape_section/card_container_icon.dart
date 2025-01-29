import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CardContainerIcon extends StatelessWidget {
  RxBool isSpending;
  CardContainerIcon({required this.isSpending, super.key});
  @override
  Widget build(BuildContext context) {
    final addMoneyController = Get.put(AddMoneyController());

    return SizedBox(
      height: 27.h,
      width: 128.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 26.w, top: 4.h),
            child: Container(
              height: 19.h,
              width: 96.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(14.r),
                ),
                border: Border.all(color: AppColors.textPrimary, width: 2.w),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Obx(() {
                  // Reactive logic to decide which amount to display
                  final amount = isSpending.value
                      ? addMoneyController.spendingAmount.value
                      : addMoneyController.savingAmount.value;

                  // Display a loading indicator if amount is 0
                  if (amount == 0) {
                    return const CircularProgressIndicator(
                      strokeWidth: 2,
                    );
                  }

                  // Display the appropriate amount
                  return Text(
                    "€$amount",
                    style: AppTextStyle.headingMedium
                        .copyWith(color: AppColors.textOnPrimary),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            right: 0.w,
            child: Container(
              color: Colors.transparent,
              height: 25.h,
              child: SvgPicture.asset(AppAssets.kidCardICon, height: 25.h),
            ),
          ),
        ],
      ),
    );
  }
}
