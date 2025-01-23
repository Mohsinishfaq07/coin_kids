import 'package:coin_kids/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';

import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Wishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final favoriteController = Get.put(FavoriteController());

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        Get.delete<FavoriteController>();

        return false;
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Wish List"),
        body: Container(
            decoration: const BoxDecoration(gradient: AppColors.background),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Obx(() {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 159 / 216, // Aspect ratio for items
                ),
                itemCount:
                    favoriteController.favoriteList.length, // Total items
                itemBuilder: (context, index) {
                  Map<String, dynamic> productDetails = {
                    "imagePath": "assets/image-2.png",
                    "productName": "Mini Fan",
                    "productPrice": "€ 21,99"
                  };
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFCBE4F3)),
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
                        Positioned(
                          left: 10.w,
                          top: 10.h,
                          child: Container(
                            width: 139.w,
                            height: 142.h,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage(productDetails['imagePath']),
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r)),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 13.w,
                          top: 183.h,
                          child: Text(
                            "${productDetails['productPrice']}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 18.sp,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 13.w,
                          top: 163.h,
                          child: Text(
                            "${productDetails['productName']}",
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14.sp,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 108.w,
                          top: 129.h,
                          child: GestureDetector(
                            onTap: () {
                              if (favoriteController
                                  .isFavorite(productDetails)) {
                                favoriteController
                                    .removeFavorite(productDetails);
                              } else {
                                favoriteController.addFavorite(productDetails);
                              }
                            },
                            child: SizedBox(
                              width: 43.80.w,
                              height: 43.80.h,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0.w,
                                    top: 0.h,
                                    child: Container(
                                      width: 43.80.w,
                                      height: 43.80.h,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: OvalBorder(),
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color with transparency
                                            blurRadius:
                                                4, // Spread of the shadow
                                            offset: const Offset(0,
                                                2), // Shadow positioned towards the bottom
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 12.w,
                                    top: 13.h,
                                    child: Obx(() {
                                      return SizedBox(
                                        width: 20.13.w,
                                        height: 20.13.h,
                                        child: favoriteController
                                                .isFavorite(productDetails)
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : SvgPicture.asset(
                                                "assets/shop/favorite.svg"),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            })),
      ),
    );
  }
}
