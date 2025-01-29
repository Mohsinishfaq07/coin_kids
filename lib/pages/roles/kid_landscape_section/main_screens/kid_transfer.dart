import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/transfer_to_savings.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class KidTransferScreen extends StatefulWidget {
  KidTransferScreen({super.key});
//assets/Jar.svg
  @override
  State<KidTransferScreen> createState() => _KidTransferScreenState();
}

class _KidTransferScreenState extends State<KidTransferScreen> {
  final addMoneyController = Get.put(AddMoneyController());

  @override
  void initState() {
    super.initState();
    addMoneyController.fetchSpendingAmount();
    addMoneyController.fetchSavingAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(
            image: AssetImage(AppAssets.kidSectionBG),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        kidBackButton(
                          onTap: () {
                            Get.back();
                          },
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "Kid Transfer",
                          style: AppTextStyle.headingLarge,
                        )
                      ]),
                      GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9E29),
                              borderRadius: BorderRadius.circular(
                                  30.r), // Rounded corners
                              border: Border.all(
                                width: 2.22.w,
                                color: const Color(0xFFD67513),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 12.w,
                                  right: 12.w,
                                  top: 4.h,
                                  bottom: 4.h,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .transparent, // Background color (optional)
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color
                                            blurRadius:
                                                10, // Blur radius for the shadow
                                            offset: Offset(
                                                2, 4), // Shadow position (x, y)
                                          ),
                                        ],
                                        shape: BoxShape
                                            .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/backButton.svg",
                                        height: 10.h,
                                        width: 10.w,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 0.5,
                                    top: 0.29,
                                    child: Image.asset(
                                      "assets/Button_shadow.png",
                                      height: 8.h,
                                    )),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    final spendingAmount =
                        addMoneyController.spendingAmount.value;

                    if (spendingAmount != 0) {
                      return Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/jar_home.png", // Replace with your filled jar asset
                            height: 100.h,
                            width: 140.w,
                          ),
                          Positioned(
                            bottom: 36.h,
                            left: 34.w,
                            child: Center(
                                child: Text(
                              'Spendings',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF015486),
                                fontSize: 18.sp,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w800,
                                height: 2.44,
                              ),
                            )),
                          ),
                          // SizedBox(height: 10.h),
                          Positioned(
                              bottom: 1.h,
                              left: 30.w,
                              child: Center(
                                child: Container(
                                  width: 88.85.w,
                                  height: 16.h,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.69.w, vertical: 2.h),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.53.w,
                                          color: Color(0xFF015486)),
                                      borderRadius:
                                          BorderRadius.circular(51.33.r),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3F6169D3),
                                        blurRadius: 2.60,
                                        offset: Offset(-1.30, 1.95),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '\$$spendingAmount',
                                              style: TextStyle(
                                                color: Color(0xFF015486),
                                                fontSize: 15.83.sp,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '€',
                                              style: TextStyle(
                                                color: Color(0xFF015486),
                                                fontSize: 15.83.sp,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );
                    }
                    // If spendingAmount is greater than 0, show jar with spending amount
                    else {
                      return SizedBox.shrink();
                    }
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(TransferToSavings(
                              isSpending: true.obs,
                            ));
                          },
                          child: Image.asset(
                            "assets/arrow_saving.png",
                            width: 130.w,
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(TransferToSavings(
                              isSpending: false.obs,
                            ));
                          },
                          child: Image.asset(
                            "assets/arow_spending.png",
                            width: 130.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    final savingAmount = addMoneyController.savingAmount.value;

                    if (savingAmount != 0) {
                      return Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/jar_home.png", // Replace with your filled jar asset
                            height: 100.h,
                            width: 140.w,
                          ),
                          Positioned(
                            bottom: 36.h,
                            left: 34.w,
                            child: Center(
                                child: Text(
                              'Savings',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF015486),
                                fontSize: 18.sp,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w800,
                                height: 2.44,
                              ),
                            )),
                          ),
                          Positioned(
                              bottom: 1.h,
                              left: 30.w,
                              child: Center(
                                child: Container(
                                  width: 88.85.w,
                                  height: 16.h,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.69.w, vertical: 2.h),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.53.w,
                                          color: Color(0xFF015486)),
                                      borderRadius:
                                          BorderRadius.circular(51.33.r),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3F6169D3),
                                        blurRadius: 2.60,
                                        offset: Offset(-1.30, 1.95),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '\$$savingAmount',
                                              style: TextStyle(
                                                color: Color(0xFF015486),
                                                fontSize: 15.83.sp,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '€',
                                              style: TextStyle(
                                                color: Color(0xFF015486),
                                                fontSize: 15.83.sp,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );
                    }
                    // If spendingAmount is greater than 0, show jar with spending amount
                    else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
