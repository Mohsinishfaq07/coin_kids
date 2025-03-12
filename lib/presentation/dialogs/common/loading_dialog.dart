import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showLoadingDialog(String title) {
  Get.dialog(LoadingProgressDialogueWidget(title: title), barrierDismissible: false);
}

class LoadingProgressDialogueWidget extends StatelessWidget {
  final String title;

  LoadingProgressDialogueWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          height: 160.w,
          width: 160.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppColors.textHighlighted,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(title, style: AppTextStyle.bodyMedium),
              ],
            ),
          ),
        ),
    );
  }
}
