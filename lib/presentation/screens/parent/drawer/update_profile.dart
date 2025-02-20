import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentUpdateProfileScreen extends StatelessWidget {
  Map<String, dynamic>? parentData;
  ParentUpdateProfileScreen({super.key, required this.parentData});

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
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700), // Title color
                ),

                SizedBox(height: 12.h), // Spacing between title and text field
                // Email Input
                Obx(() {
                  return CustomTextField(
                    hintText: firebaseAuthController.birthday.value.isEmpty
                        ? 'Date'
                        : firebaseAuthController.birthday.value,
                    titleText: 'Birthday',
                    suffixIcon: Icons.calendar_month,
                    onSuffixTap: () async {
                      // Open DatePicker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900), // Earliest selectable date
                        lastDate: DateTime.now(), // Latest selectable date
                      );
                      if (pickedDate != null) {
                        firebaseAuthController
                            .setBirthday(pickedDate); // Update Birthday
                      }
                    },
                  );
                }),
                SizedBox(height: 25.h),
                Text(
                  "Full Name",
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700), // Title color
                ),
                SizedBox(height: 12.h),
                // PIN Input
                CustomTextField(
                  titleText: 'Full name',
                  hintText: 'What should we call you ',
                  onChanged: (value) {
                    firebaseAuthController.username.value = value.trim();
                    firebaseAuthController
                        .checkFields(); // Check fields on change
                  },
                ),
                SizedBox(height: 23.h),
                // Gender Selection

                Text("Gender (Optional)",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    )),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => GestureDetector(
                            onTap: () {
                              firebaseAuthController.selectGender("Male");
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
                                color: firebaseAuthController
                                            .selectedGender.value ==
                                        "Male"
                                    ? AppColors.buttonPrimary
                                    : Colors.white54,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: SvgPicture.asset(
                                "assets/man_3.svg",
                                height: 24.h,
                                width: 24.w,
                                color: firebaseAuthController
                                            .selectedGender.value ==
                                        "Male"
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                    Expanded(
                      child: Obx(
                        () => GestureDetector(
                            onTap: () {
                              firebaseAuthController.selectGender("Female");
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
                                color: firebaseAuthController
                                            .selectedGender.value ==
                                        "Female"
                                    ? AppColors.buttonPrimary
                                    : Colors.white54,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: SvgPicture.asset(
                                "assets/woman.svg",
                                height: 24.h,
                                width: 24.w,
                                color: firebaseAuthController
                                            .selectedGender.value ==
                                        "Female"
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                // Forgot Credentials

                // Login Button
                Center(
                    child: AppButton(
                  backgroundColor: AppColors.buttonPrimary,
                  text: 'Update profile',
                  onPressed: () async {
                    if (isButtonEnabled()) {
                      await firestoreOperations.parentFirebaseFunctions
                          .updateParentProfile();
                    }
                  },
                )),
                // SizedBox(height: 40.h),

                // Signup Link
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isButtonEnabled() {
    if (parentData!['name'] != firebaseAuthController.username.value ||
        parentData!['dob'] != firebaseAuthController.birthday.value ||
        parentData!['gender'] != firebaseAuthController.selectedGender.value) {
      // enable button
      return true;
    } else {
      // disable the button
      return false;
    }
  }
}
