import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/jar_with_money.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/jar_without_money.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/kid_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/Jar_color_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_transfer.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class KidFinanceWidgets extends StatelessWidget {
  final String spendingJarColor;
  final double spendingAmount;
  final String savingJarColor;
  final double savingAmount;
  final List<dynamic> kidsData;

    KidFinanceWidgets({
    Key? key,
    required this.spendingJarColor,
    required this.spendingAmount,
    required this.savingJarColor,
    required this.savingAmount,
    required this.kidsData,
  }) : super(key: key);
  final KidsOnBoardingController kidOnboardingController = Get.put(KidsOnBoardingController());
  @override
  Widget build(BuildContext context) {
    if (kidsData.isEmpty) return SizedBox.shrink();

    return SizedBox(
      height: 100.h,
      width: 400.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSpendingJar(),
          SizedBox(width: 20.w),
          _buildTransferButton(),
          SizedBox(width: 20.w),
          _buildSavingJar(),
        ],
      ),
    );
  }

  Widget _buildSpendingJar() {
    if (spendingJarColor == "#000000" ||
        (spendingJarColor.isEmpty && spendingAmount == 0.0)) {
      return GestureDetector(
        onTap: () {
          Get.to(AddJarColorScreen(isSpending: true.obs));
        },
        child: Showcase(
            key: kidOnboardingController.spendingJarKey,
            description: 'Create a jar to store money',

            child: Image.asset("assets/jars/jar.png")),
      );
    } else if (spendingAmount != 0.0) {
      return JarWithMoneyTitle(
        JarTitle: 'Spendings',
        amount: spendingAmount,
        color: spendingJarColor,
      );
    } else {
      return JarWithoutMoneyTitle(
        JarTitle: 'Spendings',
        amount: spendingAmount,
      );
    }
  }

  Widget _buildTransferButton() {
    if (spendingJarColor != "#000000" && savingJarColor != "#000000") {
      return GestureDetector(
        onTap: () {
          Get.to(KidTransferScreen());
        },
        child: Container(
          width: 50,
          height: 50,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.buttonPrimary,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(width: 2.22.w, color: Colors.white),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 12.w,
                right: 12.w,
                top: 4.h,
                bottom: 4.h,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(2, 4),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/arrow.svg",
                      height: 14.h,
                      width: 14.w,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.5,
                top: 0.29,
                child: Image.asset(
                  "assets/Button_shadow.png",
                  height: 8.h,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildSavingJar() {
    if (savingJarColor == "#000000" ||
        (savingJarColor.isEmpty && savingAmount == 0.0)) {
      return (spendingJarColor == "#000000" || spendingJarColor.isEmpty)
          ? SizedBox.shrink()
          : GestureDetector(
              onTap: () {
                Get.to(AddJarColorScreen(isSpending: false.obs));
              },
              child: Showcase(

                  key: kidOnboardingController.savingsJarKey,
                  description: 'Create a jar to store money',
                  child: Image.asset("assets/jars/jar.png")),
            );
    } else if (savingAmount != 0.0) {
      return JarWithMoneyTitle(
        JarTitle: 'Savings',
        amount: savingAmount,
        color: savingJarColor,
      );
    } else {
      return GestureDetector(
        onTap: () {
          Get.to(() => AddJarColorScreen(isSpending: false.obs));
        },
        child: JarWithoutMoneyTitle(
          JarTitle: 'Savings',
          amount: savingAmount,
        ),
      );
    }
  }
}
