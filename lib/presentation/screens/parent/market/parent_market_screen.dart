import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/parent/market_filter_chips.dart';
import 'package:coin_kids/presentation/components/parent/market_filter_dialogs.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_market_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentMarketScreen extends GetView<ParentMarketController> {
  const ParentMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParentAppBar(
        title: "Market",
      ),
      body: Stack(
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
                            padding: EdgeInsets.only(bottom: 80.h),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.w,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              mainAxisExtent: 240.h,
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
                onTap: () => Get.toNamed(Routes.parentWishlist),
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
    Get.dialog(
      AgeRangeDialog(
        selectedRange: controller.selectedAgeRange.value,
        onSelect: controller.setAgeRange,
      ),
    );
  }

  void _showBudgetDialog(ParentMarketController controller) {
    Get.dialog(
      RangeFilterDialog(
        title: 'Select Budget Range',
        minValue: controller.minBudget.value,
        maxValue: controller.maxBudget.value,
        currentMin: controller.selectedMinBudget.value,
        currentMax: controller.selectedMaxBudget.value,
        onSelect: controller.setBudgetRange,
        labelFormat: (value) => '€${value.toStringAsFixed(0)}',
      ),
    );
  }

  void _showRatingDialog(ParentMarketController controller) {
    Get.dialog(
      RangeFilterDialog(
        title: 'Select Rating Range',
        minValue: controller.minRating.value,
        maxValue: controller.maxRating.value,
        currentMin: controller.selectedMinRating.value,
        currentMax: controller.selectedMaxRating.value,
        onSelect: controller.setRatingRange,
        labelFormat: (value) => value.toStringAsFixed(1),
      ),
    );
  }

  Widget _buildProductCard(MarketProductModel product) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.parentProductDetails, arguments: product);
      },
      child: Container(
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
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Container(
                width: double.infinity,
                height: 142.h,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Text(
                product.name,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "€ ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 18.sp,
                      fontFamily: 'Open Sans',
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
                      onTap: () => controller.toggleWishlist(product),
                      child: SvgPicture.asset(
                        Assets.icFavorite,
                        width: 24.w,
                        height: 24.w,
                        colorFilter: ColorFilter.mode(controller.isInWishlist(product.id!) ? AppColors.colorPrimary : Colors.grey[400]!, BlendMode.srcIn),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerController extends GetxController {
  var selectedIndex = 0.obs;

  void selectContainer(int index) {
    selectedIndex.value = index;
  }
}
