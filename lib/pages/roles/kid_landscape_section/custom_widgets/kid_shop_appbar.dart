import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_market/market_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomShopAppBar extends StatelessWidget {
  final MarketController marketController = Get.find<MarketController>();

  CustomShopAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shop",
                style: AppTextStyle.headingLarge,
                overflow: TextOverflow.ellipsis,
              ),
              CustomTextField(
                titleText: "",
                hintText: "e.g Electric bike",
                suffixIconColor: AppColors.iconPrimaryVariant,
                suffixSvgPath: "assets/shop/search.svg",
                onChanged: (value) => marketController.updateSearch(value),
              ),
              SpendingCardContainer(),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Obx(() => _buildFilterButton(
                      "All",
                      marketController.currentFilter.value == FilterType.all,
                      () => _handleFilterTap(FilterType.all),
                    )),
                SizedBox(width: 20.w),
                Obx(() => _buildFilterButton(
                      "Age",
                      marketController.currentFilter.value == FilterType.age,
                      () => _handleFilterTap(FilterType.age),
                    )),
                SizedBox(width: 20.w),
                Obx(() => _buildFilterButton(
                      "Budget",
                      marketController.currentFilter.value == FilterType.budget,
                      () => _handleFilterTap(FilterType.budget),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected, VoidCallback onTap) {
    String svgPath = "";
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
                  AppAssets.dialogueBGSvg, // Add your SVG image path
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
                                  minAge.toDouble(), maxAge.toDouble()),
                              min: 0,
                              max: 18,
                              divisions: 18,
                              activeColor: AppColors.skipButton,
                              inactiveColor:
                                  AppColors.primaryLightColor.withOpacity(0.3),
                              labels:
                                  RangeLabels('$minAge years', '$maxAge years'),
                              onChanged: (RangeValues values) {
                                marketController.updateAgeRange(
                                    values.start.round(), values.end.round());
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
                  buttonText: "OK",
                  showPrefix: true,
                  prefixSvg: AppAssets.kidTickButton, // Add your SVG path
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
                      AppAssets.kidCrossIcons, // Add your SVG path
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
                  AppAssets.dialogueBGSvg, // Add your SVG image path
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
                  buttonText: "OK",
                  showPrefix: true,
                  prefixSvg: AppAssets.kidTickButton, // Add your SVG path
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
                      AppAssets.crossWithDoubleBorderSvg, // Add your SVG path
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
