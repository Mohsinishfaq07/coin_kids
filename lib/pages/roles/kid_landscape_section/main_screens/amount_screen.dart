import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AmountScreen extends StatefulWidget {
  Color jarColor;
  RxBool isSpending;
  AmountScreen({required this.isSpending, required this.jarColor, Key? key})
      : super(key: key);

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  final parentController = Get.put(ParentController());
  @override
  void initState() {
    super.initState();
    parentController.fetchParentDetails();
    parentController.fetchKids();
  }

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
              SizedBox(height: 16.h),
              Text("Enter the amount 💸💰", style: AppTextStyle.headingLarge),
              SizedBox(height: 20.h),
              KidCustomTextField(
                  keyboardType: TextInputType.number,
                  hintText: "e.g 10.50 €",
                  onChange: (val) {
                    parentController.amount.value = val;
                  }),
              Padding(
                  padding: EdgeInsets.only(right: 20.w, top: 16.h),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: GreenNextButton(
                          onTap: () async {
                            // Validate and parse the entered amount safely
                            String enteredAmountString =
                                parentController.amount.value;

                            if (enteredAmountString.isEmpty ||
                                double.tryParse(enteredAmountString) == null) {
                              // Show a toast message for invalid input
                              Fluttertoast.showToast(
                                msg: "Please enter a valid amount",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: AppColors.textHighlighted,
                                textColor: AppColors.textOnPrimary,
                                fontSize: 16.0.sp,
                              );
                              return; // Stop further execution
                            }

                            double enteredAmount =
                                double.parse(enteredAmountString);

                            if (enteredAmount <= 0) {
                              // Show a toast message for invalid amount
                              Fluttertoast.showToast(
                                msg: "Amount must be greater than 0",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: AppColors.textHighlighted,
                                textColor: AppColors.textOnPrimary,
                                fontSize: 16.0.sp,
                              );
                              return; // Stop further execution
                            }

                            // Perform the desired operation

                            if (widget.isSpending.value) {
                              await firestoreOperations.parentFirebaseFunctions
                                  .updateKidSpending(
                                save: true,
                                childId: parentController.kidsList[0]['id'],
                                enteredAmount: enteredAmount,
                                spendingJarColor: widget.jarColor,
                              );
                              Get.to(() => AddMoneyScreen(
                                    isSpending: widget.isSpending,
                                  ));
                            } else {
                              await firestoreOperations.parentFirebaseFunctions
                                  .kidSpendingToSavings(
                                save: true,
                                childId: parentController.kidsList[0]['id'],
                                enteredAmount: enteredAmount,
                                savingsJarColor: widget.jarColor,
                              );
                              Get.to(() => AddMoneyScreen(
                                    isSpending: false.obs,
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
