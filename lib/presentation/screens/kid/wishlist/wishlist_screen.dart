import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/landscape_orientation.dart';
import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/controllers/kid/market_controller.dart';
import 'package:coin_kids/presentation/screens/kid/market/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class KidWishlistScreen extends StatelessWidget {
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final MarketController _marketController = Get.find<MarketController>();
  final RxList<WishlistModel> wishlistItems = <WishlistModel>[].obs;
  final RxBool isLoading = false.obs;

  KidWishlistScreen({Key? key}) : super(key: key);

  Future<void> _navigateToProductDetails(WishlistModel item) async {
    if (item.product == null) return;
    
    Get.to(
      () => ProductDetailsScreen(product: item.product!),
      transition: Transition.rightToLeft,
    );
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
            // Back button and title
            Padding(
              padding: EdgeInsets.only(top: 10.h, left: 10.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  kidBackButton(onTap: () => Get.back()),
                  SizedBox(width: 20.w),
                  Text(
                    "My Wishlist",
                    style: AppTextStyle.headingLarge,
                  ),
                ],
              ),
            ),

            // Wishlist content
            Expanded(
              child: Obx(() {
                if (isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (wishlistItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 48.w, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text(
                          'Your wishlist is empty',
                          style: AppTextStyle.bodyLarge.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 5,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                  ),
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index];
                    final product = item.product;
                    if (product == null) return const SizedBox.shrink();

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
                                  // Product Image
                                  if (product.imageUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14.r),
                                      child: Image.network(
                                        product.imageUrl,
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
                                  
                                  // Product Details
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 12.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: AppTextStyle.bodyLarge.copyWith(fontSize: 16.sp),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            product.formattedPrice,
                                            style: AppTextStyle.bodyMedium.copyWith(
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            item.timeAgo,
                                            style: AppTextStyle.bodySmall.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (item.isPriority)
                                            Container(
                                              margin: EdgeInsets.only(top: 4.h),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 2.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.textHighlighted.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                              child: Text(
                                                'Priority',
                                                style: AppTextStyle.bodySmall.copyWith(
                                                  color: AppColors.textHighlighted,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Remove Button
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      item.isPriority ? Icons.star : Icons.star_border,
                                      color: item.isPriority ? Colors.amber : Colors.grey,
                                    ),
                                    onPressed: () => _togglePriority(item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.grey),
                                    onPressed: () => _removeFromWishlist(item),
                                  ),
                                ],
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
      isLoading.value = true;
      final authService = Get.find<AuthService>();
      final String? kidId = authService.user.value?.uid;
      if (kidId == null) {
        Get.snackbar(
          'Error',
          'User not authenticated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      final items = await _wishlistService.fetchKidWishlist(kidId);
      wishlistItems.value = items;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _removeFromWishlist(WishlistModel item) async {
    try {
      if (item.id == null) return;
      await _wishlistService.removeFromWishlistModel(item.id!);
      wishlistItems.removeWhere((element) => element.id == item.id);
      Get.snackbar(
        'Success',
        'Removed from wishlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _togglePriority(WishlistModel item) async {
    try {
      if (item.id == null) return;
      await _wishlistService.togglePriority(item.id!);
      await _loadWishlist(); // Reload to get updated priority status
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update priority',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
