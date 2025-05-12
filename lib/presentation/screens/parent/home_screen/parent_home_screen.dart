import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParentsHomeScreen extends GetView<ParentHomeController> {
  const ParentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.h,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
          backgroundColor: const Color(0xFFCAF0FF),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.analytics.logDrawerClick(
                    AnalyticsScreenNames.parentHome,
                    AnalyticsScreenNames.parentHome,
                    AnalyticsScreenNames.parentDrawerScreen,
                  );
                  print("parent drawer called ");
                  Get.toNamed(Routes.parentDrawer);
                },
                child: Obx(
                  () {
                    return CircleAvatarWidget(
                      imagePath: controller.appState.currentParent.value?.imageUrl ?? "",
                      imageType: ImageType.network,
                      backgroundColor: AppColors.iconPrimary,
                      size: 40,
                    );
                  },
                ),
              ),
              SizedBox(width: 7.5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Text(
                      controller.appState.currentParent.value?.name ?? "Null",
                      style: AppTextStyle.headingMedium.copyWith(fontWeight: FontWeight.w800),
                    );
                  }),
                  Text("Welcome 👋", style: AppTextStyle.bodySmall)
                ],
              ),
            ],
          ),
        ),
        body: Container(
          height: Get.height,
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                // Show loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!controller.appState.hasKid.value) {
                // No kids available
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 51.h,
                            bottom: 81.h,
                          ),
                          child: SvgPicture.asset(
                            Assets.appIconText,
                            height: 50.h,
                          ),
                        ),
                        Container(
                          width: 328.w,
                          decoration: ShapeDecoration(
                            color: AppColors.cardPrimary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1.w, color: AppColors.cardBorder),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            shadows: [
                              BoxShadow(color: const Color(0x0F000000), blurRadius: 6.r, offset: const Offset(0, 0), spreadRadius: 0),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 12.h),
                                Text("Almost There!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: CustomThemeData().primaryButtonColor, fontSize: 18.sp)),
                                SizedBox(height: 12.h),
                                Text("Starting by adding your first child.",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: CustomThemeData().primaryTextColor, fontWeight: FontWeight.w800, fontSize: 14.sp)),
                                SizedBox(height: 22.h),
                                AppButton(
                                  size: Size(0.4.sw, 50),
                                  onPressed: () async {
                                    await controller.analytics.logAddChildAttempt(
                                        AnalyticsScreenNames.parentHome, AnalyticsScreenNames.roleSelection, AnalyticsScreenNames.parentAddKidScreen);

                                    Get.toNamed(Routes.parentAddChild);
                                  },
                                  child: Text("Add Child", style: AppTextStyle.appButton),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Display list of kids
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: SvgPicture.asset(
                          Assets.appIconText,
                          height: 50,
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Family Profiles ',
                            style: TextStyle(
                              color: const Color(0xFF015486),
                              fontSize: 14.sp,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            controller.kidsList.length < 2 ? controller.kidsList.length + 1 : 2,
                            (index) {
                              if (index == controller.kidsList.length) {
                                // Last item: Add circle
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await controller.analytics.logAlreadyAddedChildAttempt(AnalyticsScreenNames.parentHome);

                                      ToastUtil.showToast("You have already added a child");
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColors.iconDisabled, width: 2.w),
                                            borderRadius: BorderRadius.circular(40.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(9.h),
                                            child: Icon(
                                              weight: 2.w,
                                              Icons.add_rounded, // Add icon
                                              color: AppColors.iconDisabled,
                                              size: 30.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Add Member\n',
                                                style: TextStyle(
                                                  color: AppColors.iconDisabled,
                                                  fontSize: 11.sp,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.38,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '(Coming soon)',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10.sp,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await controller.analytics.logKidProfileClicked(
                                        AnalyticsScreenNames.parentHome,
                                        AnalyticsScreenNames.kidProfileScreen,
                                      );

                                      Get.toNamed(Routes.parentKidProfile);
                                    },
                                    child: Column(
                                      children: [
                                        Obx(() {
                                          return CircleAvatarWidget(
                                            border: Border.all(color: AppColors.buttonPrimary, width: 2.w),
                                            imagePath: controller.appState.currentKid.value?.avatar ?? "",
                                            imageType: ImageType.network,
                                            errorAsset: Assets.icAvatarPlaceholder,
                                            size: 52,
                                          );
                                        }),
                                        SizedBox(height: 6.h),
                                        Obx(() {
                                          return Text(
                                            controller.appState.currentKid.value?.name ?? "",
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 13.sp,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              height: 1.38,
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: Container(
                            // height: 200.h,
                            // width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFCBE5F4),
                                ),
                                color: const Color(0xFFEDFAFF),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height * 0.03,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButton(
                                    onPressed: ()async {
                                      await controller.analytics.logQuickTransferButtonClick(
                                        AnalyticsScreenNames.parentHome,
                                        AnalyticsScreenNames.kidProfileScreen,
                                      );
                                      Get.toNamed(Routes.parentQuickTransfer);
                                    },
                                    size: Size(0.5.sw, 50),
                                    child: Text(
                                      "Quick Transfer",
                                      style: AppTextStyle.appButton,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.03,
                                  ),
                                  // const SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.height * 0.06,
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Send ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                              text: 'or ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600)),
                                          TextSpan(
                                              text: 'remove ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600)),
                                          TextSpan(
                                              text: 'money from your child\'s account',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
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
              );
            },
          ),
        ));
  }
}
