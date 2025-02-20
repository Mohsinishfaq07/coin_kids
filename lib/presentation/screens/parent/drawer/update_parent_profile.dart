import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:coin_kids/presentation/screens/common/authentication/parent_signup/parent_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateParentProfile extends StatelessWidget {
  final ParentModel parentData;
  final ParentController _parentController = Get.find<ParentController>();
  final ParentService _parentService = Get.find<ParentService>();

  UpdateParentProfile({super.key, required this.parentData});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller values with current parent data
    firebaseAuthController.parentName.value = parentData.name;
    firebaseAuthController.birthday.value = DateFormat('d MMM, y').format(parentData.dob);
    firebaseAuthController.selectedGender.value = parentData.gender;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Update Profile",
        centerTitle: false,
        showBackButton: true,
      ),
      body: FutureBuilder<ParentModel?>(
        future: _parentService.fetchParentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final parentData = snapshot.data ?? this.parentData;

          return Container(
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
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12.h),
                    Obx(() {
                      return CustomTextField(
                        hintText: firebaseAuthController.birthday.value.isEmpty
                            ? DateFormat('d MMM, y').format(parentData.dob)
                            : firebaseAuthController.birthday.value,
                        titleText: 'Birthday',
                        suffixIcon: Icons.calendar_month,
                        onSuffixTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: parentData.dob,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            firebaseAuthController.setBirthday(pickedDate);
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
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      titleText: 'Full name',
                      hintText: parentData.name,
                      onChanged: (value) {
                        firebaseAuthController.parentName.value = value.trim();
                        firebaseAuthController.checkFields();
                      },
                    ),
                    SizedBox(height: 23.h),
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
                                    color: firebaseAuthController.selectedGender.value == "Male"
                                        ? AppColors.buttonPrimary
                                        : Colors.white54,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/man_3.svg",
                                    height: 24.h,
                                    width: 24.w,
                                    color: firebaseAuthController.selectedGender.value == "Male"
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(width: 14.w),
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
                                    color: firebaseAuthController.selectedGender.value == "Female"
                                        ? AppColors.buttonPrimary
                                        : Colors.white54,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/woman.svg",
                                    height: 24.h,
                                    width: 24.w,
                                    color: firebaseAuthController.selectedGender.value == "Female"
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Center(
                      child: Obx(() => AppButton(
                        backgroundColor: AppColors.buttonPrimary,
                        text: _parentController.isLoading.value ? 'Updating...' : 'Update profile',
                        onPressed: () {
                          if (_parentController.isLoading.value) return;
                          
                          if (isButtonEnabled()) {
                            _parentController.updateParentProfile(originalParent: parentData).then((_) {
                              // Handle successful update
                              Get.back(); // Return to previous screen after successful update
                            }).catchError((error) {
                              ToastUtil.showToast('Error updating profile: $error');
                            });
                          } else {
                            ToastUtil.showToast('No changes made');
                          }
                        },
                      )),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isButtonEnabled() {
    return parentData.name != firebaseAuthController.parentName.value ||
           DateFormat('d MMM, y').format(parentData.dob) != firebaseAuthController.birthday.value ||
           parentData.gender != firebaseAuthController.selectedGender.value;
  }
}
