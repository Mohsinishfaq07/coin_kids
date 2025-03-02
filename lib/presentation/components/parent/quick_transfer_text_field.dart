import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class QuickTransferTextField extends StatefulWidget {
  const QuickTransferTextField({
    this.controller,
    required this.hintText,
    this.keyboardType,
    this.onFieldSubmitted,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.isPasswordField = false,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.onPressedSuffix,
    this.readOnly = false,
    this.width,
    this.height,
    this.label,
    this.autoValidateMode,
    this.fillColor = Colors.white,
    this.floatingLabelBehavior,
    super.key,
  });

  final String? label;
  final AutovalidateMode? autoValidateMode;
  final double? width;
  final double? height;
  final IconData? suffix;
  final Widget? prefix;
  final bool isPasswordField;
  final TextInputAction textInputAction;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? onFieldSubmitted;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final dynamic suffixIcon;
  final int? maxLength;
  final VoidCallback? onPressedSuffix;
  final bool readOnly;
  final Color? fillColor;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<QuickTransferTextField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<QuickTransferTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  Color _prefixContainerColor = Colors.grey; // Default color

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
    _focusNode = widget.focusNode ?? FocusNode();

    // Listen to focus changes
    _focusNode.addListener(() {
      setState(() {
        _prefixContainerColor = _focusNode.hasFocus
            ? Colors.blue.shade800
            : Colors.grey; // Update color based on focus
      });
    });
  }

  @override
  void dispose() {
    // Dispose the focus node to free up resources
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPasswordField) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffix != null && widget.onPressedSuffix != null) {
      return IconButton(
        icon: Icon(
          widget.suffix,
        ),
        onPressed: widget.onPressedSuffix,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double defaultHeight = widget.height ?? 50;

    return TextFormField(
      inputFormatters: [
        // Custom formatter to handle all rules
        TextInputFormatter.withFunction((oldValue, newValue) {
          // If empty, allow it
          if (newValue.text.isEmpty) {
            return newValue;
          }

          // Check if the input matches our valid number pattern
          // This regex ensures:
          // 1. Only numbers and single dot
          // 2. Maximum 2 decimal places
          // 3. Valid number format
          final validNumberPattern = RegExp(r'^\d*\.?\d{0,2}$');

          if (validNumberPattern.hasMatch(newValue.text)) {
            return newValue;
          }

          // If invalid, keep the old value
          return oldValue;
        }),
      ],
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      focusNode: _focusNode, // Use the local focus node
      controller: widget.controller,
      obscureText: _obscureText,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      cursorColor: Colors.blue.shade800,
      autovalidateMode: widget.autoValidateMode ?? AutovalidateMode.disabled,
      cursorHeight: 16.h,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal // Adjust text size as needed
          ),

      decoration: InputDecoration(
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: CustomThemeData().borderColor, // Border color when unfocused
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: CustomThemeData().borderColor, // Border color when enabled
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

        floatingLabelBehavior: widget.floatingLabelBehavior,
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: Colors.grey, fontSize: 15.sp, fontWeight: FontWeight.normal),
        labelStyle: TextStyle(color: Colors.grey.shade200, fontSize: 14.sp),
        suffixIcon: _buildSuffixIcon(),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefix != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: widget.prefix is String
                    ? SvgPicture.asset(
                        widget.prefix as String,
                        color: _prefixContainerColor, // Dynamic color
                        width: 20, // Adjust size as needed
                        height: 20,
                      )
                    : IconTheme(
                        data: IconThemeData(
                          color: _prefixContainerColor, // Dynamic color here
                        ),
                        child: widget.prefix!,
                      ),
              ),
            Container(
              height: defaultHeight - 15,
              width: 1,
              color: _prefixContainerColor, // Change the color here
            ),
            const SizedBox(width: 10),
          ],
        ),
        // Border when the TextFormField is focused

        // Border when the TextFormField is not focused

        hoverColor: Colors.transparent,
      ),
    );
  }
}
