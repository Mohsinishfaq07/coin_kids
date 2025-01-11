import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final containerController = Get.put(ContainerController());
    final List<String> svgPaths = [
      "assets/shop/all.svg",
      "assets/shop/calendar_month.svg",
      "assets/shop/people.svg",
      "assets/shop/donut_small.svg"
    ];
    final List<String> containerNames = ["All", "Age", "Preference", "Budget"];

    return Scaffold(
      appBar: const CustomAppBar(title: "Shop Screen"),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.background),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            const CustomTextField(
              titleText: "",
              hintText: "e.g Electric bike",
              suffixIconColor: AppColors.iconPrimaryVariant,
              suffixSvgPath: "assets/shop/search.svg",
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              height: 32.h, // Height for the horizontal ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: svgPaths.length, // Number of containers
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      containerController.selectContainer(index);
                    },
                    child: Obx(() {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          color:
                              containerController.selectedIndex.value == index
                                  ? AppColors.buttonPrimary
                                  : const Color(0xFF848484),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(1.8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 30.h,
                                height: 30.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: SvgPicture.asset(
                                      svgPaths[index],
                                      width: 16.h,
                                      height: 16.w,
                                      color: containerController
                                                  .selectedIndex.value ==
                                              index
                                          ? AppColors.buttonPrimary
                                          : const Color(0xFF848484),
                                    ),
                                  ),
                                ),
                              ),
                              // Space between icons and text
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  containerNames[index],
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.white),
                                ),
                              ),
                              Container(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            SizedBox(
              height: 26.h,
            ),
            // Container with the selected item
            Expanded(
              child: Obx(() {
                switch (containerController.selectedIndex.value) {
                  case 0:
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 159 / 216, // Aspect ratio for items
                      ),
                      itemCount: 8, // Total items
                      itemBuilder: (context, index) {
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
                                    image: const DecorationImage(
                                      image: AssetImage("assets/image-2.png"),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.r)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 13.w,
                                top: 183.h,
                                child: Text(
                                  '€ 21,99',
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
                                  'Mini Fan',
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
                                  onTap: () {},
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
                                          child: Container(
                                            width: 20.13.w,
                                            height: 20.13.h,
                                            child: SvgPicture.asset(
                                                "assets/shop/favorite.svg"),
                                          ),
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

                  case 1:
                    return Container(
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          "Content 2",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  case 2:
                    return Container(
                      color: Colors.orange,
                      child: Center(
                        child: Text(
                          "Content 3",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  default:
                    return SizedBox.shrink();
                }
              }),
            ),
            Container(
              width: 360.w,
              height: 47.h,
              decoration: const ShapeDecoration(
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
            )
          ],
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
