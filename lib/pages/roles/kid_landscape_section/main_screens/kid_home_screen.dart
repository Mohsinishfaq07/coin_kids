import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/common_funcitons.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/jar_with_money.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/jar_without_money.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_name.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_transfer.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/Jar_color_screen.dart';
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
    final addMoneyController = Get.put(AddMoneyController());
    landScapeOrientation();
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
                          kidAvatarContainer(),
                          GestureDetector(
                              onTap: () async {
                                await firebaseAuthController.logout();
                              },
                              child: Icon(Icons.logout)),
                          Row(
                            children: [
                              cardContainerIcon(),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          VerticalNavBar(),
                          Obx(() {
                            return verticalNavBarController.currentItem.value ==
                                    0
                                ? SizedBox(
                                    height: 100.h,
                                    width: 400.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (kidsData.isNotEmpty) ...[
                                          (() {
                                            final Map<String, dynamic> kidData =
                                                kidsData[0].data()
                                                    as Map<String, dynamic>;
                                            final Map<String, dynamic>
                                                spendingData =
                                                kidData.containsKey('spendings')
                                                    ? kidData['spendings']
                                                        as Map<String, dynamic>
                                                    : {};
                                            print("$spendingData");

                                           
                                            final double spendingAmount =
                                                (spendingData['amount'] ?? 0.0)
                                                    .toDouble();
                                            final String spendingJarColor =
                                                (spendingData['color'] ?? "")
                                                    .toString();

                                            if (spendingJarColor == "#000000" ||
                                                (spendingJarColor.isEmpty &&
                                                    spendingAmount == 0.0)) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Get.to(JarColorScreen(
                                                      isSpending: true.obs));
                                                },
                                                child: Image.asset(
                                                    "assets/jar.png"),
                                              );
                                            } else if (spendingAmount != 0.0) {
                                              return JarWithMoneyTitle(
                                                JarTitle: 'Spendings',
                                                amount: spendingAmount,
                                                color: spendingJarColor,
                                              );
                                            } else {
                                              return JarWithoutMoneyTitle(
                                                JarTitle: 'Spendings',
                                                amount: spendingAmount,
                                              );
                                            }
                                          })(),
                                        ],
                                        SizedBox(width: 20.w),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Obx(() {
                                          // Ensure both spendingAmount and savingAmount are non-zero
                                          if (addMoneyController
                                                      .spendingAmount.value !=
                                                  0.0 &&
                                              addMoneyController
                                                      .savingAmount.value !=
                                                  0.00) {
                                            return Container(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(KidTransferScreen());
                                                  },
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .buttonPrimary,
                                                      borderRadius: BorderRadius
                                                          .circular(30
                                                              .r), // Rounded corners
                                                      border: Border.all(
                                                        width: 2.22.w,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 12.w,
                                                          right: 12.w,
                                                          top: 4.h,
                                                          bottom: 4.h,
                                                          child: Center(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .transparent, // Background color (optional)
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.2), // Shadow color
                                                                    blurRadius:
                                                                        10, // Blur radius for the shadow
                                                                    offset: Offset(
                                                                        2,
                                                                        4), // Shadow position (x, y)
                                                                  ),
                                                                ],
                                                                shape: BoxShape
                                                                    .circle, //
                                                              ),
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/arrow.svg",
                                                                height: 14.h,
                                                                width: 14.w,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                            left: 0.5,
                                                            top: 0.29,
                                                            child: Image.asset(
                                                              "assets/Button_shadow.png",
                                                              height: 8.h,
                                                            )),
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          } else {
                                            // Return an alternative widget if either of the values is 0
                                            return SizedBox
                                                .shrink(); // You can return another widget here if needed
                                          }
                                        }),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        if (kidsData.isNotEmpty) ...[
                                          (() {
                                            // Extract kid data safely
                                            final Map<String, dynamic> kidData =
                                                kidsData[0].data()
                                                    as Map<String, dynamic>;

                                            // Ensure "savings" field exists, otherwise provide default values
                                            final Map<String, dynamic>
                                                savingsData =
                                                kidData.containsKey('savings')
                                                    ? kidData['savings']
                                                        as Map<String, dynamic>
                                                    : {};
                                            print("$savingsData");

                                            final double savingAmount =
                                                (savingsData['amount'] ?? 0.0)
                                                    .toDouble();
                                            final String savingJarColor =
                                                (savingsData['color'] ??
                                                        "#000000")
                                                    .toString();

                                            // Ensure "spendings" field exists, otherwise provide default values
                                            final Map<String, dynamic>
                                                spendingsData =
                                                kidData.containsKey('spendings')
                                                    ? kidData['spendings']
                                                        as Map<String, dynamic>
                                                    : {};

                                            final String spendingJarColor =
                                                (spendingsData['color'] ??
                                                        "#000000")
                                                    .toString();

                                            print(
                                                "Spending jar color: $spendingJarColor");
                                            print(
                                                "Saving jar color: $savingJarColor");

                                            // Return appropriate widget
                                            if (savingJarColor == "#000000" ||
                                                (savingJarColor.isEmpty &&
                                                    savingAmount == 0.0)) {
                                              return (spendingJarColor ==
                                                          "#000000" ||
                                                      spendingJarColor.isEmpty)
                                                  ? Container(
                                                      color: Colors.green,
                                                      height: 100.h,
                                                      width: 100.w,
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        Get.to(JarColorScreen(
                                                            isSpending:
                                                                false.obs));
                                                      },
                                                      child: Image.asset(
                                                          "assets/jar.png"),
                                                    );
                                            } else if (savingAmount != 0.0) {
                                              return JarWithMoneyTitle(
                                                JarTitle: 'Savings',
                                                amount: savingAmount,
                                                color: savingJarColor,
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () {
                                                  Get.to(() => JarColorScreen(
                                                      isSpending: false.obs));
                                                },
                                                child: JarWithoutMoneyTitle(
                                                  JarTitle: 'Savings',
                                                  amount: savingAmount,
                                                ),
                                              );
                                            }
                                          })(), // Properly call the function
                                        ]
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Create a save goal! 🎯',
                                                  style:
                                                      AppTextStyle.headingLarge,
                                                ),
                                                CustomButton(
                                                  text: '+ Add a Goal',
                                                  color: Color(0xffFF9E29),
                                                  onPressed: () {
                                                    Get.to(() => KidAddGoal(
                                                          childMoney: '',
                                                        ));
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                          }),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 51.h,
                              width: 70.w,
                              decoration: BoxDecoration(
                                color: AppColors.textOnPrimary,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(80.r),
                                  topRight: Radius.circular(80.r),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(2.h),
                                    child: SvgPicture.asset(
                                      "assets/parent.svg",
                                      height: 30.h,
                                    ),
                                  ),
                                  Text(
                                    "Parent\nZone",
                                    style: AppTextStyle.labelSmall.copyWith(
                                      color: AppColors.KidZoneParent,
                                      fontWeight:
                                          MyFontWeight.ExtraBold.fontWeight,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
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

  Widget kidAvatarContainer() {
    return Container(
      height: 27.h,
      width: 120.w,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 34.w),
            child: Container(
              height: 20.h,
              width: 100.w,
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
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('kids') // Replace with your collection name
                      .where('parentId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Loading...",
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        "Error",
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text(
                        "No Data",
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
                      );
                    }

                    // Retrieve the name and avatar of the first kid in the list
                    final kidData = snapshot.data!.docs.first.data();
                    final kidName = kidData['name'] as String? ?? "Unknown";

                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Text(
                        kidName,
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
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

                // Retrieve avatar URL
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
                      // fit: BoxFit.cover,
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
                      "500",
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

              // Align(
              //   alignment: Alignment.topLeft,
              //   child: SvgPicture.asset(AppAssets.kidCoinIcon),
              // ),
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

// totalBalanceWidget() {
//   return Padding(
//     padding: EdgeInsets.only(right: 10.w),
//     child: SizedBox(
//       height: 27.h,
//       width: 120.w,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Blue Container
//           Positioned(
//             top: 5.h,
//             right: 10.w,
//             bottom: 5.h,
//             child: Container(
//               height: 18.h,
//               width: 96.w,
//               decoration: BoxDecoration(
//                 color: AppColors.iconPrimaryVariant,
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//               alignment: Alignment.center,
//               child: Padding(
//                 padding: EdgeInsets.only(right: 8.w, left: 8.w),
//                 child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   future: FirebaseFirestore.instance
//                       .collection('kids')
//                       .where('parentId',
//                           isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator(); // Placeholder while loading
//                     }
//                     if (snapshot.hasError ||
//                         !snapshot.hasData ||
//                         snapshot.data!.docs.isEmpty) {
//                       return CircleAvatar(
//                         radius: 22.h,
//                         backgroundImage: AssetImage(
//                             "assets/child_avatar_image_pngs/Frame 1.png"),
//                       );
//                     }

//                     final data = snapshot.data!.docs.first.data();
//                     final spendingAmount = double.tryParse(
//                             data['spendings']['amount']?.toString() ?? "0") ??
//                         0.0;
//                     final savingsAmount = double.tryParse(
//                             data['savings']['amount']?.toString() ?? "0") ??
//                         0.0;
//                     final totalBalance = spendingAmount + savingsAmount;

//                     return Text(
//                       "€$totalBalance",
//                       style: AppTextStyle.headingMedium
//                           .copyWith(color: AppColors.textOnPrimary),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),

//           Positioned(
//             right: -2.w,
//             child: SvgPicture.asset(
//               'assets/kidRoleIcons/kidCoinIcon.svg',
//               height: 22.h,
//               width: 22.w,
//             ),
//           ),
//           Positioned(
//               left: 5.w,
//               child: Container(
//                 height: 25,
//                 width: 25,
//                 decoration: BoxDecoration(
//                   color: const Color(0xff19B859),
//                   borderRadius: BorderRadius.circular(3.r),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(3.h),
//                   child: SvgPicture.asset(
//                     'assets/add_icon.svg',
//                     height: 7.h,
//                   ),
//                 ),
//               )),
//         ],
//       ),
//     ),
//   );
// }
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
