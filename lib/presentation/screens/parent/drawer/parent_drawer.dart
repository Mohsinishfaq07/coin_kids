import 'dart:io';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:coin_kids/presentation/screens/common/authentication/parent_signup/parent_model.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/update_parent_profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class ParentDrawer extends StatefulWidget {
  @override
  State<ParentDrawer> createState() => _ParentDrawerState();
}

class _ParentDrawerState extends State<ParentDrawer> {
  final parentController =
      Get.put(ParentController());
  final ParentService _parentService = Get.find<ParentService>();
  final RxBool isLoading = false.obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    parentController.loadImageFromPreferences();
  }

  Future<void> uploadImageToFirebase(File imageFile, ParentModel parentData) async {
    try {
      isLoading.value = true;
      
      // Show loading indicator
      showDialog(
        context: Get.context!,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Create a unique file name
      String fileName = 'parent_profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      
      // Create a reference to the file location in Firebase Storage
      Reference ref = _storage.ref().child('parent_profiles').child(fileName);
      
      // Create upload task
      UploadTask uploadTask = ref.putFile(imageFile);
      
      // Listen to upload progress and handle errors
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload progress: $progress%');
      }, onError: (error) {
        Get.back(); // Close loading dialog
        ToastUtil.showToast("Upload failed: $error");
        throw error;
      });
      
      // Wait for upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;
      
      // Get the download URL
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      
      // Update the parent model with the new image URL
      final updatedParent = parentData.copyWith(imageUrl: downloadUrl);
      await _parentService.updateParent(updatedParent);
      
      // Save both local path and network URL
      await parentController.saveImageToPreferences(
        localPath: imageFile.path,
        networkUrl: downloadUrl
      );
      
      Get.back(); // Close loading dialog
      ToastUtil.showToast("Profile image updated successfully");
      
    } catch (e) {
      Get.back(); // Close loading dialog if open
      print("Error uploading image: $e");
      ToastUtil.showToast("Failed to upload image. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: AppColors.background,
      ),
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 46.h),
            child: SvgPicture.asset(
              AppAssets.cloudImageSvg,
              width: 360.w,
            ),
          ),
        ),
        FutureBuilder<ParentModel?>(
            future: _parentService.fetchParentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No data found.'));
              }

              final ParentModel parentData = snapshot.data!;
              return drawerWidget(parentData: parentData);
            }),
      ]),
    ));
  }

  // after data fetched widget
  Widget drawerWidget({required ParentModel parentData}) {
    final String formattedDob = DateFormat('d MMM, y').format(parentData.dob);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            // Header with profile information
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        await firebaseAuthController.logout();
                      },
                      child: Container(
                          width: 54.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: AppColors.textPrimary,
                          ),
                          margin: EdgeInsets.all(12.r),
                          child: const Center(
                            child: Icon(
                              Icons.logout,
                              color: AppColors.textOnPrimary,
                            ),
                          )),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _buildProfileImage(parentData),
                      GestureDetector(
                        onTap: () async {
                          showImageSourceBottomSheet(
                            onCameraTap: () async {
                              Get.back();
                              final File? imageFile = await parentController.pickFromCamera();
                              if (imageFile != null) {
                                await uploadImageToFirebase(imageFile, parentData);
                              }
                            },
                            onGalleryTap: () async {
                              Get.back();
                              final File? imageFile = await parentController.pickUpFromGallery();
                              if (imageFile != null) {
                                await uploadImageToFirebase(imageFile, parentData);
                              }
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: const Color(0xFFFEC84B),
                          child: SvgPicture.asset(AppAssets.pencilIconSvg),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    parentData.name,
                    style: AppTextStyle.headingLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        fontSize: 18.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            // My Profile Section
            _buildSectionHeader("My Profile", onEdit: () {
              Get.to(() => UpdateParentProfile(
                    parentData: parentData,
                  ));
            }),
            Container(
              width: 328.w,
              height: 156.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDFAFF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                  borderRadius: BorderRadius.circular(12.r),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileRow("Full name", parentData.name,
                        "assets/drawer_svgs/3p.svg"),
                    SizedBox(height: 26.h),
                    _buildProfileRow("Date of birth", formattedDob,
                        "assets/drawer_svgs/calendar_month.svg"),
                    SizedBox(height: 26.h),
                    _buildProfileRow("Gender", parentData.gender,
                        "assets/drawer_svgs/wc.svg"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 23.h),

            // Personalization Section
            _buildSectionHeader("Personalization"),
            Container(
              width: 328.w,
              height: 125.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDFAFF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileRowWithArrow(
                        "Change Language", "assets/drawer_svgs/language.svg"),
                    SizedBox(
                      height: 31.h,
                    ),
                    _buildProfileRowWithArrow(
                        "Parent Zone Pin", "assets/drawer_svgs/password_2.svg"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 23.h),

            // Notifications Section
            _buildSectionHeader("Notifications"),
            Container(
              width: 328.w,
              height: 120.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFEDFAFF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleRow(
                      "Goal Achievement",
                      "assets/drawer_svgs/flag_check.svg",
                      parentController
                          .toggleValue, // Reactive state
                    ),
                    _buildToggleRow(
                      "Money Request",
                      "assets/drawer_svgs/euro.svg",
                      parentController
                          .toggleValue1, // Reactive state
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 23.h),

            // Others Section
            _buildSectionHeader("Others"),

            Container(
                width: 328.w,
                height: 170.h,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEDFAFF),
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 6,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProfileRowWithArrow(
                            "Share app", "assets/drawer_svgs/share.svg",
                            showArrow: false, iconSize: 24.sp),
                        SizedBox(
                          height: 31.h,
                        ),
                        _buildProfileRowWithArrow(
                            "Feedback", "assets/drawer_svgs/rate_review.svg",
                            showArrow: false, iconSize: 24.sp),
                        SizedBox(
                          height: 31.h,
                        ),
                        _buildProfileRowWithArrow(
                            "Privacy Policy", "assets/drawer_svgs/lock.svg",
                            showArrow: false, iconSize: 24.sp),
                      ]),
                )),

            SizedBox(height: 30.h),

            // Version
            Text(
              "Version 1.0.1",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  // Build section header
  Widget _buildSectionHeader(String title, {VoidCallback? onEdit}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Row(
                children: [
                  SvgPicture.asset(AppAssets.pencilIconSvg),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Build profile row (key-value pair)
  Widget _buildProfileRow(String title, String value, String iconPath) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath, // Path to your SVG asset
                color: Colors.purple,
                height: 20.h, // Adjust the size as needed
                width: 20.w, // Adjust the size as needed
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Build profile row with arrow
  Widget _buildProfileRowWithArrow(
    String title,
    String iconPath, {
    bool showArrow = true,
    double iconSize = 20.0,
    VoidCallback? onTap, // New parameter for onTap callback
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath, // Path to your SVG asset
                  color: Colors.purple,
                  height: iconSize.h, // Use the passed size or default size
                  width: iconSize.w, // Use the passed size or default size
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: iconSize.sp, // Use the passed size or default size
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  // Build toggle row
  Widget _buildToggleRow(String title, String iconPath, RxBool toggleValue) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath, // Path to your SVG asset
                  color: Colors.purple,
                  height: 24.h, // Adjust the size as needed
                  width: 24.w, // Adjust the size as needed
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Obx(() => Switch(
                  value: toggleValue.value, // Use reactive value
                  onChanged: (newValue) {
                    toggleValue.value = newValue; // Update the value reactively
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.purple,
                  inactiveTrackColor: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(ParentModel parentData) {
    return Obx(() {
      // First try to show local image
      if (parentController.customAvatarPath.value.isNotEmpty) {
        return Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: FileImage(File(parentController.customAvatarPath.value)),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
      // Then try to show network image
      else if (parentController.networkImageUrl.value.isNotEmpty) {
        return Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(parentController.networkImageUrl.value),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
      // Finally, show default image
      else {
        return SvgPicture.asset(
          AppAssets.drawerIconSvg,
          height: 100.h,
          width: 100.w,
        );
      }
    });
  }
}

void showImageSourceBottomSheet({
  required VoidCallback onCameraTap,
  required VoidCallback onGalleryTap,
}) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Choose Image Source",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.blue),
            title: Text(
              "Take Photo",
              style: AppTextStyle.bodyLarge,
            ),
            onTap: () {
              Get.back(); // Close the bottom sheet
              onCameraTap(); // Execute the custom camera function
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: Colors.green),
            title: Text(
              "Choose from Gallery",
              style: AppTextStyle.bodyLarge,
            ),
            onTap: () {
              Get.back(); // Close the bottom sheet
              onGalleryTap(); // Execute the custom gallery function
            },
          ),
        ],
      ),
    ),
    isDismissible: true,
  );
}
