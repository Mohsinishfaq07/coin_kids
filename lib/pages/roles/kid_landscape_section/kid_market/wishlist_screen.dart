import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../app_assets.dart';
import '../../../../theme/color_theme.dart';
import '../../../../theme/text_theme.dart';
import '../common_funcitons.dart/landscape_orientation.dart';
import '../custom_widgets/kid_back_button.dart';
import '../services/wishlist_service.dart';
import '../models/wishlist_model.dart';
import 'market_controller.dart';
import 'product_details_screen.dart';

class KidWishlistScreen extends StatelessWidget {
  final WishlistService _wishlistService = WishlistService();
  final MarketController _marketController = Get.find<MarketController>();
  final RxList<WishlistModel> wishlistItems = <WishlistModel>[].obs;

  KidWishlistScreen({Key? key}) : super(key: key);

  Future<void> _navigateToProductDetails(WishlistModel item) async {
    try {
      final product = await _marketController.getProductById(item.productId);
      if (product != null) {
        Get.to(
          () => ProductDetailsScreen(product: product),
          transition: Transition.rightToLeft,
        );
      } else {
        Get.snackbar(
          'Error',
          'Product not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    landscapeOrientation();
    _loadWishlist();

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(
            image: AssetImage(AppAssets.kidSectionBG),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: EdgeInsets.only(top: 10.h, left: 10.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  kidBackButton(
                    onTap: () {
                      Get.back();
                    },
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    "My WishList",
                    style: AppTextStyle.headingLarge,
                  ),
                ],
              ),
            ),

            // Wishlist content
            Expanded(
              child: Obx(() {
                if (wishlistItems.isEmpty) {
                  return const Center(
                    child: Text('Your wishlist is empty'),
                  );
                }

                return GridView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 5,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                  ),
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index];
                    return GestureDetector(
                      onTap: () => _navigateToProductDetails(item),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        clipBehavior: Clip.none,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: Row(
                                children: [
                                  if (item.imageUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14.r),
                                      child: Image.network(
                                        item.imageUrl,
                                        width: 100.w,
                                        height: 100.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Icon(Icons.error, size: 60.w),
                                      ),
                                    )
                                  else
                                    Icon(Icons.shopping_bag, size: 60.w),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 12.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: AppTextStyle.bodyLarge
                                                .copyWith(fontSize: 16.sp),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '\$${item.price.toStringAsFixed(2)}',
                                            style: AppTextStyle.bodyMedium
                                                .copyWith(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () => _removeFromWishlist(item),
                                child: SvgPicture.asset("assets/small.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadWishlist() async {
    try {
      final items = await _wishlistService.fetchWishlist();
      wishlistItems.value = items;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _removeFromWishlist(WishlistModel item) async {
    try {
      await _wishlistService.removeFromWishlist(item.id, item.productId);
      wishlistItems.removeWhere((element) => element.id == item.id);
      Get.snackbar(
        'Success',
        'Removed from wishlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
