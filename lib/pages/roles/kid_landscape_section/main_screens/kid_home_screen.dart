import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_home_appbar.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_shop_appbar.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_market/kids_market_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_market/wishlist_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goals_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/models/wishlist_model.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/services/wishlist_service.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_finance_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/parent_zone_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/save_goal_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/vertical_navigation_bar.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../kid_market/market_controller.dart';

class KidHomeScreen extends StatelessWidget {
  KidHomeScreen({super.key});

  final MarketController marketController = Get.put(MarketController());

  final VerticalNavBarController verticalNavBarController =
      Get.find<VerticalNavBarController>();
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: AppColors.background,
                  image: DecorationImage(
                      image: AssetImage(AppAssets.kidSectionBG),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final currentIndex =
                          verticalNavBarController.currentItem.value;

                      if (currentIndex == 0 || currentIndex == 1) {
                        return KidDefaultAppBar();
                      } else {
                        return CustomShopAppBar();
                      }
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
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      color: Colors.transparent,
                                      width: 600.w,
                                      child: KidsMarketScreen(),
                                    ),
                                  ),
                                  // Check if spendingJarColor is empty
                                  // if (spendingJarColor.isEmpty)
                                  //   SizedBox.shrink()
                                  // else
                                  //   // If spendingJarColor is not empty, display KidsMarketScreen
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
                                //show the wishlist count

                                Positioned(
                                  top: 0.h,
                                  bottom: 0.h,
                                  // left: 0.w,
                                  right: 0.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(KidWishlistScreen());
                                    },
                                    child: Transform.rotate(
                                        angle: 270 * 3.14159 / 180, //
                                        child:
                                            StreamBuilder<List<WishlistModel>>(
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
                                            return Center(
                                              child: Text(
                                                'Wishlist $wishlistCount',
                                                style: AppTextStyle
                                                    .headingMedium
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            );
                                          },
                                        )),
                                  ),
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
}
