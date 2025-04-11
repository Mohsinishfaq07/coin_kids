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
    return Stack(
      children: [
        TextFormField(
            focusNode: focusNode,
            inputFormatters: [
              inputFormatter != null
                  ? inputFormatter!
                  : TextInputFormatter.withFunction(
                      (oldValue, newValue) {
                        return newValue;
                      },
                    ),
            ],
            maxLength: maxLength,
            initialValue: initialValue,
            textInputAction: textInputAction ??
                (nextFocusNode != null
                    ? TextInputAction.next
                    : TextInputAction.done),
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            enabled: enabled,
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              hintText: hintText,
              hintStyle: isOptional
                  ? AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: CustomThemeData().borderColor,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: CustomThemeData().borderColor,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.textPrimary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 20, right: 12),
              prefixIcon: prefixIcon != null
                  ? GestureDetector(
                      onTap: onPrefixTap,
                      child: Icon(prefixIcon, color: Colors.grey),
                    )
                  : null,
            ),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w800,
                  color: CustomThemeData().primaryTextColor,
                )),
        if (suffixIcon != null)
          Positioned(
            right: 12.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon,
                  color: suffixIconColor ?? Colors.grey,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        if (suffixSvgPath != null)
          Positioned(
            right: 12.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: onSuffixTap,
                child: SvgPicture.asset(
                  suffixSvgPath!,
                  colorFilter: ColorFilter.mode(
                      suffixIconColor ?? Colors.grey, BlendMode.srcIn),
                  width: 24.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
