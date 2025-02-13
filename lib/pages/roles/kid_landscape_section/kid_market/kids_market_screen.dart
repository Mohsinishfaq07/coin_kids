import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../app_assets.dart';
import '../../../../features/custom_widgets/custom_text_field.dart';
import '../../../../theme/color_theme.dart';
import '../spending_card_container.dart';
import 'market_controller.dart';
import '../services/wishlist_service.dart';
import 'widgets/product_card.dart';

class KidsMarketScreen extends GetView<MarketController> {
  final WishlistService _wishlistService = WishlistService();

  KidsMarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with actions
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Shop",
          //           style: AppTextStyle.headingLarge,
          //         ),
          //         SizedBox(
          //           width: 400.w,
          //           child: CustomTextField(
          //             titleText: "",
          //             hintText: "e.g Electric bike",
          //             suffixIconColor: AppColors.iconPrimaryVariant,
          //             suffixSvgPath: "assets/shop/search.svg",
          //             onChanged: (value) {
          //               // Update search query when text changes
          //               controller.updateSearch(value);
          //             },
          //           ),
          //         ),
          //         SpendingCardContainer(),
          //
          //       ],
          //     ),
          //   ),
          // ),

          // Filter Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                Obx(() => _buildFilterButton(
                      "All",
                      controller.currentFilter.value == FilterType.all,
                      () => _handleFilterTap(FilterType.all),
                    )),
                SizedBox(width: 20.w),
                Obx(() => _buildFilterButton(
                      "Age",
                      controller.currentFilter.value == FilterType.age,
                      () => _handleFilterTap(FilterType.age),
                    )),
                SizedBox(width: 20.w),
                Obx(() => _buildFilterButton(
                      "Budget",
                      controller.currentFilter.value == FilterType.budget,
                      () => _handleFilterTap(FilterType.budget),
                    )),
              ],
            ),
          ),

          // Main content
          Container(
            height: 100.h,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.error.value),
                      ElevatedButton(
                        onPressed: () => controller.fetchProducts(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.products.isEmpty) {
                return const Center(child: Text('No products available'));
              }

              final filteredProducts = controller.filteredProducts;

              if (filteredProducts.isEmpty) {
                return const Center(
                  child: Text('No products match the selected filters'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return SizedBox(
                    width: 200.w,
                    child: ProductCard(
                      product: product,
                      wishlistService: _wishlistService,
                    ),
                  );
                },
              );
            }),
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
        height: 19.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textHighlighted : Colors.grey,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          // Add this to prevent row from expanding
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 20.r,
              child: SvgPicture.asset(
                svgPath,
                color: isSelected
                    ? AppColors.textHighlighted
                    : AppColors.textSecondary,
                width: 20.w,
                height: 10.h,
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
    } else if (controller.currentFilter.value == type) {
      controller.updateFilter(FilterType.all);
      controller.resetFilters();
    } else {
      controller.updateFilter(type);
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Products'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Price Range'),
                Obx(() => RangeSlider(
                      values: RangeValues(
                        controller.minPrice.value,
                        controller.maxPrice.value,
                      ),
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels(
                        '\$${controller.minPrice.value.toStringAsFixed(0)}',
                        '\$${controller.maxPrice.value.toStringAsFixed(0)}',
                      ),
                      onChanged: (RangeValues values) {
                        controller.updatePriceRange(values.start, values.end);
                      },
                    )),
                const SizedBox(height: 20),
                const Text('Rating Range'),
                Obx(() => RangeSlider(
                      values: RangeValues(
                        controller.minRating.value,
                        controller.maxRating.value,
                      ),
                      min: 0,
                      max: 5,
                      divisions: 10,
                      labels: RangeLabels(
                        controller.minRating.value.toStringAsFixed(1),
                        controller.maxRating.value.toStringAsFixed(1),
                      ),
                      onChanged: (RangeValues values) {
                        controller.updateRatingRange(values.start, values.end);
                      },
                    )),
                const SizedBox(height: 20),
                const Text('Age Range'),
                Obx(() => RangeSlider(
                      values: RangeValues(
                        controller.minAge.value.toDouble(),
                        controller.maxAge.value.toDouble(),
                      ),
                      min: 0,
                      max: 18,
                      divisions: 18,
                      labels: RangeLabels(
                        '${controller.minAge.value} years',
                        '${controller.maxAge.value} years',
                      ),
                      onChanged: (RangeValues values) {
                        controller.updateAgeRange(
                          values.start.round(),
                          values.end.round(),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              controller.updatePriceRange(0, 1000);
              controller.updateRatingRange(0, 5);
              controller.updateAgeRange(0, 18);
            },
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }

  void _showAgeDialog() {
    // Reset age range to valid values before showing dialog
    controller.updateAgeRange(0, 18); // Set initial values within bounds

    Get.bottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
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
                      // Ensure values are within bounds
                      final minAge = controller.minAge.value.clamp(0, 18);
                      final maxAge = controller.maxAge.value.clamp(minAge, 18);

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
                                controller.updateAgeRange(
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
                    controller.updateFilter(FilterType.age);
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
    // Reset price range to valid values before showing dialog
    controller.updatePriceRange(0, 10000); // Set initial values within bounds

    Get.bottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
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
                      // Ensure values are within bounds
                      final minPrice =
                          controller.minPrice.value.clamp(0.0, 10000.0);
                      final maxPrice =
                          controller.maxPrice.value.clamp(minPrice, 10000.0);

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
                                controller.updatePriceRange(
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
                    controller.updateFilter(FilterType.budget);
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
