import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_wishlist_controller.dart';
import 'package:coin_kids/presentation/screens/parent/market/parent_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ParentWishlistScreen extends GetView<ParentWishlistController> {
  ParentWishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParentAppBar(
        showBackButton: true,
        title: "My Wishlist",
        centerTitle: false,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.background),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      controller.error.value,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: controller.fetchWishlist,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.phWishlist,
                    height: 100.h,
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Your wishlist is empty',
                      style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() => ListView.separated(
                  itemCount: controller.wishlistItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = controller.wishlistItems[index];
                    return _buildWishlistItem(item);
                  },
                )),
          );
        }),
      ),
    );
  }

  Widget _buildWishlistItem(WishlistModel item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.product != null) {
            Get.to(() => ParentProductDetailScreen(product: item.product!));
          }
        },
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Delete Button
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: () => controller.removeFromWishlist(item.productId),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),

              // Main Content
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 48.w, 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      width: 65.h,
                      height: 65.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: NetworkImage(item.product?.imageUrl ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product?.name ?? '',
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.product?.about[0] ?? '',
                            style: AppTextStyle.labelSmall.copyWith(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '€${item.product?.price.toStringAsFixed(2) ?? '0.00'}',
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
