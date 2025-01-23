import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/common_funcitons.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/vertical_navigation_bar.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/select_jar_color.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class KidHomePage extends StatelessWidget {
  const KidHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    setOrientationAndStatusBar();
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      // appBar: kidsAppBar(leadingWidget: appBarWidget()),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(
            image: AssetImage(AppAssets.kidSectionBG),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kidAvatarContainer(),
                  Row(
                    children: [
                      cardContainerIcon(),
                      SizedBox(
                        width: 10.w,
                      ),
                      coinLockedWidget(),
                      SizedBox(
                        width: 10.w,
                      ),
                      totalBalanceWidget()
                    ],
                  )
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  VerticalNavBar(),
                  SizedBox(
                    width: 130.w,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() =>   SelectJarColorScreen());
                          },
                          child: SvgPicture.asset(
                            AppAssets.kidEmptyJarIcon,
                            height: 100.h,
                            width: 132.w,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 51.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: AppColors.textOnPrimary,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(80.r),
                                  topRight: Radius.circular(80.r)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(2.h),
                                  child: SvgPicture.asset(
                                    "assets/parent.svg",
                                    height: 30.h,
                                  ),
                                ),
                                Text(
                                  "Parent\nZone",
                                  style: AppTextStyle.labelSmall.copyWith(
                                      color: AppColors.KidZoneParent,
                                      fontWeight:
                                          MyFontWeight.ExtraBold.fontWeight),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget kidAvatarContainer() {
    return Container(
      height: 27.h,
      width: 120.w,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Container(
              height: 20.h,
              width: 94.w,
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                ),
                border: Border.all(color: const Color(0xff0095e5), width: 2.w),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('kids') // Replace with your collection name
                      .doc('kids') // Fetch the document by the kid's ID
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Loading...",
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        "Error",
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data?.data() == null) {
                      return Text(
                        "No Data",
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
                      );
                    }

                    // Retrieve the name of the kid
                    final kidName =
                        snapshot.data!['name'] as String? ?? "Unknown";

                    return Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        kidName,
                        style: AppTextStyle.headingMedium
                            .copyWith(color: AppColors.textOnPrimary),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: -12.h,
            left: 0.w,
            child: Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage(
                        "assets/child_avatar_image_pngs/Frame 1.png")),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // card container icon
  cardContainerIcon() {
    return SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 28.w, top: 4.h),
            child: Container(
              height: 19.h,
              width: 96.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(14.r),
                ),
                border: Border.all(color: AppColors.textPrimary, width: 2.w),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                ),
                child: Text(
                  "€00",
                  style: AppTextStyle.headingMedium
                      .copyWith(color: AppColors.textOnPrimary),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0.w,
            child: Container(
              color: Colors.transparent,
              height: 25.h,
              // width: 80.w,
              child: SvgPicture.asset(AppAssets.kidCardICon, height: 25.h),
            ),
          ),
        ],
      ),
    );
  }

  coinLockedWidget() {
    return SizedBox(
      height: 27.h,
      width: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            fit: StackFit.loose,
            children: [
              Positioned(
                top: 5.h,
                right: 6.w,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 18.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(4.r),
                      border:
                          Border.all(color: AppColors.textPrimary, width: 2.0),
                    ),
                    child: Text(
                      "500",
                      style: AppTextStyle.headingMedium
                          .copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -4.w,
                top: 2.h,
                child: Container(
                  color: Colors.transparent,
                  height: 24.h,
                  // width: 80.w,
                  child: SvgPicture.asset(AppAssets.kidCoinIcon, height: 24.h),
                ),
              ),

              // Align(
              //   alignment: Alignment.topLeft,
              //   child: SvgPicture.asset(AppAssets.kidCoinIcon),
              // ),
              Container(
                height: 28.9.h,
                width: 120.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xff000000).withOpacity(0.46)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppAssets.kidLockIcon, height: 24.h),
          ),
        ],
      ),
    );
  }

  totalBalanceWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: SizedBox(
        height: 27.h,
        width: 120.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Blue Container
            Positioned(
              top: 5.h,
              right: 10.w,
              bottom: 5.h,
              child: Container(
                height: 18.h,
                width: 96.w,
                decoration: BoxDecoration(
                  color: AppColors.iconPrimaryVariant,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(right: 8.w, left: 8.w),
                  child: Text(
                    '€00',
                    style: AppTextStyle.headingMedium
                        .copyWith(color: AppColors.textOnPrimary),
                  ),
                ),
              ),
            ),

            Positioned(
              right: -2.w,
              child: SvgPicture.asset(
                'assets/kidRoleIcons/kidCoinIcon.svg',
                height: 22.h,
                width: 22.w,
              ),
            ),
            Positioned(
                left: 5.w,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xff19B859),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.h),
                    child: SvgPicture.asset(
                      'assets/add_icon.svg',
                      height: 7.h,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
