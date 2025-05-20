import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ParentTextField extends StatelessWidget {
  final String titleText; // Required title for the field
  final String hintText; // Placeholder for the text field
  final TextEditingController? controller;
  final String? initialValue;
  final Function(String)? onChanged;
  final IconData? prefixIcon; // Optional prefix icon
  final VoidCallback? onPrefixTap; // Optional callback for prefix icon tap
  final IconData? suffixIcon; // Optional suffix icon
  final VoidCallback? onSuffixTap; // Optional callback for suffix icon tap
  final bool
      obscureText; // Whether the text should be obscured (e.g., password)
  final TextInputType keyboardType; // Input type for the keyboard
  final String? Function(String?)? validator;
  final Color? suffixIconColor; // Custom color for suffix icon
  final String? suffixSvgPath;
  final bool isOptional; // Flag for optional label
  final FocusNode? nextFocusNode;
  final int? maxLength;
  final bool enabled;
  final TextInputFormatter? inputFormatter;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const ParentTextField({
    this.isOptional = false,
    this.maxLength,
    this.titleText = "",
    required this.hintText,
    this.initialValue,
    this.prefixIcon,
    this.onPrefixTap,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIconColor,
    this.suffixSvgPath,
    this.nextFocusNode,
    this.enabled = true,
    this.inputFormatter,
    this.textInputAction,
    this.focusNode,
    super.key,
  }) : assert(controller == null || initialValue == null,
            'Cannot provide both a controller and an initialValue');

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate adaptive sizes
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate adaptive values
    final double borderRadius = screenWidth < 600 ? 15.r : 20.r;
    final double iconSize = screenWidth < 600 ? 24.sp : 28.sp;
    final double contentPadding = screenWidth < 600 ? 20.w : 25.w;
    final double borderWidth = screenWidth < 600 ? 1.5.w : 2.w;
    
    // Calculate text sizes - significantly increased for tablet
    final double textSize = screenWidth < 600 ? 16.sp : 24.sp;
    final double hintSize = screenWidth < 600 ? 16.sp : 12.sp;

    return Stack(
      children: [
        TextFormField(
          focusNode: focusNode,
          inputFormatters: [
            inputFormatter ?? TextInputFormatter.withFunction((oldValue, newValue) => newValue),
          ],
          maxLength: maxLength,
          initialValue: initialValue,
          textInputAction: textInputAction ?? (nextFocusNode != null ? TextInputAction.next : TextInputAction.done),
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontSize: textSize,
            height: 1.2,
          ),
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: AppColors.cardPrimary,
            hintText: hintText,
            hintStyle: isOptional ? Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: hintSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ):null,
            // isDense: true,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: AppColors.cardBorder,
                width: borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: AppColors.cardBorder,
                width: borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: AppColors.textPrimary,
                width: borderWidth * 1.2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: contentPadding,
              vertical: screenWidth < 600 ? 16.h : 24.h,
            ),
            prefixIcon: prefixIcon != null
                ? GestureDetector(
                    onTap: onPrefixTap,
                    child: Icon(
                      prefixIcon,
                      color: Colors.grey,
                      size: iconSize,
                    ),
                  )
                : null,
          ),
        ),
        if (suffixIcon != null)
          Positioned(
            right: contentPadding,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon,
                  color: suffixIconColor ?? Colors.grey,
                  size: iconSize,
                ),
              ),
            ),
          ),
        if (suffixSvgPath != null)
          Positioned(
            right: contentPadding,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: onSuffixTap,
                child: SvgPicture.asset(
                  suffixSvgPath!,
                  colorFilter: ColorFilter.mode(
                    suffixIconColor ?? Colors.grey,
                    BlendMode.srcIn,
                  ),
                  width: iconSize * 0.8,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
