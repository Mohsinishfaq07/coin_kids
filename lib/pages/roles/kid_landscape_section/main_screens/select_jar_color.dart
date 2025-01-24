import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/amount_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ColorController extends GetxController {
  var selectedColorIndex = (-1).obs; // Default to no selection

  // Update Spending Jar Color in Firebase
  Future<void> updateSpendingJarColor({
    required bool save,
    required String childId,
    required Color spendingJarColor, // Color passed as parameter
  }) async {
    try {
      // Show loading dialog
      // showDialog(
      //   context: Get.context!,
      //   builder: (context) => LoadingProgressDialogueWidget(
      //     title: "Saving...",
      //   ),
      // );

      // Reference to the kid's document
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(childId);
      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        // Convert color to a string value (Hex or RGBA)
        String colorHex = spendingJarColor.value
            .toRadixString(16)
            .padLeft(8, '0'); // Converts to hex format

        if (save) {
          // Save the updated spending jar color as a hex string
          await kidDocRef.update({
            'spendings.color': colorHex, // Use dot notation for nested fields
          });
          // Close loading dialog
          // Get.back();
          print("Spending Jar Color updated successfully to: $colorHex");
          Get.log("Spending Jar Color updated successfully to: $colorHex");
          Get.to(() => AmountScreen());
        } else {
          Get.back();
          Get.log("Save flag is false. No changes made.");
        }
      } else {
        Get.back();
        Get.log("Kid document does not exist.");
      }
    } catch (e) {
      // Handle errors
      Get.back();
      Get.log("Error updating spending jar color: $e");
    }
  }
}

class SelectJarColorScreen extends StatefulWidget {
  // final String childId;

  SelectJarColorScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectJarColorScreen> createState() => _SelectJarColorScreenState();
}

class _SelectJarColorScreenState extends State<SelectJarColorScreen> {
  final List<Color> colors = [
    const Color(0xFFFF6060),
    const Color(0xFF8F60FF),
    const Color(0xFFE360FF),
    const Color(0xFFFEC61C),
    const Color(0xFF434343),
    const Color(0xFFFF9500),
    const Color(0xFF4CAF50),
    const Color(0xFF3F89FC),
    const Color(0xFF3FD9FC),
    const Color(0xFF4BD1C5),
    const Color(0xFFFF60C4),
    const Color(0xFF3F51FC),
  ];

  final ColorController colorController = Get.put(ColorController());
  @override
  void initState() {
    super.initState();
    homeController.fetchParentDetails();
    homeController.fetchKids();
  }

  final ParentHomeController homeController = Get.put(ParentHomeController());

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
            children: [
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: kidBackButton(
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01.h),
              Text("Select Jar Color🎨🖌️", style: AppTextStyle.headingLarge),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01.h),
              SizedBox(
                height: 80.h,
                width: 399.w,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // 6 items per row
                    crossAxisSpacing: 30.w,
                    mainAxisSpacing: 10.h,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        colorController.selectedColorIndex.value = index;
                      },
                      child: Obx(() {
                        bool isSelected =
                            colorController.selectedColorIndex.value == index;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 42.h,
                              width: 42.w,
                              decoration: BoxDecoration(
                                color: colors[index],
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 3.w)
                                    : null,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24.sp, // Size of the check icon
                              ),
                          ],
                        );
                      }),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      if (colorController.selectedColorIndex.value == -1) {
                        // Show a toast message
                        Fluttertoast.showToast(
                          msg: "Please select a jar color.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: AppColors.textHighlighted,
                          textColor: AppColors.textOnPrimary,
                          fontSize: 16.0.sp,
                        );
                      } else {
                        // Get the selected color and update it in Firebase
                        final selectedColor =
                            colors[colorController.selectedColorIndex.value];
                        colorController.updateSpendingJarColor(
                          save: true,
                          childId: homeController.kidsList[0]['id'],
                          spendingJarColor: selectedColor,
                        );
                      }
          
                      
                    },
                    child: Container(
                      width: 120.w,
                      height: 32.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF19B859),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2.22.w, color: const Color(0xFF0E9454)),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20.w,
                            right: 12.w,
                            top: 4.h,
                            bottom: 4.h,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    "Next",
                                    style: AppTextStyle.headingMedium.copyWith(
                                      color: AppColors.textOnPrimary,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Center(
                                    child: SvgPicture.asset(
                                      "assets/arrorDirectionNoShadow.svg",
                                      height: 12.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 1,
                            top: 1.29,
                            child: Image.asset(
                              "assets/Button_shadow.png",
                              height: 10.h,
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
      ),
    );
  }
}
