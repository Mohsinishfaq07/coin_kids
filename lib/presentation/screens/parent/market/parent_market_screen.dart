import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/parent/market_filter_chips.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_market_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/age_filter_dialog.dart';
import 'package:coin_kids/presentation/dialogs/kid/range_slider_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentMarketScreen extends GetView<ParentMarketController> {
  const ParentMarketScreen({super.key});
  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      if (screenWidth < 600) {
        return 2; // small and normal phones
      } else {
        return 3; // large phones / small tablets
      }
    } else {
      // Landscape mode
      final double targetCardWidth = 180.r;
      int count = (screenWidth / targetCardWidth).floor();
      return count.clamp(2, 4);
    }
  }


  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // int crossAxisCount = _calculateCrossAxisCount(screenWidth);
    int crossAxisCount = _calculateCrossAxisCount(context);
    return  LayoutBuilder(builder: ( context, constraints) {
      // final double screenWidth = constraints.maxHeight;
      // final int crossAxisCount = _calculateCrossAxisCount(screenWidth);
      // final double cardWidth = (screenWidth - (crossAxisCount + 1) * 8.w) / crossAxisCount;
      // final double cardHeight =  100.60.h;

      return SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(gradient: AppColors.background),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Obx(() {
                if (!controller.isInitialized.value) {
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
                }
        
                return Column(
                  children: [
                    ParentAppBar(
                      title: "Market",
                    ),
                    ParentTextField(
                      titleText: "",
                      hintText: "e.g Electric bike",
                      suffixIconColor: AppColors.iconPrimaryVariant,
                      suffixSvgPath: Assets.icSearch,
                      onChanged: (query) => controller.updateSearch(query),
                    ),
                    SizedBox(height: 16.h),
                    _buildFilterChips(controller),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: controller.displayProducts.isEmpty
                          ? const Center(child: Text('No products match your filters'))
                          : GridView.builder(

        
                        // padding: EdgeInsets.only(bottom: 80.h),

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                          crossAxisCount: crossAxisCount,

                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                            childAspectRatio:  1/ 1.2,
                        ),
                        itemCount: controller.displayProducts.length,
                        itemBuilder: (context, index) {
                          final product = controller.displayProducts[index];
                          return _buildProductCard(product);
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () async{
      await controller.analytics
          .buttonClicked(AnalyticsEventNames.parentWishlistClicked, AnalyticsScreenNames.parentMarket);
      Get.toNamed(Routes.parentWishlist);

      } ,
                  child: Container(
                    width: 0.8.sw,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      color: AppColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Obx(() {
                        final count = controller.wishlistItemCount.value;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'My Wishlist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (count > 0) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    },);
  }

  Widget _buildFilterChips(ParentMarketController controller) {
    return SingleChildScrollView(
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
            iconPath: Assets.icGender,
            onTap: () => _showAgeRangeDialog(controller),
          ),
          SizedBox(width: 8.w),
          MarketFilterChip(
            label: 'Budget',
            selectedValue: controller.isBudgetFilterActive.value ? '€${controller.selectedMinBudget.value.toStringAsFixed(0)}-${controller.selectedMaxBudget.value.toStringAsFixed(0)}' : null,
            isSelected: controller.isBudgetFilterActive.value,
            iconPath: Assets.icBudget,
            onTap: () => _showBudgetDialog(controller),
          ),
          SizedBox(width: 8.w),
          MarketFilterChip(
            label: 'Rating',
            selectedValue: controller.isRatingFilterActive.value ? '${controller.selectedMinRating.value.toStringAsFixed(1)}-${controller.selectedMaxRating.value.toStringAsFixed(1)}' : null,
            isSelected: controller.isRatingFilterActive.value,
            iconPath: Assets.icStar,
            onTap: () => _showRatingDialog(controller),
          ),
        ],
      ),
    );
  }

  void _showAgeRangeDialog(ParentMarketController controller) {
    AgeFilterDialog.show(
      selectedRange: controller.selectedAgeRange.value,
      onSelect: controller.setAgeRange,
    );
    // Get.dialog(
    //   AgeRangeDialog(
    //     selectedRange: controller.selectedAgeRange.value,
    //     onSelect: controller.setAgeRange,
    //   ),
    // );
  }

  void _showBudgetDialog(ParentMarketController controller) {
    RangeSliderDialog.show(
      title: 'Select Budget Range',
      minValue: controller.minBudget.value,
      maxValue: controller.maxBudget.value,
      currentMin: controller.selectedMinBudget.value,
      currentMax: controller.selectedMaxBudget.value,
      onSelect: controller.setBudgetRange,
      labelFormat: (value) => '€${value.toStringAsFixed(0)}',
    );
    // Get.dialog(
    //   RangeFilterDialog(
    //     title: 'Select Budget Range',
    //     minValue: controller.minBudget.value,
    //     maxValue: controller.maxBudget.value,
    //     currentMin: controller.selectedMinBudget.value,
    //     currentMax: controller.selectedMaxBudget.value,
    //     onSelect: controller.setBudgetRange,
    //     labelFormat: (value) => '€${value.toStringAsFixed(0)}',
    //   ),
    // );
  }

  void _showRatingDialog(ParentMarketController controller) {
    RangeSliderDialog.show(
      title: 'Select Rating Range',
      minValue: controller.minRating.value,
      maxValue: controller.maxRating.value,
      currentMin: controller.selectedMinRating.value,
      currentMax: controller.selectedMaxRating.value,
      onSelect: controller.setRatingRange,
      labelFormat: (value) => value.toStringAsFixed(1),
    );
    // Get.dialog(
    //   RangeFilterDialog(
    //     title: 'Select Rating Range',
    //     minValue: controller.minRating.value,
    //     maxValue: controller.maxRating.value,
    //     currentMin: controller.selectedMinRating.value,
    //     currentMax: controller.selectedMaxRating.value,
    //     onSelect: controller.setRatingRange,
    //     labelFormat: (value) => value.toStringAsFixed(1),
    //   ),
    // );
  }

  Widget _buildProductCard(MarketProductModel product) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.parentProductDetails, arguments: product);
      },
      child: LayoutBuilder(


        builder: (context, constraints) {
      return Container(
         clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCBE4F3)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 6.r,
                offset: Offset(0, 0),
              )
            ],
          ),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment :MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color:Colors.green,
              width: double.infinity,
               height: constraints.maxHeight * 0.66, // ~55% for image
              padding: EdgeInsets.all(10.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment :MainAxisAlignment.spaceBetween,
                crossAxisAlignment :CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(height:1.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "€ ${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18.h,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Obx(() {
                        if (controller.isItemLoading(product.id!)) {
                          return SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorPrimary,
                              ),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () async{
                            await controller.analytics
                                .buttonClicked(AnalyticsEventNames.parentWishlistIconClicked, AnalyticsScreenNames.parentMarket);
                            controller.toggleWishlist(product);
                          } ,
                          child: SvgPicture.asset(
                            Assets.icFavorite,
                            width: 24.w,
                            height: 24.h,
                            colorFilter: ColorFilter.mode(
                              controller.isInWishlist(product.id!)
                                  ? AppColors.colorPrimary
                                  : Colors.grey[400]!,
                              BlendMode.srcIn,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
             SizedBox(height: 1.h),
          ],
        ),
      );
    },
    ),

    );
  }

}

