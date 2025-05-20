import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/update_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UpdateParentProfile extends GetView<UpdateProfileController> {
  UpdateParentProfile({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Set default gender when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.selectedGender.value.isEmpty) {
        final currentGender = controller.appState.currentParent.value?.gender;
        controller.selectGender(currentGender ?? UserGender.male.name);
      }
    });

    return Scaffold(
      appBar: ParentAppBar(
        title: "Update Profile",
        centerTitle: false,
        showBackButton: true,
        onBackPressed: () async {
          await controller.analytics.backPressClicked(AnalyticsScreenNames.parentDrawerScreen);
          Get.back();
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Birthday",
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12.h),
                Obx(() {
                  return ParentTextField(
                    hintText: controller.birthday.value == null
                        ? (controller.appState.currentParent.value?.dob == null || controller.appState.currentParent.value?.dob == 0
                            ? "Not specified"
                            : controller.formatDate(
                                DateTime.fromMillisecondsSinceEpoch(controller.appState.currentParent.value!.dob!),
                              ))
                        : controller.formatDate(controller.birthday.value!),
                    enabled: false,
                    suffixIcon: Icons.calendar_month,
                    suffixIconColor: AppColors.textPrimary,
                    onSuffixTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.fromMillisecondsSinceEpoch(controller.appState.currentParent.value?.dob ?? 0),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData(
                              primaryColor: AppColors.buttonPrimary,
                              colorScheme: ColorScheme.light(
                                primary: AppColors.buttonPrimary,
                                onPrimary: Colors.white,
                                onSurface: AppColors.textPrimary,
                                surface: Colors.white,
                                secondary: AppColors.buttonPrimary.withValues(alpha: 0.1),
                                onSecondary: AppColors.buttonPrimary,
                              ),
                              // dialogBackgroundColor: Colors.white,
                              textTheme: TextTheme(
                                titleMedium: AppTextStyle.bodyMedium,
                                labelMedium: AppTextStyle.bodyMedium,
                                bodyMedium: AppTextStyle.bodyMedium,
                                bodyLarge: AppTextStyle.bodyLarge,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  textStyle: AppTextStyle.bodyMedium,
                                  foregroundColor: AppColors.buttonPrimary,
                                ),
                              ),
                              datePickerTheme: DatePickerThemeData(
                                backgroundColor: Colors.white,
                                headerBackgroundColor: AppColors.buttonPrimary,
                                headerForegroundColor: Colors.white,
                                weekdayStyle: TextStyle(color: AppColors.textPrimary),
                                dayStyle: TextStyle(color: AppColors.textPrimary),
                                todayBorder: BorderSide(color: AppColors.buttonPrimary, width: 1),
                                dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return AppColors.buttonPrimary;
                                  }
                                  if (states.contains(MaterialState.hovered)) {
                                    return AppColors.buttonPrimary.withValues(alpha: 1);
                                  }
                                  return null;
                                }),
                                yearStyle: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),
                            child: child!,
                          );
                        },
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
                Obx(() => ParentTextField(
                      hintText: controller.appState.currentParent.value?.name ?? "",
                      onChanged: (value) {
                        controller.parentName.value = value.trim();
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return null; // Allow empty as it will use existing name
                        }
                        if (value!.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        if (value.length > 50) {
                          return 'Name must be less than 50 characters';
                        }
                        return null;
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
                              onTap: () => controller.selectGender(UserGender.male.name),
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
                                  color: controller.selectedGender.value == UserGender.male.name ? AppColors.buttonPrimary : Colors.white54,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  Assets.icMale,
                                  height: 24.h,
                                  width: 24.w,
                                  colorFilter: ColorFilter.mode(
                                      controller.selectedGender.value == UserGender.male.name ? Colors.white : AppColors.textPrimary,
                                      BlendMode.srcIn),
                                ),
                              )),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: GestureDetector(
                              onTap: () => controller.selectGender(UserGender.female.name),
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
                                  color: controller.selectedGender.value == UserGender.female.name ? AppColors.buttonPrimary : Colors.white54,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  Assets.icFemale,
                                  height: 24.h,
                                  width: 24.w,
                                  colorFilter: ColorFilter.mode(
                                      controller.selectedGender.value == UserGender.female.name ? Colors.white : AppColors.textPrimary,
                                      BlendMode.srcIn),
                                ),
                              )),
                        ),
                      ],
                    )),
                Expanded(child: Container()),
                SafeArea(
                  child: Center(
                    child: AppButton(
                      backgroundColor: AppColors.buttonPrimary,
                      size: Size(0.8.sw, 50),
                      child: Text(
                        "Save Changes",
                        style: AppTextStyle.appButton,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await controller.updateProfile();
                          await controller.analytics
                              .buttonClicked(AnalyticsEventNames.updateParentProfileClicked, AnalyticsScreenNames.parentDrawerScreen);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
