import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentPinDialog extends StatelessWidget {
  final Function(String) onPinSubmit;
  // final bool isFirstTime;

  const ParentPinDialog({
    required this.onPinSubmit,
  //  required this.isFirstTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final pinController = TextEditingController();
    final RxString pin = ''.obs;

    void addDigit(String digit) {
      if (pin.value.length < 4) {
        pin.value += digit;
        pinController.text = pin.value;
        if (pin.value.length == 4) {
          onPinSubmit(pin.value);
          pin.value = '';
          pinController.text = '';        }
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

      backgroundColor: Colors.transparent,

      // insetPadding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 0.85.sw),
            // padding: REdgeInsets.all(2),
            decoration: BoxDecoration(
               color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(24.r),
              image: DecorationImage(
                image: AssetImage(Assets.kidDialogBgPng),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 20.w),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        Assets.icParentZoneImage,
                        width: screenWidth * 0.28, // 10% of screen width
                        height: screenHeight * 0.28, // 10% of screen height
                        fit: BoxFit.contain,

                      ),

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
                  // SizedBox(width: 24.w),
                  // Right side - Keypad
                  Expanded(

                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(right: 12.w),
                                  child: Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                    size: 30.sp,
                                  ),
                                ),
                                Text(
                                  'Ask Your Parent ',
                                  //isFirstTime ? 'Set Parent PIN' : 'Enter Parent PIN',
                                  style: AppTextStyle.headingLarge.copyWith(
                                    fontSize: 25.sp,
                                    color: Colors.white,
                                  ),
                                  // textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Text(
                              'Enter parent year of birth ',
                              //isFirstTime ? 'Set Parent PIN' : 'Enter Parent PIN',
                              style: AppTextStyle.bodyLarge.copyWith(
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 20.w),
                          child: GridView(

                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 13.h,
                              childAspectRatio: 2.0,
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              ...List.generate(9, (index) => buildKeypadButton('${index + 1}')),

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
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox.shrink()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      ParentPinDialog(
      //  isFirstTime: isFirstTime,
        onPinSubmit: onPinSubmit,
      ),
      barrierDismissible: true,
    );
  }
}
