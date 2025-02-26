import 'package:coin_kids/core/theme/color_theme.dart';
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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Container(
            height: 160.w, // Square height
            width: 160.w, // Square width
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
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black, // Ensure correct text color
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp, // Adjust the font size as needed
                            ) ??
                        const TextStyle(color: Colors.black), // Fallback if no bodyText2 is defined
                    textAlign: TextAlign.center,
                  ),

                  // Close Button
                ],
              ),
            ),
          ),
        ));
  }
}
