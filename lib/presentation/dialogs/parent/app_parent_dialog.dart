import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DialogButton {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  DialogButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });
}

class AppParentDialog extends StatelessWidget {
  final String? iconPath;
  final String title;
  final String? subtitle;
  final String? message;
  final List<DialogButton> buttons;
  final CrossAxisAlignment? alignment;
  final TextAlign? textAlign;

  const AppParentDialog({
    super.key,
    this.iconPath,
    required this.title,
    this.subtitle,
    this.message,
    required this.buttons,
    this.alignment = CrossAxisAlignment.center,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 10,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.7, // Limit height to 70% of screen
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: alignment!,
              children: [
                if (iconPath != null) ...[
                  SizedBox(height: 10.h),
                  SvgPicture.asset(
                    iconPath!,
                    height: 152.h,
                    width: 152.h,
                  ),
                  SizedBox(height: 10.h),
                ],

                Text(
                  title,
                  textAlign: textAlign,
                  style: AppTextStyle.headingMedium.copyWith(
                    color: AppColors.textHighlighted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),

                if (subtitle != null) ...[
                  SizedBox(height: 24.h),
                  Text(subtitle!, textAlign: textAlign, style: AppTextStyle.bodyMedium),
                ],

                if (message != null) ...[
                  SizedBox(height: 14.h),
                  Text(
                    message!,
                    textAlign: textAlign,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],

                SizedBox(height: 32.h),

                // Buttons
                buttons.length == 1 ? _buildSingleButton(buttons.first) : _buildButtonRow(buttons),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleButton(DialogButton button) {
    return SizedBox(
      width: double.infinity,
      child: _buildButton(button),
    );
  }

  Widget _buildButtonRow(List<DialogButton> buttons) {
    return Row(
      children: buttons.map((button) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _buildButton(button),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButton(DialogButton button) {
    return ElevatedButton(
      onPressed: button.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: button.backgroundColor ?? AppColors.buttonPrimary,
        foregroundColor: button.textColor ?? Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
      child: Text(
        button.text,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }
}

// // Success dialog with one button
// showDialog(
//   context: context,
//   builder: (context) => CustomDialog(
//     iconPath: "assets/Vector2.svg",
//     title: "Transfer Successful",
//     subtitle: "€100 transferred to John",
//     message: "The money has been successfully transferred to the savings jar",
//     buttons: [
//       DialogButton(
//         text: "Close",
//         onPressed: () => Get.back(),
//       ),
//     ],
//   ),
// );

// // Confirmation dialog with two buttons
// showDialog(
//   context: context,
//   builder: (context) => CustomDialog(
//     iconPath: "assets/warning.svg",
//     iconBackgroundColor: Colors.orange,
//     title: "Confirm Delete",
//     message: "Are you sure you want to delete this item?",
//     buttons: [
//       DialogButton(
//         text: "Cancel",
//         backgroundColor: Colors.grey,
//         onPressed: () => Get.back(),
//       ),
//       DialogButton(
//         text: "Delete",
//         backgroundColor: Colors.red,
//         onPressed: () {
//           // Handle delete
//           Get.back();
//         },
//       ),
//     ],
//   ),
// );

// // Simple info dialog
// showDialog(
//   context: context,
//   builder: (context) => CustomDialog(
//     title: "Information",
//     message: "Your account has been updated successfully.",
//     buttons: [
//       DialogButton(
//         text: "OK",
//         onPressed: () => Get.back(),
//       ),
//     ],
//   ),
// );
