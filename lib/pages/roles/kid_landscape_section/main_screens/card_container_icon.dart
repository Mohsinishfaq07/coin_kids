import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardContainerIcon extends StatelessWidget {
  const CardContainerIcon({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> _kidsStream() {
    return FirebaseFirestore.instance
        .collection('kids')
        .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots(); // Real-time updates
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 28.w, top: 4.h),
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
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _kidsStream(), // Using StreamBuilder for live updates
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return CircleAvatar(
                        radius: 22.h,
                        backgroundImage: AssetImage("assets/child_avatar_image_pngs/Frame 1.png"),
                      );
                    }

                    final data = snapshot.data!.docs.first.data();
                    final spendingsAmount = (data['spendings'] != null && data['spendings']['amount'] != null)
                        ? data['spendings']['amount'].toString()
                        : "€0.00"; // Default to "€0.00" if missing

                    return Text(
                      "€$spendingsAmount",
                      style: AppTextStyle.headingMedium.copyWith(color: AppColors.textOnPrimary),
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
