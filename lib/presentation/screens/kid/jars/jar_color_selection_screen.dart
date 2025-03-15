import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JarColorSelectionScreen extends GetView<JarCreationController> {
  const JarColorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(image: AssetImage(Assets.kidBg), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            // Top Section
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: KidButton.iconOnly(
                  onTap: () {
                    Get.back();
                  },
                  baseColor: AppColors.btnColorOrange,
                  iconPath: Assets.icBack,
                  iconSize: 20,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text("Select Jar Color🎨🖌️", style: AppTextStyle.headingLarge),
            SizedBox(height: 10.h),

            // Main Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Left Spacer
                  SizedBox(width: 178.w),

                  // Grid Section
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 30.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 1, // Makes cells square
                      ),
                      itemCount: controller.colors.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.selectedColorIndex.value = index;
                          },
                          child: Obx(() {
                            bool isSelected = controller.selectedColorIndex.value == index;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 42.h,
                                  width: 42.w,
                                  decoration: BoxDecoration(
                                    color: controller.colors[index],
                                    shape: BoxShape.circle,
                                    border: isSelected ? Border.all(color: Colors.white, width: 3.w) : null,
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                              ],
                            );
                          }),
                        );
                      },
                    ),
                  ),

                  // Right Button
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: KidButton(
                      onTap: () {
                        if (controller.jarType == Jars.spendingJar) {
                          Get.toNamed(Routes.kidMoneyAddOrRequest, arguments: AmountAdditionMode.jarCreation);
                        } else {
                          controller.amount.value = controller.appState.currentKid.value!.wallet.spendingJar.balance;

                          Get.toNamed(
                            Routes.kidDragAndDrop,
                            arguments: {
                              'mode': DragAndDropMode.jarCreation,
                            },
                          );
                        }
                      },
                      baseColor: AppColors.btnColorGreen,
                      text: "Next",
                      iconPath: Assets.icTick,
                      iconPosition: IconPosition.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
