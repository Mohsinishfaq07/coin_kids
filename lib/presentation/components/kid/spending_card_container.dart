import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpendingCardContainer extends StatelessWidget {
  SpendingCardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27.h,
      // width: 128.w,
      // color: Colors.red,
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('kids')
                      .where('parentId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(
                        strokeWidth: 2,
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    // Handle if no documents are found
                    if (snapshot.data!.docs.isEmpty) {
                      return Text("No data found.");
                    }

                    // Assuming the first document is the one you want
                    final kidData =
                        snapshot.data!.docs[0].data() as Map<String, dynamic>;

                    // Safely extract 'spendings' and 'amount'
                    final Map<String, dynamic> spendingData =
                        kidData['spendings'] as Map<String, dynamic>? ?? {};
                    final double spendingAmount =
                        (spendingData['amount'] ?? 0.0).toDouble();

                    // Reactive logic to decide which amount to display
                    final formattedSpendingAmount =
                        spendingAmount.toStringAsFixed(2);

                    // Display the appropriate amount
                    return Text(
                      "€$formattedSpendingAmount",
                      style: AppTextStyle.headingMedium
                          .copyWith(color: AppColors.textOnPrimary),
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
