import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class JarsTabWidget extends GetView<KidProfileController> {
  @override
  Widget build(BuildContext context) {
    final wallet = controller.appState.currentKid.value!.wallet;

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Savings Jar
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/kidManageIcons/savingJar.svg',
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(height: 20.h),
              Text(
                'Savings: €${wallet.savingJar.balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
          // Spending Jar
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/kidManageIcons/spendingJar.svg',
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(height: 20.h),
              Text(
                'Spending: €${wallet.spendingJar.balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
