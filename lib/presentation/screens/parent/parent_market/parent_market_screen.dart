import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/market_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/favorite_controller.dart';
import 'package:coin_kids/presentation/screens/parent/parent_market/parent_wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class ParentMarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final marketController = Get.put(MarketController());

    return Scaffold(
      appBar: const CustomAppBar(title: "Shop Screen"),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.background),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            CustomTextField(
              titleText: "",
              hintText: "e.g Electric bike",
              suffixIconColor: AppColors.iconPrimaryVariant,
              suffixSvgPath: "assets/shop/search.svg",
              onChanged: (query) => marketController.updateSearch(query),
            ),
            SizedBox(height: 26.h),
            Expanded(
              child: Obx(() {
                if (marketController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (marketController.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(marketController.error.value),
                        ElevatedButton(
                          onPressed: () => marketController.fetchProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final products = marketController.filteredProducts;
                if (products.isEmpty) {
                  return const Center(child: Text('No products available'));
                }
                
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 159 / 216,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product);
                  },
                );
              }),
            ),
            _buildWishlistButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(MarketProductModel product) {
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
      child: Stack(
        children: [
          Positioned(
            left: 10.w,
            top: 10.h,
            child: Container(
              width: 139.w,
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
          Positioned(
            left: 13.w,
            top: 163.h,
            child: Text(
              product.name,
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 13.w,
            top: 183.h,
            child: Text(
              "€ ${product.price.toStringAsFixed(2)}",
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 18.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistButton() {
    return GestureDetector(
      onTap: () => Get.to(() => ParentWishlist()),
      child: Container(
        width: 360.w,
        height: 47.h,
        decoration: ShapeDecoration(
          color: Color(0xFF015486),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        child: Center(
          child: Text(
            'My Wishlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w800,
            ),
          ),
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
