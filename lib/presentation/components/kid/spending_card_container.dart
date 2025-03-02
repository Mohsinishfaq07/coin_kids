import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/extention/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SpendingCardContainer extends StatelessWidget {
  SpendingCardContainer({super.key});

  final KidService _kidService = Get.find<KidService>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 27.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 30.w, top: 4.h),
            child: Container(
              height: 19.h,
              // width: 96.w,
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
                padding: EdgeInsets.only(left: 10.w, right: 20.w),
                child: StreamBuilder<List<KidModel>>(
                  stream: _kidService.streamKids(user.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(
                        strokeWidth: 2,
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    final List<KidModel> kids = snapshot.data!;
                    if (kids.isEmpty) {
                      return Text("No data found.");
                    }

                    // Get the first kid's spending jar balance
                    final KidModel kid = kids.first;
                    final double spendingAmount =
                        kid.wallet.spendingJar.balance;

                    // Format the amount with 2 decimal places
                    // final formattedSpendingAmount =
                    //     spendingAmount.toStringAsFixed(2);

                    return Text(
                      "${spendingAmount.toMoneyFormat()}",
                      style: AppTextStyle.headingMedium.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    );
                  },
                ),
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
