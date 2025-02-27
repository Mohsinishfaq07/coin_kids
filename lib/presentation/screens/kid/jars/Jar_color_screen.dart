import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:coin_kids/presentation/screens/kid/jars/amount_screen.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddJarColorScreen extends StatelessWidget {
  final RxBool isSpending;
  // final GlobalKey colorGridKey = GlobalKey();
  // final GlobalKey nextButtonKey = GlobalKey();

  AddJarColorScreen({
    required this.isSpending,
    Key? key,
  }) : super(key: key);

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

  final parentController = Get.put(ParentBaseController());

  @override
  Widget build(BuildContext context) {
    // Start showcase when screen loads
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (context.mounted) {
    //     ShowCaseWidget.of(context).startShowCase([
    //       colorGridKey,
    //       nextButtonKey,
    //     ]);
    //   }
    // });

    return Scaffold(
      extendBody: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.background,
          image: DecorationImage(
              image: AssetImage(AppAssets.kidSectionBG), fit: BoxFit.cover),
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text("Select Jar Color🎨🖌️",
                    style: AppTextStyle.headingLarge),
              ),
              // AppShowCaseWidget(
              //   showcaseKey: colorGridKey,
              //   description: 'Choose your favorite color for your jar! 🎨',
              //   backgroundImage: "assets/center_spot_light_background.png",
              //   tooltipPosition: TooltipPosition.top,
              //   disposeOnTap: false,
              //   child: SizedBox(
              //     height: 80.h,
              //     width: 399.w,
              //     child: GridView.builder(
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 6, // 6 items per row
              //         crossAxisSpacing: 30.w,
              //         mainAxisSpacing: 10.h,
              //       ),
              //       itemCount: colors.length,
              //       itemBuilder: (context, index) {
              //         return GestureDetector(
              //           onTap: () {
              //             parentController.selectedColorIndex.value = index;
              //           },
              //           child: Obx(() {
              //             bool isSelected =
              //                 parentController.selectedColorIndex.value ==
              //                     index;
              //             return Stack(
              //               alignment: Alignment.center,
              //               children: [
              //                 Container(
              //                   height: 42.h,
              //                   width: 42.w,
              //                   decoration: BoxDecoration(
              //                     color: colors[index],
              //                     shape: BoxShape.circle,
              //                     border: isSelected
              //                         ? Border.all(
              //                             color: Colors.white, width: 3.w)
              //                         : null,
              //                   ),
              //                 ),
              //                 if (isSelected)
              //                   Icon(
              //                     Icons.check,
              //                     color: Colors.white,
              //                     size: 24.sp, // Size of the check icon
              //                   ),
              //               ],
              //             );
              //           }),
              //         );
              //       },
              //     ),
              //   ),
              // ),
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
                    showSuffix: true,
                    onTap: () {
                      if (parentController.selectedColorIndex.value == -1) {
                        ToastUtil.showToast("Please Select Jar Color");
                      } else {
                        Color selectedColor =
                            colors[parentController.selectedColorIndex.value];
                        Get.to(() => JarAmountScreen(
                              isSpending: isSpending,
                              jarColor: selectedColor,
                            ));
                      }
                    },
                    buttonText: "Next",
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
