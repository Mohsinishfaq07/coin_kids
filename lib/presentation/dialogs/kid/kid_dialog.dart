import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class KidDialog extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget? extraContent;
  final List<Widget> buttons;
  final Color? backgroundColor;
  final double width;
  final double emojiSize;
  final EdgeInsets contentPadding;

  const KidDialog({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.extraContent,
    required this.buttons,
    this.backgroundColor,
    this.width = 0.8,
    this.emojiSize = 60,
    this.contentPadding = const EdgeInsets.all(24),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Dialog content container
          Container(
            constraints: BoxConstraints(
              minWidth: 350.w,
            ),
            margin: EdgeInsets.only(top: emojiSize.r / 2),
            padding: EdgeInsets.only(
              left: contentPadding.left,
              right: contentPadding.right,
              top: contentPadding.top + (emojiSize.r / 2),
              bottom: contentPadding.bottom / 1.5,
            ),
            decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.colorPrimary, borderRadius: BorderRadius.circular(24.r), image: DecorationImage(image: AssetImage(Assets.kidDialogBgPng), fit: BoxFit.fill)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyle.headingLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTextStyle.headingSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (extraContent != null) ...[
                  SizedBox(height: 8.h),
                  extraContent!,
                ],
                SizedBox(height: 8.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buttons,
                ),
              ],
            ),
          ),

          // Emoji at the top
          Positioned(
            top: 0,
            child: emoji.endsWith("svg")
                ? SvgPicture.asset(
                    emoji,
                    height: emojiSize,
                    width: emojiSize,
                  )
                : Image.asset(
                    emoji,
                    height: emojiSize,
                    width: emojiSize,
                  ),
          ),

          // Buttons at the bottom
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Row(mainAxisAlignment: MainAxisAlignment.center, children: buttons),
          // ),
        ],
      ),
    );
  }

/*
  MainAxisAlignment _getButtonAlignment() {
    if (buttons.length == 1) {
      return MainAxisAlignment.center;
    } else if (buttons.length == 2) {
      return MainAxisAlignment.spaceEvenly;
    } else {
      return MainAxisAlignment.spaceAround;
    }
  }
*/

  // Static method to show the dialog
  static Future<T?> show<T>(
      {required String emoji,
      required String title,
      required String subtitle,
      Widget? extraContent,
      required List<Widget> buttons,
      Color? backgroundColor,
      double width = 0.8,
      double emojiSize = 60,
      EdgeInsets contentPadding = const EdgeInsets.all(24),
      dismissible = false}) {
    return Get.dialog<T>(
      KidDialog(
        emoji: emoji,
        title: title,
        subtitle: subtitle,
        extraContent: extraContent,
        buttons: buttons,
        backgroundColor: backgroundColor ?? AppColors.colorPrimary,
        width: width,
        emojiSize: emojiSize,
        contentPadding: contentPadding,
      ),
      barrierDismissible: dismissible,
    );
  }
}

void showExampleDialog() {
  KidDialog.show(
    emoji: Assets.icClap,
    title: 'Goal Achieved!',
    subtitle: 'You saved enough for your goal',
    buttons: [
      KidButton(
        text: 'Cancel',
        onTap: () => Get.back(),
        baseColor: AppColors.btnColorRed,
      ),
      SizedBox(width: 16.w),
      KidButton(
        text: 'Continue',
        onTap: () {
          // Handle continue action
          Get.back();
        },
        baseColor: AppColors.btnColorGreen,
        iconPath: Assets.icNext,
        iconPosition: IconPosition.right,
      ),
    ],
  );
}

//Usage
void exampleDialog() {
  KidDialog.show(
    emoji: Assets.icTrophy,
    title: 'Goal Achieved!',
    subtitle: 'You saved enough for your goal',
    buttons: [
      KidButton(
        text: 'Cancel',
        onTap: () => Get.back(),
        baseColor: AppColors.btnColorRed,
      ),
      SizedBox(width: 16.w),
      KidButton(
        text: 'Continue',
        onTap: () {
          // Handle continue action
          Get.back();
        },
        baseColor: AppColors.btnColorGreen,
        iconPath: Assets.icNext,
        iconPosition: IconPosition.right,
      ),
    ],
  );
}
