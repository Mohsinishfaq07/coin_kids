import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_text_field.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
 import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:coin_kids/presentation/screens/kid/jars/add_money.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class JarAmountScreen extends StatefulWidget {
  Color jarColor;
  RxBool isSpending;
  JarAmountScreen({required this.isSpending, required this.jarColor, Key? key})
      : super(key: key);

  @override
  State<JarAmountScreen> createState() => _JarAmountScreenState();
}

class _JarAmountScreenState extends State<JarAmountScreen> {
  final parentController = Get.put(ParentController());
  final GlobalKey _amountTextFieldKey = GlobalKey();
   @override
  void initState() {
    super.initState();
    //parentController.fetchParentDetails();
    parentController.fetchKids();
  }
  void _startShowCase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _amountTextFieldKey,

      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    _startShowCase(context);
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
              SizedBox(height: 16.h),
              Text("Enter the amount 💸💰", style: AppTextStyle.headingLarge),
              SizedBox(height: 20.h),
              Showcase(
                key: _amountTextFieldKey,
                description: 'Choose your favorite color for your jar!',
                child: KidCustomTextField(
                    maxlength: 4,
                    keyboardType: TextInputType.number,
                    hintText: "e.g 10.50 €",
                    onChange: (val) {
                      parentController.amount.value = val;
                    }),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.w, top: 16.h),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: GreenNextButton(
                          showSuffix: true,
                          onTap: () async {
                            // Validate and parse the entered amount safely
                            String enteredAmountString =
                                parentController.amount.value;

                            if (enteredAmountString.isEmpty ||
                                double.tryParse(enteredAmountString) == null) {
                              // Show a toast message for invalid input
                              ToastUtil.showToast("Pleae add Valid amount");
                              return; // Stop further execution
                            }

                            double enteredAmount =
                                double.parse(enteredAmountString);

                            if (enteredAmount <= 0) {
                              // Show a toast message for invalid amount
                              ToastUtil.showToast(
                                  "Amount must be greater than 0");

                              return; // Stop further execution
                            }

                            // Perform the desired operation

                            if (widget.isSpending.value) {
                              // await firestoreOperations.parentFirebaseFunctions
                              //     .updateKidSpendingForJar(
                              //   save: true,
                              //   kidId: parentController.kidsList[0]['id'],
                              //   enteredAmount: enteredAmount,
                              //   spendingJarColor: widget.jarColor,
                              // );
                              Get.to(() => AddMoneyScreen(
                                    isSpending: widget.isSpending,
                                    amount: enteredAmount,
                                    jarColor: widget.jarColor,
                                  ));
                            } else {
                              // await firestoreOperations.parentFirebaseFunctions
                              //     .kidSpendingToSavings(
                              //   save: true,
                              //   childId: parentController.kidsList[0]['id'],
                              //   enteredAmount: enteredAmount,
                              //   savingsJarColor: widget.jarColor,
                              // );
                              Get.to(() => AddMoneyScreen(
                                    isSpending: false.obs,
                                    amount: enteredAmount,
                                    jarColor: widget.jarColor,
                                  ));
                            }
                          },
                          buttonText: 'Next'))),
            ],
          ),
        ),
      ),
    );
  }
}
