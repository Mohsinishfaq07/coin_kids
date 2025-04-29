import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/overlay/kid_market_overlay.dart';
import 'package:coin_kids/presentation/components/kid/product_detail_dialog.dart';
import 'package:coin_kids/presentation/components/parent/market_filter_chips.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_market_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/age_filter_dialog.dart';
import 'package:coin_kids/presentation/dialogs/kid/range_slider_dialog.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
import 'package:coin_kids/presentation/components/kid/overlay/market_wishlist_tutorial_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'product_card.dart';
import 'dart:math' as math;

class KidMarketScreen extends GetView<KidMarketController> {
  KidMarketScreen({super.key}) {
    controller.checkTutorialState();
  }

  final GlobalKey wishlistButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final int crossAxisCount = _calculateCrossAxisCount(screenWidth);
        final double cardWidth = (screenWidth - (crossAxisCount + 1) * 8.w) / crossAxisCount;
        final double cardHeight = cardWidth * 1.40;

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),
                    Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: controller.showFilters.value ? 36.r : 0,
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      MarketFilterChip(
                                        label: 'All',
                                        isSelected: !controller.isAgeFilterActive.value && !controller.isBudgetFilterActive.value && !controller.isRatingFilterActive.value,
                                        iconPath: Assets.icAll,
                                        onTap: () => controller.resetAllFilters(),
                                      ),
                                      SizedBox(width: 8.w),
                                      MarketFilterChip(
                                        label: 'Age',
                                        selectedValue: controller.isAgeFilterActive.value ? controller.getAgeRangeText(controller.selectedAgeRange.value) : null,
                                        isSelected: controller.isAgeFilterActive.value,
                                        iconPath: Assets.icCalender,
                                        onTap: _showAgeRangeDialog,
                                      ),
                                      SizedBox(width: 8.w),
                                      MarketFilterChip(
                                        label: 'Budget',
                                        selectedValue: controller.isBudgetFilterActive.value
                                            ? '€${controller.selectedMinBudget.value.toStringAsFixed(0)}-${controller.selectedMaxBudget.value.toStringAsFixed(0)}'
                                            : null,
                                        isSelected: controller.isBudgetFilterActive.value,
                                        iconPath: Assets.icBudget,
                                        onTap: () => _showBudgetDialog(),
                                      ),
                                      SizedBox(width: 8.w),
                                      MarketFilterChip(
                                        label: 'Rating',
                                        selectedValue: controller.isRatingFilterActive.value
                                            ? '${controller.selectedMinRating.value.toStringAsFixed(1)}-${controller.selectedMaxRating.value.toStringAsFixed(1)}'
                                            : null,
                                        isSelected: controller.isRatingFilterActive.value,
                                        iconPath: Assets.icStar,
                                        onTap: () => _showRatingDialog(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                    // Products Grid
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (controller.error.value.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.error.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: controller.fetchProducts,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        final products = controller.displayProducts;
                        if (products.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.phProducts,
                                  height: 100.h,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No products match your filters',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Stack(
                          children: [
                            NotificationListener<ScrollNotification>(
                              onNotification: (scrollInfo) {
                                if (scrollInfo.metrics.pixels > 10) {
                                  controller.hideFilters();
                                } else if (scrollInfo.metrics.pixels <= 0) {
                                  controller.showFilter();
                                }
                                return true;
                              },
                              child: GridView.builder(
                                controller: controller.scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.only(top: 4.h, bottom: 12.h, right: 30.r),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 8.w,
                                  mainAxisSpacing: 8.h,
                                  childAspectRatio: cardWidth / cardHeight,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return Stack(
                                    children: [
                                      Obx(() => ProductCard(
                                        product: product,
                                        onWishlistTap: () {
                                          controller.toggleWishlist(product);
                                          
                                          if (index == 0 && controller.showPointer.value) {
                                            controller.dismissFavoriteTutorial();
                                          }
                                        },
                                        isInWishlist: controller.isInWishlist(product.id!),
                                        isLoading: controller.isItemLoading(product.id!),
                                        favoriteKey: index == 0 ?  GlobalKeys.firstFavoriteKey : null,
                                        onTap: () => Get.dialog(
                                          ProductDetailDialog(
                                            product: product,
                                            onAddToGoal: () {
                                              controller.addToGoal(product);
                                            },
                                          ),
                                          barrierDismissible: true,
                                        ),
                                      )),
                                      if (index == 0)
                                        Obx(() {
                                          if (controller.showPointer.value) {
                                            return Positioned(
                                              right: 12.w,
                                              bottom: -10.w,
                                              child: KidMarketOverlay(
                                                targetKey: GlobalKeys.firstFavoriteKey,
                                                onTap: () {
                                                  controller.toggleWishlist(product);
                                                  controller.dismissFavoriteTutorial();
                                                },
                                                // width: 80.w,
                                                // height: 80.w,
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              // Wishlist Button
              Positioned(
                top: 0.10.sh,
                right: 0,
                child: GestureDetector(
                  key: wishlistButtonKey,
                  onTap: () {
                    controller.dismissWishlistTutorial();
                    Get.toNamed(Routes.kidWishlist);
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        bottomLeft: Radius.circular(14.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: Offset(-2, 0),
                        ),
                      ],
                    ),
                    child: RotatedBox(
                      quarterTurns: 3, // Rotate text from bottom to top
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'My Wishlist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w800,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Obx(
                              () {
                                final count = controller.wishlistItemCount.value;
                                if (count > 0) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 8.w),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      "(items ${count.toString()})",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                            SizedBox(width: 15.w,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r)
                                    ,color: Colors.white
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Transform.rotate(
                                  angle: 0.5 * math.pi,

                                  child: Icon(Icons.arrow_back_ios_new,color: AppColors.textPrimary,
                                  size: 12.h
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Wishlist Tutorial Overlay
              Obx(() {
                if (controller.showWishlistTutorial.value) {

                  return Positioned(
                    top: 0.10.sh,
                    right: 0,
                    child: MarketWishlistTutorialOverlay(
                      targetKey: wishlistButtonKey,
                      onComplete: () => controller.dismissWishlistTutorial(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        );
      },
    );
  }

  void _showAgeRangeDialog() {
    AgeFilterDialog.show(
      selectedRange: controller.selectedAgeRange.value,
      onSelect: controller.setAgeRange,
    );
  }

  void _showBudgetDialog() {
    RangeSliderDialog.show(
      title: 'Select Budget Range',
      minValue: controller.minBudget.value,
      maxValue: controller.maxBudget.value,
      currentMin: controller.selectedMinBudget.value,
      currentMax: controller.selectedMaxBudget.value,
      onSelect: controller.setBudgetRange,
      labelFormat: (value) => '€${value.toStringAsFixed(0)}',
    );
  }

  void _showRatingDialog() {
    RangeSliderDialog.show(
      title: 'Select Rating Range',
      minValue: controller.minRating.value,
      maxValue: controller.maxRating.value,
      currentMin: controller.selectedMinRating.value,
      currentMax: controller.selectedMaxRating.value,
      onSelect: controller.setRatingRange,
      labelFormat: (value) => value.toStringAsFixed(1),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    final double targetCardWidth = 180.w;
    int count = (screenWidth / targetCardWidth).floor();
    return count.clamp(2, 4);
  }
}
