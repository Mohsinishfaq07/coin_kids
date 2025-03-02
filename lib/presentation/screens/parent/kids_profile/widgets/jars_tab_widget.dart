import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/extention/number_extensions.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class JarsTabWidget extends GetView<KidProfileController> {
  @override
  Widget build(BuildContext context) {
    final wallet = controller.appState.currentKid.value!.wallet;

    return
      Obx(() {
        if (controller.appState.currentKid.value!.wallet.spendingJar.color == "#000000") {
           return Expanded(child: Image.asset(AppAssets.parent_jar_place_holder_png));
        }
        return Expanded(


          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Savings Jar

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.parent_side_saving_jar_svg,
                    height: 100.h,
                    width: 100.w,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Savings:${wallet.savingJar.balance.toMoneyFormat()}',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
              // Spending Jar

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.parent_side_spending_jar_svg,
                    height: 100.h,
                    width: 100.w,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Spending: €${wallet.spendingJar.balance.toMoneyFormat()}',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ); // If color isn't #000000, no icon is shown
      });



  }
}
