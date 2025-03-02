import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:coin_kids/presentation/screens/kid/jars/add_money.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class JarAmountScreen extends GetView<JarCreationController> {
  JarAmountScreen({required this.isSpending, required this.jarColor, Key? key})
      : super(key: key);

  final GlobalKey amountTextFieldKey = GlobalKey();
  final GlobalKey nextButtonKey = GlobalKey();

  final RxBool isSpending;
  final Color jarColor;

  @override
  Widget build(BuildContext context) {
    final wallet = controller.appState.currentKid.value!.wallet;

    // Start showcase when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ShowCaseWidget.of(context).startShowCase([
          amountTextFieldKey,
          nextButtonKey,
        ]);
      }
    });

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
              SizedBox(height: 16.h),
              Text("Enter the amount 💸💰", style: AppTextStyle.headingLarge),
              SizedBox(height: 20.h),
              KidCustomTextField(

                  keyboardType: TextInputType.number,
                  hintText: "e.g 10.50",
                  onChange: (val) {
                    controller.amount.value = val.trim();
                  }),
              // AppShowCaseWidget(
              //   showcaseKey: amountTextFieldKey,
              //   description: 'How much money do you want to add to your jar 💵',
              //   backgroundImage: "assets/center_spot_light_background.png",
              //   tooltipPosition: TooltipPosition.top,
              //   disposeOnTap: false,
              //   child: KidCustomTextField(
              //       maxlength: 4,
              //       keyboardType: TextInputType.number,
              //       hintText: "e.g 10.50 €",
              //       onChange: (val) {
              //         controller.amount.value = val.trim();
              //       }),
              // ),
              // wallet.spendingJar.balance > 0 ?
              // KidCustomTextField(
              //     enabled: false,
              //     maxlength: 4,
              //     keyboardType: TextInputType.number,
              //     hintText: "${wallet.spendingJar.balance.toMoneyFormat()}",
              //     onChange: (val) {
              //       wallet.spendingJar.balance.toMoneyFormat();
              //     })
              // //     ? Text(
              // //   'Spending: ${wallet.spendingJar.balance.toMoneyFormat()}',
              // //   style: TextStyle(fontSize: 12.sp),
              // // )
              //     :
              // KidCustomTextField(
              //     maxlength: 4,
              //     keyboardType: TextInputType.number,
              //     hintText: "e.g 10.50 €",
              //     onChange: (val) {
              //       controller.amount.value = val.trim();
              //     }),
              Padding(
                padding: EdgeInsets.only(right: 20.w, top: 16.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GreenNextButton(
                      showSuffix: true,
                      onTap: () async {
                        // Validate and parse the entered amount safely
                        //todo: change to original value
                        String enteredAmountString = controller.amount.value;

                        if (enteredAmountString.isEmpty ||
                            double.tryParse(enteredAmountString) == null) {
                          // Show a toast message for invalid input
                          ToastUtil.showToast("Please add Valid amount");
                          return; // Stop further execution
                        }

                        double enteredAmount =
                            double.parse(enteredAmountString);

                        if (enteredAmount <= 0) {
                          // Show a toast message for invalid amount
                          ToastUtil.showToast("Amount must be greater than 0");

                          return; // Stop further execution
                        }

                        // Perform the desired operation

                        if (isSpending.value) {
                          double enteredAmount =
                              double.parse(controller.amount.value);
                          final kid = controller.appState.currentKid.value!;
                          kid.wallet.spendingJar.balance + enteredAmount;

                          // await controller.kidService.updateSpendingJarBalance(kid.kidId, newBalance, color: jarColor.value);

                          Get.to(() => AddMoneyScreen(
                                isSpending: isSpending,
                                amount: enteredAmount,
                                jarColor: jarColor,
                              ));
                        } else {
                          double enteredAmount =
                              double.parse(controller.amount.value);
                          final kid = controller.appState.currentKid.value!;
                          kid.wallet.savingJar.balance + enteredAmount;

                          Get.to(() => AddMoneyScreen(
                                isSpending: false.obs,
                                amount: enteredAmount,
                                jarColor: jarColor,
                              ));
                        }
                      },
                      buttonText: 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
