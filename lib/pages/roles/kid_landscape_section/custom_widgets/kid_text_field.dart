import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KidCustomTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onChange;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  const KidCustomTextField({
    Key? key,
    required this.hintText,
    required this.onChange,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  _KidCustomTextFieldState createState() => _KidCustomTextFieldState();
}

class _KidCustomTextFieldState extends State<KidCustomTextField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  Color _borderColor = const Color(0xFF848484); // Default grey border color

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      if (_focusNode.hasFocus) {
        _borderColor = AppColors.textPrimary; // Focused state color
      } else if (_controller.text.isEmpty) {
        _borderColor = const Color(0xFF848484); // Grey when unfocused and empty
      } else {
        _borderColor = AppColors.textPrimary; // Custom color when valid
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 444.w,
      // height: 65.h,
      child: TextField(
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) {
          widget.onChange(value);
          setState(() {
            _borderColor = value.isEmpty
                ? const Color(0xFF848484) // Grey when empty
                : AppColors.textPrimary; // Custom color for valid input
          });
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          hintStyle: AppTextStyle.headingMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          fillColor: const Color(0xffffffff), // Filled color: white
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: _borderColor, // Dynamic border color
              width: 2.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: _borderColor, // Dynamic border color
              width: 2.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.textPrimary, // Border color for focused state
              width: 2.w,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
