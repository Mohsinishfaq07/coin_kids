import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';

import 'package:coin_kids/presentation/controllers/parent/change_language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeLanguage extends GetView<ChangeLanguageController> {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParentAppBar(
        title: "change_language".tr,
        centerTitle: false,
        showBackButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "select_language".tr,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h),

                // Language options
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.languages.length,
                    itemBuilder: (context, index) {
                      final language = controller.languages[index];
                      final locale = language['locale'] as Locale;

                      return Obx(() => _buildLanguageItem(
                            flag: language['flag'],
                            name: language['name'],
                            locale: locale,
                            isSelected:
                                controller.selectedLocale.value.languageCode ==
                                    locale.languageCode,
                          ));
                    },
                  ),
                ),

                // SizedBox(height: 20.h),
                //
                // // Apply button
                // Center(
                //   child: AppButton(
                //     backgroundColor: AppColors.buttonPrimary,
                //     onPressed: controller.isLoading.value
                //         ? () {}
                //         : () {
                //             Get.back(); // Return to previous screen
                //           },
                //     child: Text('apply_changes'.tr),
                //   ),
                // ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLanguageItem({
    required String flag,
    required String name,
    required Locale locale,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: controller.isLoading.value
          ? null
          : () => controller.changeLanguage(locale),
      child: Opacity(
        opacity: controller.isLoading.value ? 0.5 : 1.0,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.buttonPrimary
                  : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              // Flag
              Container(
                padding: EdgeInsets.all(8.r),
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
              SizedBox(width: 12.w),

              // Language name
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Radio button
              Container(
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.buttonPrimary
                        : AppColors.textPrimary,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.buttonPrimary,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
