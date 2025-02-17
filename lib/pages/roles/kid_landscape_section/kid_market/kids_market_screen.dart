import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'market_controller.dart';
import '../services/wishlist_service.dart';
import 'widgets/product_card.dart';

class KidsMarketScreen extends GetView<MarketController> {
  final WishlistService _wishlistService = WishlistService();

  KidsMarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();

    return Obx(
      () => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = controller.filteredProducts[index];
                        return Container(
                          width: 200.w,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: ProductCard(
                            product: product,
                            wishlistService: _wishlistService,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
