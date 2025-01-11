import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final double height;
  final Color? textColor;
  final bool isLoading;
  final TextStyle? buttonStyle;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFFA421D9),
// Default color
    this.width = 330,
    this.height = 50,
    this.textColor = Colors.white, // Default text color
    this.isLoading = false,
    super.key,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultButtonStyle = buttonStyle ??
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: CustomThemeData().whiteColorText,
              fontWeight: FontWeight.bold,
            );
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          elevation: 10,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                text,
                style: defaultButtonStyle,
                selectionColor: textColor,
              ),
      ),
    );
  }
}
