import 'package:coin_kids/core/extention/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget totalBalanceWidget() {
  final KidService _kidService = Get.find<KidService>();
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return const SizedBox.shrink();

  return Container(
    height: 27.h,
    // width: 120.w,
    child: Stack(
      clipBehavior: Clip.none,
      // alignment: Alignment.center,
      children: [
        // Blue Container
        Padding(
          padding: EdgeInsets.only(right: 30.w, top: 4.h),
          child: Container(
            height: 19.h,
            // width: 96.w,
            decoration: BoxDecoration(
              color: AppColors.iconPrimaryVariant,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(right: 12.w, left: 12.w),
              child: StreamBuilder<List<KidModel>>(
                stream: _kidService.streamKids(user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      "Error",
                      style: AppTextStyle.headingMedium.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    );
                  }

                  final List<KidModel> kids = snapshot.data!;
                  if (kids.isEmpty) {
                    return Text(
                      0.toMoneyFormat(),
                      style: AppTextStyle.headingMedium.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    );
                  }

                  final KidModel kid = kids.first;
                  final spendingAmount = kid.wallet.spendingJar.balance;
                  final savingAmount = kid.wallet.savingJar.balance;
                  final totalBalance = spendingAmount + savingAmount;

                  return Text(
                    totalBalance.toMoneyFormat(),
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
          right: 2.w,
          bottom: 2.h,
          child: SvgPicture.asset(
            'assets/kidRoleIcons/kidCoinIcon.svg',
            height: 22.h,
            width: 22.w,
          ),
        ),

        Positioned(
          left: -14.w,
          bottom: 8.h,
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: const Color(0xff19B859),
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.h),
              child: SvgPicture.asset(
                'assets/add_icon.svg',
                height: 7.h,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
