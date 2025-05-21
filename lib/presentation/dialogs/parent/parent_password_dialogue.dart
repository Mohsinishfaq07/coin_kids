import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentPasswordDialog extends StatelessWidget {
  final Function(String) onPinSubmit;
  // final bool isFirstTime;

  const ParentPasswordDialog({
    required this.onPinSubmit,
    //  required this.isFirstTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final RxString pin = ''.obs;

    void addDigit(String digit) {
      if (pin.value.length < 4) {
        pin.value += digit;
        pinController.text = pin.value;
        if (pin.value.length == 4) {

          Future.delayed(const Duration(seconds: 1), () {
            final currentPin = pin.value;  // Store current PIN
            onPinSubmit(currentPin);       // Process the PIN
            pin.value = '';                // Clear after processing
            pinController.text = '';
          });     }
      }
    }

    void removeDigit() {
      if (pin.value.isNotEmpty) {
        pin.value = pin.value.substring(0, pin.value.length - 1);
        pinController.text = pin.value;
      }
    }

    Widget buildKeypadButton(String text) {

      // Number buttons
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: KidButton(
          onTap: () => addDigit(text),
          text: text,
          baseColor: Colors.transparent,
          //height: 25.r,
          //width: 15.r,
          showShadowOverlay: false,
          textStyle: AppTextStyle.headingMedium.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Dialog(
      clipBehavior: Clip.none,
      backgroundColor: Colors.red,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            constraints: BoxConstraints(
             // maxWidth: 0.85.sw,
            //  maxHeight: 500.h, // Add max height constraint
            ),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(24.r),
              image: DecorationImage(
                image: AssetImage(Assets.kidDialogBgPng),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView( // Wrap with SingleChildScrollView for smaller screens
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 20.h,),
                  Column(
                    children: [
                      Text(
                        'Add Your Pass ',
                        //isFirstTime ? 'Set Parent PIN' : 'Enter Parent PIN',
                        style: AppTextStyle.headingLarge.copyWith(
                          fontSize: 25.sp,
                          color: Colors.white,
                        ),
                        // textAlign: TextAlign.center,
                      ) ,
                      Text(
                        'Enter year of birth ',
                        //isFirstTime ? 'Set Parent PIN' : 'Enter Parent PIN',
                        style: AppTextStyle.bodyLarge.copyWith(
                          fontSize: 20.sp,
                          color: Colors.white,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                    SizedBox(height: 20.h,),

                    Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isFilled = index < pin.value.length;
                      return Column(
                        //  mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isFilled ? pin.value[index] : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 30.w,
                            height: 2.h,
                            margin: EdgeInsets.symmetric(horizontal: 6.w),
                            decoration: BoxDecoration(
                              color: isFilled ? Colors.white : Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  )),
                    SizedBox(height: 40.h,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10.w),
                        child: GridView(

                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 13.h,
                            childAspectRatio: 1.2,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...List.generate(8, (index) => buildKeypadButton('${index + 1}')),
                            buildKeypadButton('9'),
                            buildKeypadButton('0'),


                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: KidButton(
                                onTap: () {
                                  removeDigit();
                                },
                                iconPath: Assets.icBackSpace,
                                iconColor: pin.value.length == 4 ? AppColors.colorPrimary : Colors.white,
                                baseColor: Colors.transparent,
                                showShadowOverlay: false,
                                textStyle: AppTextStyle.headingMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: 1.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h,),
                      Text(
                        'This information is not stored  ',
                        //isFirstTime ? 'Set Parent PIN' : 'Enter Parent PIN',
                        style: AppTextStyle.bodySmall.copyWith(
                          // fontSize: 20.sp,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  ),
                    SizedBox(height: 20.h,),

                ],
              ),
            ),
          )),
          Positioned(
              right: 12.w,
              top: 10.h,
              child: InkWell(
                onTap: (){
                  Get.back();
                },
                child: SvgPicture.asset(Assets.icRoundClose,
                  height: 50,
                ),
              ))
        ],
      ),
    );
  }

  static Future<void> show({
    // required bool isFirstTime,
    required Function(String) onPinSubmit,
  }) {
    return Get.dialog(

      ParentPasswordDialog(
        //  isFirstTime: isFirstTime,
        onPinSubmit: onPinSubmit,
      ),
      barrierDismissible: false,
      useSafeArea: true
    );
  }
}
