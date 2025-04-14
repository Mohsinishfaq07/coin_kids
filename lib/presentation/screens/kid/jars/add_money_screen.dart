import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/add_money_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddMoneyScreen extends GetView<AddMoneyController> {
  final AmountAdditionMode mode;
  final _addAmount = FocusNode();


  AddMoneyScreen({
    super.key,
  }) : mode = Get.arguments as AmountAdditionMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: 24.w,
          bottom: 24.w,
          left: 24.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KidButton(
              onTap: () => controller.handleNextButton(mode),
              baseColor: AppColors.btnColorGreen,
              text: "Next",
              iconPath: Assets.icTick,
              iconPosition: IconPosition.left,
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(
            image: AssetImage(Assets.kidBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: KidButton.iconOnly(
                  onTap: () => Get.back(),
                  baseColor: AppColors.btnColorOrange,
                  iconPath: Assets.icBack,
                  size: 40.r,
                  iconSize: 20.r,
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  _getScreenTitle(),
                  style: AppTextStyle.headingLarge,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 40.h,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 0.5.sw,
                        child: KidTextField(
                          focusNode: _addAmount,
                          textInputAction: TextInputAction.done,
                          maxlength: 7,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          hintText: "e.g 10.50",
                          onChange: (val) {
                            controller.amount.value = double.tryParse(val.trim()) ?? 0.0;
                          },
                        ),
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

  String _getScreenTitle() {
    switch (mode) {
      case AmountAdditionMode.jarCreation:
        return "Enter the amount 💸💰";
      case AmountAdditionMode.requestMoney:
        return "Request Money from Parent 🙏";
      default:
        return "Add Money to Spending 💰";
    }
  }
}
