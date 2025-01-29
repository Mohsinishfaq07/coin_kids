 import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/amount_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class JarColorScreen extends StatefulWidget {
  RxBool isSpending;

  JarColorScreen({
    required this.isSpending,
    Key? key,
  }) : super(key: key);

  @override
  State<JarColorScreen> createState() => _JarColorScreenState();
}

class _JarColorScreenState extends State<JarColorScreen> {
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

  // final colorController = Get.put(JarColorController());
  @override
  void initState() {
    super.initState();
    parentController.fetchParentDetails();
    parentController.fetchKids();
  }

  final parentController = Get.put(ParentController());

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
                        parentController.selectedColorIndex.value = index;
                      },
                      child: Obx(() {
                        bool isSelected =
                            parentController.selectedColorIndex.value == index;
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
                                    ? Border.all(
                                        color: Colors.white, width: 3.w)
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
                    child: GreenNextButton(
                        onTap: () {
                          if (parentController.selectedColorIndex.value == -1) {
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
                            Color selectedColor = colors[
                                parentController.selectedColorIndex.value];
                            Get.to(() => AmountScreen(
                                  isSpending: widget.isSpending,
                                  jarColor: selectedColor,
                                ));
                            // final selectedColor = colors[
                            //     colorController.selectedColorIndex.value];
                            // if (widget.isSpending.value) {
                            //   colorController.updateSpendingJarColor(
                            //     save: true,
                            //     childId: parentController.kidsList[0][
                            //         'id'], // Assuming the first child is selected
                            //     spendingJarColor: selectedColor,
                            //   );
                            // } else {
                            //   colorController.updateSavingJarColor(
                            //     save: true,
                            //     childId: parentController.kidsList[0][
                            //         'id'], // Assuming the first child is selected
                            //     spendingJarColor: selectedColor,
                            //   );
                            // }
                          }
                        },
                        buttonText: "Next")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
