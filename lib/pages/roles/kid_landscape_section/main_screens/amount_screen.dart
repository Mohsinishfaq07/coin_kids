import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_text_field.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AmountScreen extends StatefulWidget {
  RxBool isSpending;
  AmountScreen({required this.isSpending, Key? key}) : super(key: key);

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
                    child: GestureDetector(
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
                          );
                        } else {
                          await firestoreOperations.parentFirebaseFunctions
                              .kidSpendingToSavings(
                            save: true,
                            childId: parentController.kidsList[0]['id'],
                            enteredAmount: enteredAmount,
                          );
                        }

                        // Navigate to the next screen
                        Get.to(() => AddMoneyScreen(
                              isSpending: widget.isSpending,
                            ));
                      },
                      child: Container(
                        width: 120.w,
                        height: 32.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF19B859),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2.22.w, color: const Color(0xFF0E9454)),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20.w,
                              right: 12.w,
                              top: 4.h,
                              bottom: 4.h,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      "Next",
                                      style: AppTextStyle.headingMedium
                                          .copyWith(
                                              color: AppColors.textOnPrimary,
                                              fontSize: 22.sp),
                                    ),
                                    SizedBox(width: 10.w),
                                    Center(
                                      child: SvgPicture.asset(
                                        "assets/arrorDirectionNoShadow.svg",
                                        height: 12.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 1,
                              top: 1.29,
                              child: Image.asset(
                                "assets/Button_shadow.png",
                                height: 10.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
