import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/app_button.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/components/parent/quick_transfer_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/quick_transfer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../core/theme/color_theme.dart';

class QuickTransferPage extends GetView<QuickTransferController> {
  final _amountNode = FocusNode();

  QuickTransferPage({super.key});

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _amountNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: AppColors.colorPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParentAppBar(
        title: "Quick Transfer",
        showBackButton: true,
        centerTitle: false,
        onBackPressed: () async {
          Get.back();
          await controller.analytics.backPressClicked(AnalyticsScreenNames.parentQuickTransferScreen);
        },
      ),
      body: KeyboardActions(
        config: _buildConfig(context),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.background,
            ),
            child: Stack(children: [
              SvgPicture.asset(
                Assets.parentBgCloud,
                width: 400.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Obx(() {
                      return quickTransferChildGeneralDetailWidget(kid: controller.appState.currentKid.value);
                    }),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Send ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,

                              color: AppColors.textHighlighted, // Default color for non-bold text
                            ),
                            children: [
                              const TextSpan(
                                text: 'or ',
                                style: TextStyle(
                                  color: Colors.black, // Default color for "or"
                                ),
                              ),
                              TextSpan(
                                text: 'remove ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,

                                  color: AppColors.textHighlighted, // Purple color for "remove"
                                ),
                              ),
                              // TextSpan(
                              //    text: 'money\nfrom your ${controller.appState.currentKid.value}\'s account',
                              //   style:  TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 12.sp,
                              //       fontWeight:FontWeight.normal
                              //
                              //
                              //
                              //     // Default color for the remaining text
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Enter amount',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    QuickTransferTextField(
                      maxLength: 8,
                      hintText: 0.toMoneyFormat(),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                      onChanged: (val) {
                        controller.amount.value = val;
                      },
                      initialValue: controller.amount.value,
                      focusNode: _amountNode,
                      prefix: SvgPicture.asset(
                        Assets.icCurrencyRound,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          text: 'Leave a Message ', // Default text
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: 14.h,
                                fontWeight: FontWeight.bold,
                              ),
                          children: [
                            TextSpan(
                              text: '(Optional)', // Optional in gray color
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 14.h,
                                    fontFamily: 'Open Sans',
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w100,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ParentTextField(
                      titleText: "Leave a Message",
                      hintText: "e.g Remember to save some money",
                      keyboardType: TextInputType.name,
                      isOptional: true,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() {
                          bool hasEnoughBalance = controller.amount.value.isNotEmpty &&
                              double.tryParse(controller.amount.value) != null &&
                              double.parse(controller.amount.value) <= controller.appState.currentKid.value!.wallet.spendingJar.balance;

                          return AppButton(
                            // size: Size(120, 43),

                            // size: Size(123.w, 45.h),
                            backgroundColor: hasEnoughBalance ? AppColors.buttonPrimary : AppColors.buttonDisabled,
                            onPressed: () async {
                              await controller.analytics.buttonClicked(AnalyticsEventNames.removeMoneyButtonClicked, AnalyticsScreenNames.parentQuickTransferScreen);

                              if (!hasEnoughBalance) {
                                controller.amountValidation.value = 'Insufficient balance';
                              } else {
                                controller.removeMoney();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Remove  ",
                                  style: AppTextStyle.appButton,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.remove,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          );
                        }),
                        Obx(() {
                          return AppButton(
                            // size: Size(123.w, 45.h),
                            //  size: Size(80, 43.h),
                            backgroundColor: controller.amount.value.isNotEmpty ? AppColors.buttonPrimary : AppColors.buttonDisabled,
                            onPressed: ()async {
                              await controller.analytics.buttonClicked(AnalyticsEventNames.sendMoneyButtonClicked, AnalyticsScreenNames.parentQuickTransferScreen);

                            controller.sendMoney();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Icon(
                                    Icons.add,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  "Send   ",
                                  style: AppTextStyle.appButton,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

Widget quickTransferFields({
  required Function()? onTap,
  required Function(String)? onChanged,
  required TextInputType? keyboardType,
  required String hintText,
  required bool showPrefix,
}) {
  return TextField(
    onTap: onTap,
    onChanged: onChanged,

    keyboardType: keyboardType,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white38,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when unfocused
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when enabled
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue, // Border color when focused
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        prefixIcon: showPrefix
            ? const Icon(
                Icons.money,
                color: Colors.blue,
              )
            : const SizedBox.shrink()),
    style: const TextStyle(color: Colors.black), // Input text color
  );
}

Widget quickTransferChildGeneralDetailWidget({required KidModel? kid}) {
  if (kid == null) return SizedBox();
  return Center(
    child: Container(
      width: 126.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Child Name
              Text(
                kid.name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),

              // Child Avatar
              CircleAvatarWidget(size: 48.h, imagePath: kid.avatar, imageType: ImageType.network),
              SizedBox(height: 8.h),

              // Available Money
              Text(
                'Available Money',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(height: 6.h),
              Text(
                kid.wallet.spendingJar.balance.toMoneyFormat(),
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
