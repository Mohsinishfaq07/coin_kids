import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/overlay/close_button_overlay.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/product_detail_dialog.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_wishlist_controller.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidWishlistScreen extends GetView<KidWishlistController> {
  const KidWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final int crossAxisCount = _calculateCrossAxisCount(screenWidth);
        final double cardWidth = (screenWidth - (crossAxisCount + 1) * 16.w) / crossAxisCount;
        final double cardHeight = cardWidth * 1.2; // Slightly shorter than market cards

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: KidAppBarComponent(
              title: 'My Wishlist',
              onBackPressed: () async {
                await controller.analytics.backPressClicked(AnalyticsScreenNames.kidMarketScreen);
                controller.appBarController.configureForMarket();
                Get.back();
              }),
          body: Container(
            decoration: BoxDecoration(gradient: AppColors.background),
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
                      Text(
                        'Your wishlist is empty',
                        style: AppTextStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 48.w),
                    child: GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.w,
                        childAspectRatio: cardWidth / cardHeight,
                      ),
                      itemCount: controller.wishlistItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.wishlistItems[index];
                        return _buildWishlistItem(item);
                      },
                    ),
                  ),
                  if (controller.showPointer.value)
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTapDown: (_) async {
                          controller.showPointer.value = false;
                          await SharedPreferencesHelper.saveBool(
                            SharedPreferencesHelper.hasSeenWishlistCloseTutorial,
                            true,
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildWishlistItem(WishlistModel item) {
    return Container(
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
          // Main Content
          GestureDetector(
            onTap: () async {
              await controller.analytics
                  .buttonClicked(AnalyticsEventNames.wishlistProductDetailClicked, AnalyticsScreenNames.wishlistProductDetailScreenDialog);

              if (item.product != null) {
                Get.dialog(
                  ProductDetailDialog(
                    product: item.product!,
                    onAddToGoal: () {
                      //  Get.back();
                      controller.addToGoal(item);
                    },
                  ),
                  barrierDismissible: true,
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: NetworkImage(item.product?.imageUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Product Details
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
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
                        const Spacer(),
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
                ),
              ],
            ),
          ),

          // Delete Button - Use a simple IconButton instead of KidButton
          Positioned(
            top: 4.h,
            right: 4.w,
            child: Material(
              elevation: 10,
              color: AppColors.btnColorRed,
              shape: CircleBorder(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    // key: GlobalKeys.closeButtonKey,
                    onTap: () {
                      Get.log("Delete button tapped");
                      ToastUtil.showToast("Removing item from wishlist");
                      controller.removeFromWishlist(item.productId);
                    },
                    customBorder: CircleBorder(),
                    child: Container(
                      width: 28.r,
                      height: 28.r,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close,
                        size: 14.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (controller.showPointer.value) {
                      return Positioned(
                        right: 10.w,
                        bottom: -28.h,
                        child: CloseButtonOverlay(
                          onComplete: () async {
                            controller.completeWishListTutorial();
                          },
                          targetKey: GlobalKeys.closeButtonKey,
                          onTap: () async {
                            controller.completeWishListTutorial();
                            controller.showPointer.value = false;
                            // controller.showPointer.value = false;
                            // await SharedPreferencesHelper.saveBool(
                            //   SharedPreferencesHelper.hasSeenWishlistCloseTutorial,
                            //   true,
                            // );
                          },
                          width: 60.w,
                          height: 60.w,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    final double targetCardWidth = 180.w;
    int count = (screenWidth / targetCardWidth).floor();
    return count.clamp(2, 4); // Minimum 2, maximum 4 items per row
  }
}
