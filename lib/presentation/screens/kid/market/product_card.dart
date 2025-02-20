import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'product_details_screen.dart';

class ProductCard extends StatefulWidget {
  final MarketProductModel product;
  final WishlistService _wishlistService;

  const ProductCard({
    Key? key,
    required this.product,
    required WishlistService wishlistService,
  })  : _wishlistService = wishlistService,
        super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    super.initState();
    // Check initial wishlist status
    widget._wishlistService.isInWishlist(widget.product.id!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => ProductDetailsScreen(product: widget.product),
        transition: Transition.rightToLeft,
      ),
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
              spreadRadius: 0,
            )
          ],
        ),
        child: Stack(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: 130.w,
                            color: Colors.grey,
                            child: widget.product.imageUrl.isNotEmpty
                                ? Image.network(
                                    widget.product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.shopping_bag,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.product.name,
                        style: AppTextStyle.bodyLarge
                            .copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // SizedBox(height: 2.h),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Wishlist icon
            Positioned(
              top: 118.w,
              right: 8.w,
              child: Obx(() {
                final isInWishlist =
                    widget._wishlistService.wishlistStatus[widget.product.id] ??
                        false;

                return Container(
                  height: 32.h,
                  width: 32.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      size: 20.sp,
                      color:
                          isInWishlist ? Colors.red : AppColors.textSecondary,
                    ),
                    onPressed: () async {
                      try {
                        if (isInWishlist) {
                          // Get the wishlist document ID and remove
                          final wishlist =
                              await widget._wishlistService.fetchWishlist();
                          final wishlistItem = wishlist.firstWhere(
                            (item) => item.productId == widget.product.id,
                            orElse: () =>
                                throw Exception('Item not found in wishlist'),
                          );
                          await widget._wishlistService.removeFromWishlist(
                              wishlistItem.id!, widget.product.id!);
                          Get.snackbar(
                            'Success',
                            'Removed from wishlist',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          await widget._wishlistService
                              .addToWishlist(widget.product);
                          Get.snackbar(
                            'Success',
                            'Added to wishlist',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
