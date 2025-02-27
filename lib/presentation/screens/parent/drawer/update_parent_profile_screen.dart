import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/update_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UpdateParentProfile extends GetView<UpdateProfileController> {
  UpdateParentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Update Profile",
        centerTitle: false,
        showBackButton: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Birthday",
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12.h),
                Obx(() {
                  return CustomTextField(
                    enabled: !controller.isLoading.value,
                    hintText: controller.birthday.value == null
                        ? controller.formatDate(
                            DateTime.fromMillisecondsSinceEpoch(controller.appState.currentParent.value!.dob),
                          )
                        : controller.formatDate(controller.birthday.value!),
                    titleText: 'Birthday',
                    suffixIcon: Icons.calendar_month,
                    onSuffixTap: () async {
                      if (controller.isLoading.value) return;
                      
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.fromMillisecondsSinceEpoch(controller.appState.currentParent.value!.dob),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        controller.birthday.value = pickedDate;
                      }
                    },
                  );
                }),
                SizedBox(height: 25.h),
                Text(
                  "Full Name",
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12.h),
                Obx(() => CustomTextField(
                  enabled: !controller.isLoading.value,
                  titleText: 'Full name',
                  hintText: controller.appState.currentParent.value!.name,
                  onChanged: (value) {
                    controller.parentName.value = value.trim();
                  },
                )),
                SizedBox(height: 23.h),
                Text("Gender (Optional)",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    )),
                SizedBox(height: 12.h),
                Obx(() => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            if (controller.isLoading.value) return;
                            controller.selectGender(UserGender.Male.name);
                          },
                          child: Container(
                            height: 48.h,
                            width: 154.w,
                            padding: const EdgeInsets.only(
                              top: 12.33,
                              left: 20,
                              right: 20,
                              bottom: 13.33,
                            ),
                            decoration: ShapeDecoration(
                              color: controller.selectedGender.value == UserGender.Male.name ? AppColors.buttonPrimary : Colors.white54,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/man_3.svg",
                              height: 24.h,
                              width: 24.w,
                              color: controller.selectedGender.value == UserGender.Male.name ? Colors.white : AppColors.textPrimary,
                            ),
                          )),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            if (controller.isLoading.value) return;
                            controller.selectGender(UserGender.Female.name);
                          },
                          child: Container(
                            height: 48.h,
                            width: 154.w,
                            padding: const EdgeInsets.only(
                              top: 12.33,
                              left: 20,
                              right: 20,
                              bottom: 13.33,
                            ),
                            decoration: ShapeDecoration(
                              color: controller.selectedGender.value == UserGender.Female.name ? AppColors.buttonPrimary : Colors.white54,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/woman.svg",
                              height: 24.h,
                              width: 24.w,
                              color: controller.selectedGender.value == UserGender.Female.name ? Colors.white : AppColors.textPrimary,
                            ),
                          )),
                    ),
                  ],
                )),
                SizedBox(height: 40.h),
                Center(
                  child: Obx(() => AppButton(
                        backgroundColor: AppColors.buttonPrimary,
                        text: controller.isLoading.value ? 'Updating...' : 'Update profile',
                        onPressed: () {
                          if (controller.isLoading.value) return;
                          final currentParent = controller.appState.currentParent.value!;

                          final parentModel = controller.appState.currentParent.value!.copyWith(
                            dob: controller.birthday.value == null ? currentParent.dob : controller.birthday.value!.millisecondsSinceEpoch,
                            name: controller.parentName.value.isEmpty ? currentParent.name : controller.parentName.value,
                            gender: controller.selectedGender.value,
                          );
                          controller.parentService.updateParent(parentModel);
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
