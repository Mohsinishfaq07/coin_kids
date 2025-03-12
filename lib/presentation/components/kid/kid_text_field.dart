// import 'package:coin_kids/core/theme/color_theme.dart';
// import 'package:coin_kids/core/theme/text_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class KidCustomTextField extends StatefulWidget {
//   final String hintText;
//   final Function(String) onChange;
//   final TextInputAction textInputAction;
//   final TextInputType keyboardType;
//   final int? maxlength;
//   // final bool enabled;
//
//   const KidCustomTextField({
//     Key? key,
//     required this.hintText,
//     required this.onChange,
//     this.keyboardType = TextInputType.text,
//     this.textInputAction = TextInputAction.done,
//     this.maxlength,
//   //  this.enabled = true,
//   }) : super(key: key);
//
//   @override
//   _KidCustomTextFieldState createState() => _KidCustomTextFieldState();
// }
//
// class _KidCustomTextFieldState extends State<KidCustomTextField> {
//   final FocusNode _focusNode = FocusNode();
//   final TextEditingController _controller = TextEditingController();
//   Color _borderColor = const Color(0xFF848484); // Default grey border color
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_handleFocusChange);
//   }
//
//   void _handleFocusChange() {
//     setState(() {
//       if (_focusNode.hasFocus) {
//         _borderColor = AppColors.textPrimary; // Focused state color
//       } else if (_controller.text.isEmpty) {
//         _borderColor = const Color(0xFF848484); // Grey when unfocused and empty
//       } else {
//         _borderColor = AppColors.textPrimary; // Custom color when valid
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 444.w,
//       // height: 65.h,
//       child: TextField(
//         inputFormatters: [
//           // Custom formatter to handle all rules
//           TextInputFormatter.withFunction((oldValue, newValue) {
//             // If empty, allow it
//             if (newValue.text.isEmpty) {
//               return newValue;
//             }
//
//             // Check if the input matches our valid number pattern
//             // This regex ensures:
//             // 1. Only numbers and single dot
//             // 2. Maximum 2 decimal places
//             // 3. Valid number format
//             final validNumberPattern = RegExp(r'^\d*\.?\d{0,2}$');
//
//             if (validNumberPattern.hasMatch(newValue.text)) {
//               return newValue;
//             }
//
//             // If invalid, keep the old value
//             return oldValue;
//           }),
//         ],
//         maxLength: widget.maxlength,
//         keyboardType: widget.keyboardType,
//         textInputAction: widget.textInputAction,
//         controller: _controller,
//         focusNode: _focusNode,
//         onChanged: (value) {
//           widget.onChange(value);
//           setState(() {
//             _borderColor = value.isEmpty
//                 ? const Color(0xFF848484) // Grey when empty
//                 : AppColors.textPrimary; // Custom color for valid input
//           });
//         },
//       //  enabled: widget.enabled,
//
//         textAlign: TextAlign.center,
//         decoration: InputDecoration(
//
//           hintText: widget.hintText,
//           counterText: "",
//           filled: true,
//           hintStyle: AppTextStyle.headingMedium.copyWith(
//             fontWeight: FontWeight.w700,
//             color: AppColors.textSecondary,
//           ),
//           fillColor: const Color(0xffffffff), // Filled color: white
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(
//               color: _borderColor, // Dynamic border color
//               width: 2.w,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(
//               color: _borderColor, // Dynamic border color
//               width: 2.w,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(
//               color: AppColors.textPrimary, // Border color for focused state
//               width: 2.w,
//             ),
//           ),
//
//         ),
//
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _controller.dispose();
//     super.dispose();
//   }
// }
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KidTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onChange;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final int? maxlength;

  const KidTextField({
    Key? key,
    required this.hintText,
    required this.onChange,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxlength,
  }) : super(key: key);

  @override
  _KidTextFieldState createState() => _KidTextFieldState();
}

class _KidTextFieldState extends State<KidTextField> {
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
      child: TextField(
        inputFormatters: [
          // Custom formatter to handle all rules
          TextInputFormatter.withFunction((oldValue, newValue) {
            // If empty, allow it
            if (newValue.text.isEmpty) {
              return newValue;
            }

            // Check if the input matches our valid number pattern
            // This regex ensures:
            // 1. Allows alphabets
            // 2. Only allows numbers and single dot
            // 3. Limits the number of digits after the decimal to 2
            final validNumberPattern = RegExp(r'^[a-zA-Z0-9]*\.?\d{0,2}$');

            if (validNumberPattern.hasMatch(newValue.text)) {
              return newValue;
            }

            // If invalid, keep the old value
            return oldValue;
          }),
        ],
        maxLength: widget.maxlength,
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
          counterText: "",
          filled: true,
          hintStyle: AppTextStyle.headingMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          fillColor: const Color(0xffffffff),
          // Filled color: white
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
