import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/presentation/components/common/AppButton.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/custom_text_field.dart';
import 'package:coin_kids/presentation/components/parent/quick_transfer_text_field.dart';
import 'package:coin_kids/presentation/controllers/parent/quick_transfer_controller.dart';
import 'package:coin_kids/presentation/dialogs/parent/app_parent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/color_theme.dart';

class QuickTransferPage extends GetView<QuickTransferController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Quick Transfer",
        showBackButton: true,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.background,
            ),
            child: Stack(children: [
              SvgPicture.asset(
                AppAssets.cloudImageSvg,
                width: 400.w,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              TextSpan(
                                // text: 'money\nfrom your ${docData['name']}\'s account',
                                style: const TextStyle(
                                  color: Colors.black, // Default color for the remaining text
                                ),
                              ),
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
                        hintText: "0,00",
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          controller.amount.value = val;
                        },
                        prefix: SvgPicture.asset("assets/currency_euro.svg")),
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
                    CustomTextField(
                      titleText: "Leave a Message",
                      hintText: "e.g Remember to save some money",
                      keyboardType: TextInputType.name,
                      isOptional: true,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 27.h),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() {
                          return AppButton(
                            size: Size(125.w, 50.h),
                            text: '- Remove',
                            backgroundColor: controller.amount.value.isNotEmpty ? AppColors.buttonPrimary : AppColors.buttonDisabled,
                            onPressed: () async {
                              if (controller.amount.value.isEmpty) {
                                controller.amountValidation.value = 'Enter valid amount';
                              } else {
                                try {
                                  double enteredAmount = double.parse(controller.amount.value);
                                  final kid = controller.appState.currentKid.value!;
                                  var newBalance = kid.wallet.spendingJar.balance - enteredAmount;

                                  if (newBalance < 0) {
                                    ToastUtil.showToast("Kid doesn't have enough money");
                                    return;
                                  }

                                  await controller.kidService.updateSpendingJarBalance(kid.kidId, newBalance);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AppParentDialog(
                                      iconPath: "assets/succesful_dialog_icon.svg",
                                      title: "Transfer Successful",
                                      subtitle: "€${enteredAmount} transferred to ${kid.name}",
                                      buttons: [
                                        DialogButton(
                                          text: "Close",
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          );
                        }),
                        Obx(() {
                          return AppButton(
                            size: Size(125.w, 50.h),
                            text: '+ Send',
                            backgroundColor: controller.amount.value.isNotEmpty ? AppColors.buttonPrimary : AppColors.buttonDisabled,
                            onPressed: () async {
                              if (controller.amount.value.isEmpty) {
                                controller.amountValidation.value = 'Enter valid amount';
                              } else {
                                try {
                                  double enteredAmount = double.parse(controller.amount.value);
                                  final kid = controller.appState.currentKid.value!;
                                  var newBalance = kid.wallet.spendingJar.balance + enteredAmount;

                                  await controller.kidService.updateSpendingJarBalance(kid.kidId, newBalance);

                                  showDialog(
                                    context: context,
                                    builder: (context) => AppParentDialog(
                                      iconPath: "assets/succesful_dialog_icon.svg",
                                      title: "Transfer Successful",
                                      subtitle: "€${enteredAmount} deducted from ${kid.name}",
                                      buttons: [
                                        DialogButton(
                                          text: "Close",
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                                } on Exception catch (e) {
                                  print("Exception $e");
                                }
                              }
                            },
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

quickTransferFields({
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
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(kid.avatar)),
              SizedBox(height: 8.h),

              // Available Money
              Text(
                'Available Money',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(height: 6.h),
              Text(
                '\$ ${kid.wallet.spendingJar.balance}',
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
