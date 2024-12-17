import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final double height;
  final Color? textColor;
  final bool isLoading;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color = Colors.purple, // Default color
    this.width = 320,
    this.height = 50,
    this.textColor = Colors.white, // Default text color
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 5,
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
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomThemeData().whiteColorText), 
                ),
        ),
      ),
    );
  }
}
