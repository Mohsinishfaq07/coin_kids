import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget totalBalanceWidget() {
  return Padding(
    padding: EdgeInsets.only(right: 10.w),
    child: SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blue Container
          Positioned(
            top: 5.h,
            right: 10.w,
            bottom: 5.h,
            child: Container(
              height: 18.h,
              width: 96.w,
              decoration: BoxDecoration(
                color: AppColors.iconPrimaryVariant,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 8.w, left: 8.w),
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('kids')
                      .where('parentId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Placeholder while loading
                    }

                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return CircleAvatar(
                        radius: 22.h,
                        backgroundImage: AssetImage(
                            "assets/child_avatar_image_pngs/Frame 1.png"),
                      );
                    }

                    final data = snapshot.data!.docs.first.data();

                    // Safely retrieve 'spendings' and 'savings' amounts, defaulting to 0.0 if not found
                    final spendingAmount = (data['spendings'] != null &&
                            data['spendings']['amount'] != null)
                        ? double.tryParse(
                                data['spendings']['amount'].toString()) ??
                            0.0
                        : 0.0;
                    final savingsAmount = (data['savings'] != null &&
                            data['savings']['amount'] != null)
                        ? double.tryParse(
                                data['savings']['amount'].toString()) ??
                            0.0
                        : 0.0;

                    final totalBalance = spendingAmount + savingsAmount;

                    return Text(
                      "€${totalBalance.toStringAsFixed(2)}", // Formatting to show two decimal places
                      style: AppTextStyle.headingMedium
                          .copyWith(color: AppColors.textOnPrimary),
                    );
                  },
                ),
              ),
            ),
          ),

          Positioned(
            right: -2.w,
            child: SvgPicture.asset(
              'assets/kidRoleIcons/kidCoinIcon.svg',
              height: 22.h,
              width: 22.w,
            ),
          ),

          Positioned(
            left: 5.w,
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
    ),
  );
}
