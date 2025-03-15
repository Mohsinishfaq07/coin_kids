import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatelessWidget {
  final MarketProductModel product;
  final VoidCallback onWishlistTap;
  final VoidCallback onTap;
  final bool isInWishlist;
  final bool isLoading;

  const ProductCard({
    super.key,
    required this.product,
    required this.onWishlistTap,
    required this.onTap,
    required this.isInWishlist,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate image height proportionally
          final double imageHeight = constraints.maxWidth * 0.8;

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
              children: [
                // Product Image Container
                Container(
                  height: imageHeight,
                  margin: EdgeInsets.all(10.w),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 80.w,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Text(
                      product.name,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14.sp,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(13.w),
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
                      if (isLoading)
                        SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorPrimary,
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: onWishlistTap,
                          child: SvgPicture.asset(
                            Assets.icFavorite,
                            width: 24.w,
                            height: 24.w,
                            colorFilter: ColorFilter.mode(isInWishlist ? AppColors.colorPrimary : Colors.grey[400]!, BlendMode.srcIn),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
