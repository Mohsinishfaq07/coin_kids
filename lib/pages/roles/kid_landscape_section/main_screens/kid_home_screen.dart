import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_avatar_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_finance_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/parent_zone_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/save_goal_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/vertical_navigation_bar.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class KidHomeScreen extends StatelessWidget {
  const KidHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VerticalNavBarController verticalNavBarController =
        Get.put(VerticalNavBarController());
    landscapeOrientation();
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('kids')
              .where('parentId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return CircularProgressIndicator();
            else if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else {
              final List<QueryDocumentSnapshot> kidsData = snapshot.data!.docs;
              print("kidsdata is $kidsData");
              if (kidsData.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              final Map<String, dynamic> kidData =
                  kidsData[0].data() as Map<String, dynamic>;
              final Map<String, dynamic> spendingData =
                  kidData.containsKey('spendings')
                      ? kidData['spendings'] as Map<String, dynamic>
                      : {};
              final double spendingAmount =
                  (spendingData['amount'] ?? 0.0).toDouble();
              final String spendingJarColor =
                  (spendingData['color'] ?? "").toString();

              // Ensure "savings" field exists, otherwise provide default values
              final Map<String, dynamic> savingsData =
                  kidData.containsKey('savings')
                      ? kidData['savings'] as Map<String, dynamic>
                      : {};
              print("$savingsData");

              final double savingAmount =
                  (savingsData['amount'] ?? 0.0).toDouble();
              final String savingJarColor =
                  (savingsData['color'] ?? "#000000").toString();

              // Ensure "spendings" field exists, otherwise provide default values
              final Map<String, dynamic> spendingsData =
                  kidData.containsKey('spendings')
                      ? kidData['spendings'] as Map<String, dynamic>
                      : {};

              print("Spending jar color: $spendingJarColor");
              print("Saving jar color: $savingJarColor");

              return Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.background,
                  image: DecorationImage(
                    image: AssetImage(AppAssets.kidSectionBG),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KidAvatarContainer(),
                          GestureDetector(
                              onTap: () async {
                                await firebaseAuthController.logout();
                              },
                              child: Icon(Icons.logout)),
                          Row(
                            children: [
                              SpendingCardContainer(),
                              SizedBox(
                                width: 10.w,
                              ),
                              coinLockedWidget(),
                              SizedBox(
                                width: 10.w,
                              ),
                              totalBalanceWidget()
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalNavBar(),
                          Obx(() {
                            if (verticalNavBarController.currentItem.value ==
                                0) {
                              return KidFinanceWidgets(
                                spendingJarColor: spendingJarColor,
                                spendingAmount: spendingAmount,
                                savingJarColor: savingJarColor,
                                savingAmount: savingAmount,
                                kidsData: kidsData,
                              );
                            } else if (verticalNavBarController
                                    .currentItem.value ==
                                1) {
                              return AddGoalWidget();
                            } else if (verticalNavBarController
                                    .currentItem.value ==
                                2) {
                              return Text("Shop widget"); //
                            } else {
                              return SizedBox(); // Default case
                            }
                          }),
                          ParentZoneWidget()
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  // card container icon

  coinLockedWidget() {
    return SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            fit: StackFit.loose,
            children: [
              Positioned(
                top: 5.h,
                right: 6.w,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 18.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(4.r),
                      border:
                          Border.all(color: AppColors.textPrimary, width: 2.0),
                    ),
                    child: Text(
                      "5000",
                      style: AppTextStyle.headingMedium
                          .copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -4.w,
                top: 2.h,
                child: Container(
                  color: Colors.transparent,
                  height: 24.h,
                  // width: 80.w,
                  child: SvgPicture.asset(AppAssets.kidCoinIcon, height: 24.h),
                ),
              ),
              Container(
                height: 28.9.h,
                width: 120.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xff000000).withOpacity(0.46)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppAssets.kidLockIcon, height: 24.h),
          ),
        ],
      ),
    );
  }
}

totalBalanceWidget() {
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

Widget cardContainerIcon() {
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

                  // Safely retrieve 'spendings' amount, defaulting to 0.0 if not found
                  final spendingsAmount = (data['spendings'] != null &&
                          data['spendings']['amount'] != null)
                      ? data['spendings']['amount'].toString()
                      : "€0.00"; // Default to "€0.00" if the field is missing or null

                  return Text(
                    "€$spendingsAmount",
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
