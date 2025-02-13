import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/total_money_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_market/kids_market_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goals_widget.dart';
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

import '../../../../features/custom_widgets/custom_text_field.dart';

class KidHomeScreen extends StatelessWidget {
  const KidHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VerticalNavBarController verticalNavBarController =
        Get.put(VerticalNavBarController());
    landscapeOrientation();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, you should handle this case
      return Center(child: Text("No user is logged in"));
    }
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('kids')
              .where('parentId', isEqualTo: user.uid)
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
              final List<dynamic> goalsRefs = kidData['goals'] ?? [];

              List<String> goalIds = goalsRefs
                  .map((ref) => (ref as DocumentReference).id)
                  .toList();

              print("Goal IDs: $goalIds");

              print("Spending jar color: $spendingJarColor");

              print("Spending jar color: $spendingAmount");
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      if (verticalNavBarController.currentItem.value == 0 ||
                          verticalNavBarController.currentItem.value == 1) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 6.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KidAvatarContainer(),
                              GestureDetector(
                                onTap: () async {
                                  await firebaseAuthController.logout();
                                },
                                child: Icon(Icons.logout),
                              ),
                              Row(
                                children: [
                                  SpendingCardContainer(),
                                  SizedBox(width: 10.w),
                                  coinLockedWidget(),
                                  SizedBox(width: 10.w),
                                  totalBalanceWidget()
                                ],
                              )
                            ],
                          ),
                        );
                      } else if (verticalNavBarController.currentItem.value ==
                          2) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shop",
                                  style: AppTextStyle.headingLarge,
                                ),
                                SizedBox(width: 20.w),
                                Flexible(
                                  child: Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 400.w),
                                    child: CustomTextField(
                                      titleText: "",
                                      hintText: "e.g Electric bike",
                                      suffixIconColor:
                                          AppColors.iconPrimaryVariant,
                                      suffixSvgPath: "assets/shop/search.svg",
                                      onChanged: (value) {
                                        // Update search query when text changes
                                        // controller.updateSearch(value);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                SpendingCardContainer(),
                                Row(
                                  children: [
                                    // IconButton(
                                    //   icon: const Icon(Icons.favorite_border),
                                    //   onPressed: () => Get.to(() => WishlistScreen()),
                                    // ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.filter_list),
                                    //   onPressed: () => _showFilterDialog(context),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox
                          .shrink(); // Return empty widget for other cases
                    }),
                    Stack(children: [
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
                              if (spendingJarColor.isEmpty) {
                                ToastUtil.showToast(
                                    "Spending Jar is required!");
                                return KidFinanceWidgets(
                                  // Keep user on the same screen
                                  spendingJarColor: spendingJarColor,
                                  spendingAmount: spendingAmount,
                                  savingJarColor: savingJarColor,
                                  savingAmount: savingAmount,
                                  kidsData: kidsData,
                                );
                              }
                              final String kidId = kidData.containsKey('kidId')
                                  ? kidData['kidId'] as String
                                  : "";

                              if (kidData.containsKey('goals')) {
                                final String currentKidId = kidId;
                                print("$currentKidId");
                                return GoalsWidget(currentKidId: currentKidId);
                              } else {
                                return AddGoalWidget();
                              }
                            } else if (verticalNavBarController
                                    .currentItem.value ==
                                2) {
                              if (spendingJarColor.isEmpty) {
                                ToastUtil.showToast("Invalid selection");
                                return KidFinanceWidgets(
                                  spendingJarColor: spendingJarColor,
                                  spendingAmount: spendingAmount,
                                  savingJarColor: savingJarColor,
                                  savingAmount: savingAmount,
                                  kidsData: kidsData,
                                );
                              }

                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                child: KidsMarketScreen(),
                              );
                            } else {
                              ToastUtil.showToast("Invalid selection");
                              return KidFinanceWidgets(
                                // Prevent navigation for invalid selection
                                spendingJarColor: spendingJarColor,
                                spendingAmount: spendingAmount,
                                savingJarColor: savingJarColor,
                                savingAmount: savingAmount,
                                kidsData: kidsData,
                              );
                            }
                          }),
                          SizedBox.shrink(),
                        ],
                      ),
                      Obx(() {
                        return Visibility(
                          visible:
                              verticalNavBarController.currentItem.value == 0,
                          child: Positioned(
                            bottom: 0.h,
                            right: 0.w,
                            child: ParentZoneWidget(),
                          ),
                        );
                      }),
                    ]),
                  ],
                ),
              );
            }
          }),
    );
  }

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
