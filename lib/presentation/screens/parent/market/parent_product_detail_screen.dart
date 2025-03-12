import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentProductDetailScreen extends StatelessWidget {
  final MarketProductModel product;

  const ParentProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  Future<void> _launchProductUrl() async {
    final Uri url = Uri.parse(product.url);
    try {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open product link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParentAppBar(
        showBackButton: true,
        title: "Product Details",
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.background),
          child: Column(
            children: [
              // Product Image
              Container(
                width: 150.w,
                height: 200.h,
                margin: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Product Details
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyle.headingMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ...product.about
                          .map((about) => Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Text(
                                  about,
                                  style: AppTextStyle.bodyLarge,
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),

              // Bottom Card
              Container(
                margin: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _launchProductUrl,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                Assets.amazon,
                                width: 92.w,
                              ),
                              Text(
                                '€${product.price.toStringAsFixed(2)}',
                                style: AppTextStyle.headingLarge,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  'Free delivery by Amazon.\nOrder within 2 days.',
                                  style: AppTextStyle.bodyLarge,
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: AppColors.colorPrimary,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
