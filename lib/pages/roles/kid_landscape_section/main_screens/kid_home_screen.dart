import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/total_money_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_market/kids_market_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goals_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/models/wishlist_model.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/services/wishlist_service.dart';
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
import '../kid_market/market_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';

class KidHomeScreen extends StatelessWidget {
  KidHomeScreen({super.key});

  final MarketController marketController = Get.put(MarketController());
  final VerticalNavBarController verticalNavBarController =
      Get.put(VerticalNavBarController());
  final WishlistService _wishlistService = Get.put(WishlistService());

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, you should handle this case
      return Center(child: Text("No user is logged in"));
    }
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
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
                        if (spendingJarColor.isEmpty) {
                          // Show toast if spendingJarColor is empty
                          // ToastUtil.showToast("Add Spending Jar first");

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
                          ); // You can return an empty widget or a placeholder
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Shop",
                                      style: AppTextStyle.headingLarge,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomTextField(
                                        titleText: "",
                                        hintText: "e.g Electric bike",
                                        suffixIconColor:
                                            AppColors.iconPrimaryVariant,
                                        suffixSvgPath: "assets/shop/search.svg",
                                        onChanged: (value) => marketController
                                            .updateSearch(value),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: SpendingCardContainer(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Row(
                                  children: [
                                    Obx(() => _buildFilterButton(
                                          "All",
                                          marketController
                                                  .currentFilter.value ==
                                              FilterType.all,
                                          () =>
                                              _handleFilterTap(FilterType.all),
                                        )),
                                    SizedBox(width: 20.w),
                                    Obx(() => _buildFilterButton(
                                          "Age",
                                          marketController
                                                  .currentFilter.value ==
                                              FilterType.age,
                                          () =>
                                              _handleFilterTap(FilterType.age),
                                        )),
                                    SizedBox(width: 20.w),
                                    Obx(() => _buildFilterButton(
                                          "Budget",
                                          marketController
                                                  .currentFilter.value ==
                                              FilterType.budget,
                                          () => _handleFilterTap(
                                              FilterType.budget),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return SizedBox.shrink();
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
                            } else {
                              // ToastUtil.showToast("Add Spending jar First");
                              return SizedBox.shrink();
                            }
                          }),
                          Obx(() {
                            return verticalNavBarController.currentItem.value ==
                                    0
                                ? SizedBox
                                    .shrink() // Return SizedBox.shrink() when the condition is met
                                : Container(); // Or return any other widget based on the condition
                          })
                        ],
                      ),
                      Obx(() {
                        return Visibility(
                          visible:
                              verticalNavBarController.currentItem.value == 2,
                          child: Positioned(
                              bottom: 0.h,
                              left: 0.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VerticalNavBar(),
                                  // Check if spendingJarColor is empty
                                  if (spendingJarColor.isEmpty)
                                    SizedBox.shrink()
                                  else
                                    // If spendingJarColor is not empty, display KidsMarketScreen
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        color: Colors.transparent,
                                        width: 600.w,
                                        child: KidsMarketScreen(),
                                      ),
                                    ),
                                ],
                              )),
                        );
                      }),
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
                      Obx(() {
                        return Visibility(
                          visible:
                              verticalNavBarController.currentItem.value == 2,
                          child: Positioned(
                            bottom: 0.h,
                            right: 0.w,
                            child: Stack(
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 120.h,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF015486),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        bottomLeft: Radius.circular(20.r),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0.h,
                                  bottom: 0.h,
                                  // left: 0.w,
                                  right: 0.w,
                                  child: Transform.rotate(
                                      angle: 270 * 3.14159 / 180, //
                                      child: StreamBuilder<List<WishlistModel>>(
                                        stream: _wishlistService
                                            .getWishlistStream(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }

                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }

                                          final wishlistCount = snapshot
                                                  .data?.length ??
                                              0; // Get the count of wishlist items
                                          return Text(
                                            'Wishlist Count: $wishlistCount',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                      )),
                                )
                              ],
                            ),
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

  Widget _buildFilterButton(String text, bool isSelected, VoidCallback onTap) {
    String svgPath = "";
    // Determine which SVG to use based on text
    switch (text.toLowerCase()) {
      case "all":
        svgPath = "assets/shop/all.svg";
        break;
      case "age":
        svgPath = "assets/shop/calendar_month.svg";
        break;
      case "budget":
        svgPath = "assets/shop/donut_small.svg";
        break;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textHighlighted : Colors.grey,
          borderRadius: BorderRadius.circular(30.r),
          // border: Border.all(
          //   color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          // ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 20.r,
                child: SvgPicture.asset(
                  svgPath,
                  color: isSelected
                      ? AppColors.textHighlighted
                      : AppColors.textSecondary,
                  width: 12.w,
                  height: 10.h,
                ),
              ),
            ),
            // SizedBox(width: 8.w), // Add spacing between icon and text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                text,
                style: AppTextStyle.bodyLarge.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFilterTap(FilterType type) {
    if (type == FilterType.budget) {
      _showBudgetDialog();
    } else if (type == FilterType.age) {
      _showAgeDialog();
    } else if (marketController.currentFilter.value == type) {
      marketController.updateFilter(FilterType.all);
      marketController.resetFilters();
    } else {
      marketController.updateFilter(type);
    }
  }

  void _showAgeDialog() {
    marketController.updateAgeRange(0, 18);

    Get.bottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.dialogueBGSvg,
                  fit: BoxFit.fill,
                  height: 110.h,
                  width: 180.w,
                ),
              ),
              Positioned(
                top: 50.h,
                right: 0.w,
                left: 0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Set Age Range',
                      style: AppTextStyle.headingMedium
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Obx(() {
                      final minAge = marketController.minAge.value.clamp(0, 18);
                      final maxAge =
                          marketController.maxAge.value.clamp(minAge, 18);

                      return Column(
                        children: [
                          Text(
                            'Age Range: $minAge - $maxAge years',
                            style: AppTextStyle.bodyMedium,
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 160.w),
                            child: RangeSlider(
                              values: RangeValues(
                                minAge.toDouble(),
                                maxAge.toDouble(),
                              ),
                              min: 0,
                              max: 18,
                              divisions: 18,
                              activeColor: AppColors.skipButton,
                              inactiveColor:
                                  AppColors.primaryLightColor.withOpacity(0.3),
                              labels: RangeLabels(
                                '$minAge years',
                                '$maxAge years',
                              ),
                              onChanged: (RangeValues values) {
                                marketController.updateAgeRange(
                                  values.start.round(),
                                  values.end.round(),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Positioned(
                bottom: 30.h,
                left: 250.w,
                child: GreenNextButton(
                  onTap: () {
                    marketController.updateFilter(FilterType.age);
                    Get.back();
                  },
                  buttonText: "ok",
                  showPrefix: true,
                  prefixSvg: AppAssets.kidTickButton,
                ),
              ),
              Positioned(
                top: 30.h,
                right: 90.w,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset(
                      AppAssets.crossSvg,
                      width: 44.w,
                      height: 44.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBudgetDialog() {
    marketController.updatePriceRange(0, 10000);

    Get.bottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.dialogueBGSvg,
                  fit: BoxFit.fill,
                  height: 110.h,
                  width: 180.w,
                ),
              ),
              Positioned(
                top: 50.h,
                right: 0.w,
                left: 0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Set Budget Range',
                      style: AppTextStyle.headingMedium
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Obx(() {
                      final minPrice =
                          marketController.minPrice.value.clamp(0.0, 10000.0);
                      final maxPrice = marketController.maxPrice.value
                          .clamp(minPrice, 10000.0);

                      return Column(
                        children: [
                          Text(
                            'Price Range: \$${minPrice.toStringAsFixed(0)} - \$${maxPrice.toStringAsFixed(0)}',
                            style: AppTextStyle.bodyMedium,
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 160.w),
                            child: RangeSlider(
                              values: RangeValues(minPrice, maxPrice),
                              min: 0,
                              max: 10000,
                              divisions: 100,
                              activeColor: AppColors.skipButton,
                              inactiveColor:
                                  AppColors.primaryLightColor.withOpacity(0.3),
                              labels: RangeLabels(
                                '\$${minPrice.toStringAsFixed(0)}',
                                '\$${maxPrice.toStringAsFixed(0)}',
                              ),
                              onChanged: (RangeValues values) {
                                marketController.updatePriceRange(
                                    values.start, values.end);
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Positioned(
                bottom: 30.h,
                left: 250.w,
                child: GreenNextButton(
                  onTap: () {
                    marketController.updateFilter(FilterType.budget);
                    Get.back();
                  },
                  buttonText: "ok",
                  showPrefix: true,
                  prefixSvg: AppAssets.kidTickButton,
                ),
              ),
              Positioned(
                top: 30.h,
                right: 90.w,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset(
                      AppAssets.crossSvg,
                      width: 44.w,
                      height: 44.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
