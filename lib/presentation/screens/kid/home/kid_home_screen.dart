import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:coin_kids/presentation/components/kid/kid_home_appbar.dart';
import 'package:coin_kids/presentation/components/kid/kid_shop_appbar.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/common/role_selection_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/market_controller.dart';
import 'package:coin_kids/presentation/screens/kid/market/kids_market_screen.dart';
import 'package:coin_kids/presentation/screens/kid/wishlist/wishlist_screen.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goals_widget.dart';
import 'package:coin_kids/core/utils/landscape_orientation.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_finance_widget.dart';
import 'package:coin_kids/presentation/components/kid/parent_zone_widget.dart';
import 'package:coin_kids/presentation/screens/kid/goals/save_goal_widget.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/screens/parent/home_screen/parent_home_screen.dart';
import 'package:coin_kids/presentation/screens/parent/parent_base/parent_base_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';

class KidHomeScreen extends StatelessWidget {
  KidHomeScreen({super.key});

  final MarketController marketController = Get.put(MarketController());
  final VerticalNavBarController verticalNavBarController =
      Get.find<VerticalNavBarController>();
  final WishlistService _wishlistService = Get.put(WishlistService());
  final KidService _kidService = Get.find<KidService>();
  final RoleSelectionController roleSelectionController =
      Get.find<RoleSelectionController>();

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("No user is logged in"));
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<List<KidModel>>(
        stream: _kidService.streamKids(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<KidModel> kids = snapshot.data!;
          if (kids.isEmpty) {
            return const Center(child: Text('No kid data found'));
          }

          final KidModel kid = kids.first;
          final wallet = kid.wallet;

          // Get spending jar data
          final spendingAmount = wallet.spendingJar.balance;
          final spendingJarColor = wallet.spendingJar.color;

          // Get saving jar data
          final savingAmount = wallet.savingJar.balance;
          final savingJarColor = wallet.savingJar.color;

          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: AppColors.background,
              image: DecorationImage(
                  image: AssetImage(AppAssets.kidSectionBG), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final currentIndex =
                      verticalNavBarController.currentItem.value;
                  return currentIndex == 0 || currentIndex == 1
                      ? KidDefaultAppBar()
                      : CustomShopAppBar();
                }),
                Stack(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalNavBar(),
                      Obx(() {
                        if (verticalNavBarController.currentItem.value == 0) {
                          return KidFinanceWidgets(
                            spendingJarColor: spendingJarColor,
                            spendingAmount: spendingAmount,
                            savingJarColor: savingJarColor,
                            savingAmount: savingAmount,
                            kid: kid,
                          );
                        } else if (verticalNavBarController.currentItem.value ==
                            1) {
                          if (spendingJarColor.isEmpty) {
                            ToastUtil.showToast("Spending Jar is required!");
                            return KidFinanceWidgets(
                              spendingJarColor: spendingJarColor,
                              spendingAmount: spendingAmount,
                              savingJarColor: savingJarColor,
                              savingAmount: savingAmount,
                              kid: kid,
                            );
                          }
                          return kid.kidId.isEmpty
                              ? AddGoalWidget()
                              : GoalsWidget(currentKidId: kid.kidId);
                        }
                        return const SizedBox.shrink();
                      }),
                      Obx(() {
                        return verticalNavBarController.currentItem.value == 0
                            ? SizedBox
                                .shrink() // Return SizedBox.shrink() when the condition is met
                            : Container(); // Or return any other widget based on the condition
                      })
                    ],
                  ),
                  Obx(() {
                    return Visibility(
                      visible: verticalNavBarController.currentItem.value == 2,
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
                            ],
                          )),
                    );
                  }),
                  Obx(() {
                    return Visibility(
                      visible: verticalNavBarController.currentItem.value == 0,
                      child: Positioned(
                        bottom: 0.h,
                        right: 0.w,
                        child: GestureDetector(
                            onTap: () => roleSelectionController
                                .finalizeRole(UserRole.PARENT),
                            child: ParentZoneWidget()),
                      ),
                    );
                  }),
                  Obx(() {
                    return Visibility(
                      visible: verticalNavBarController.currentItem.value == 2,
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
                              right: 0.w,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(KidWishlistScreen());
                                },
                                child: Transform.rotate(
                                    angle: 270 * 3.14159 / 180,
                                    child: StreamBuilder<List<WishlistModel>>(
                                      stream:
                                          _wishlistService.getWishlistStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }

                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }

                                        final wishlistCount =
                                            snapshot.data?.length ?? 0;
                                        return Center(
                                          child: Text(
                                            'Wishlist $wishlistCount',
                                            style: AppTextStyle.headingMedium
                                                .copyWith(color: Colors.white),
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
        },
      ),
    );
  }
}
