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
                onTap: () {
                  Get.toNamed(Routes.parentDrawer);
                },
                child: Obx(
                  () {
                    return CircleAvatarWidget(
                      imagePath: controller.appState.currentParent.value?.imageUrl ?? "",
                      imageType: ImageType.network,
                      backgroundColor: AppColors.iconPrimary,
                      size: 40.r,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 12.h),
                              Text("Almost There!", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: CustomThemeData().primaryButtonColor, fontSize: 18.sp)),
                              SizedBox(height: 12.h),
                              Text("Starting by adding your first child.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomThemeData().primaryTextColor, fontWeight: FontWeight.w800, fontSize: 14.sp)),
                              SizedBox(height: 26.h),
                              AppButton(
                                size: Size(0.5.sw, 50.h),
                                onPressed: () {
                                  Get.toNamed(Routes.parentAddChild);
                                },
                                child: Text("Add Child", style: AppTextStyle.appButton),
                              )
                            ],
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
                        height: 150.h, // Set a fixed height for the horizontal list
                        child: Obx(() {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.kidsList.length < 2 ? controller.kidsList.length + 1 : 2,
                            itemBuilder: (context, index) {
                              if (index == controller.kidsList.length) {
                                // Last item: Add circle
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.kidsList.isNotEmpty) {
                                        ToastUtil.showToast("You have already added a child");
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColors.iconDisabled, width: 2),
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Icon(
                                              Icons.add, // Add icon
                                              color: AppColors.iconDisabled,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          'Add Member\n(Coming soon)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.iconDisabled,
                                            fontSize: 13.sp,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w600,
                                            height: 1.38,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.parentKidProfile);
                                    },
                                    child: Column(
                                      children: [
                                        Obx(() {
                                          return CircleAvatarWidget(
                                            imagePath: controller.appState.currentKid.value?.avatar ?? "",
                                            imageType: ImageType.network,
                                            errorAsset: Assets.icAvatarPlaceholder,
                                            size: 50.r,
                                          );
                                        }),
                                        SizedBox(height: 10.h),
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
                          );
                        }),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: Container(
                            height: 200.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFCBE5F4),
                                ),
                                color: const Color(0xFFEDFAFF),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.parentQuickTransfer);
                                  },
                                  size: Size(183.w, 50.h),
                                  child: Text(
                                    "Quick Transfer",
                                    style: AppTextStyle.appButton,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Send ',
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().primaryButtonColor, fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(text: 'or ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600)),
                                        TextSpan(text: 'remove ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().primaryButtonColor, fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: 'money from your child\'s account',
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().secondaryTextColor, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
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
