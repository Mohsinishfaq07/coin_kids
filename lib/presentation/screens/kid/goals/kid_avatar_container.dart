import 'dart:io';

import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KidAvatarContainer extends StatelessWidget {
  const KidAvatarContainer({Key? key}) : super(key: key);
  String getKidAvatar(String localPath) {
    return File(localPath).existsSync()
        ? localPath
        : "assets/child_avatar_image_pngs/Frame 1.png"; // Fallback to default if the image does not exist locally
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _kidsStream() {
    return FirebaseFirestore.instance
        .collection('kids')
        .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots(); // Using snapshots() for real-time updates
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      // width: 130.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 36.w),
            child: Container(
              height: 20.h,
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                ),
                border: Border.all(color: const Color(0xff0095e5), width: 2.w),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 12.w, right: 4.w),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _kidsStream(), // Using StreamBuilder for live updates
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Loading...",
                        style: AppTextStyle.headingMedium.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      );
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Text(
                        "No Data",
                        style: AppTextStyle.headingMedium.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      );
                    }

                    final kidData = snapshot.data!.docs.first.data();
                    final kidName = kidData['name'] as String? ?? "Unknown";

                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          kidName,
                          style: AppTextStyle.headingMedium.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: -12.h,
            left: 0.w,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _kidsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
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

                final kidData = snapshot.data!.docs.first.data();
                final kidAvatar = kidData['avatar'] as String? ?? "";

                return Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: kidAvatar.startsWith('http')
                          ? NetworkImage(kidAvatar) as ImageProvider
                          : AssetImage(kidAvatar),
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
