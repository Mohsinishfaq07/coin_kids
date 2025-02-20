import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  final String titleText; // Required title for the field
  final String hintText; // Placeholder for the text field
  final TextEditingController? controller;
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

  const CustomTextField({
    this.isOptional = false,
    required this.titleText, // Title for the field is now required
    required this.hintText,
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400.w),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align title text to the left
        children: [
          // Text(
          //   titleText,
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 14,
          //     color: Color.fromARGB(255, 9, 90, 156), // Title color
          //   ),
          // ),
          // const SizedBox(height: 8), // Spacing between title and text field
          TextFormField(
              textInputAction: nextFocusNode != null
                  ? TextInputAction.next
                  : TextInputAction.done,
              controller: controller,
              onChanged: onChanged,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context)
                    .inputDecorationTheme
                    .fillColor, // Background color for the text field
                hintText: hintText,
                hintStyle: isOptional
                    ? TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal)
                    : null,

                // hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w700,color: CustomThemeData().primaryTextColor), // Hint text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: CustomThemeData()
                        .borderColor, // Border color when unfocused
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: CustomThemeData()
                        .borderColor, // Border color when enabled
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: AppColors.textPrimary, // Border color when focused
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 20, right: 12),
                prefixIcon: prefixIcon != null
                    ? GestureDetector(
                        onTap: onPrefixTap,
                        child: Icon(prefixIcon, color: Colors.grey),
                      )
                    : null, // Show prefix icon if provided
                suffixIcon: suffixIcon != null
                    ? GestureDetector(
                        onTap: onSuffixTap,
                        child: Icon(
                          suffixIcon,
                          color: suffixIconColor ?? Colors.grey,
                        ),
                      )
                    : suffixSvgPath != null
                        ? GestureDetector(
                            onTap: onSuffixTap,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                suffixSvgPath!,
                                color: suffixIconColor ?? Colors.grey,
                              ),
                            ),
                          )
                        : null,
              ),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: CustomThemeData().primaryTextColor,
                  )),
        ],
      ),
    );
  }
}
