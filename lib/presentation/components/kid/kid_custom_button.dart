import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

kidCustomButton(
    {required Color buttonColor,
    required Function() onTap,
    required Widget buttonWidget,
    double? radius,
    double? height,
    double? width,
    Color? borderColor}) {
  double borderRadius = radius ?? 13.r;
  double buttonHeight = height ?? 42.h;
  double buttonWidth = width ?? 92.w;
  Color colorForBorder = borderColor ?? Colors.transparent;

  return GestureDetector(
    onTap: onTap,
    child: Stack(children: [
      Container(
        alignment: Alignment.center,
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: buttonColor,
            border: Border.all(color: colorForBorder, width: 2.2.w)),
        child: Row(
          children: [
            // Image.asset(
            //   "assets/Button_shadow.png",
            //   color: Colors.white,
            // ),
            buttonWidget,
          ],
        ),
      ),
      // Positioned(
      //     left: 2.w,
      //     right: 0.w,
      //     top: 2.h,
      //     child: Image.asset(
      //       "assets/Button_shadow.png",
      //       color: Colors.white,
      //     )),
    ]),
  );
}


// class CustomButton extends StatelessWidget {
//   final double width;
//   final double height;
//   final String text;
//   final TextStyle? textStyle;
//   final Color backgroundColor;
//   final Color borderColor;
//   final double borderWidth;
//   final double borderRadius;
//   final Widget? leadingIcon;
//   final Widget? trailingIcon;

//   const CustomButton({
//     Key? key,
//     this.width = 92.0,
//     this.height = 30.0,
//     required this.text,
//     this.textStyle,
//     this.backgroundColor = const Color(0xFF19B859),
//     this.borderColor = const Color(0xFF0E9454),
//     this.borderWidth = 2.22,
//     this.borderRadius = 13.0,
//     this.leadingIcon,
//     this.trailingIcon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width.w,
//       height: height.h,
//       clipBehavior: Clip.antiAlias,
//       decoration: ShapeDecoration(
//         color: backgroundColor,
//         shape: RoundedRectangleBorder(
//           side: BorderSide(width: borderWidth, color: borderColor),
//           borderRadius: BorderRadius.circular(borderRadius.r),
//         ),
//       ),
//       child: Stack(
//         children: [
//           Center(
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: textStyle ??
//                   TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontFamily: 'Open Sans',
//                     fontWeight: FontWeight.w800,
//                   ),
//             ),
//           ),
//           if (leadingIcon != null)
//             Positioned(
//               left: 10.w,
//               top: (height / 2 - 10).h, // Center the icon vertically
//               child: leadingIcon!,
//             ),
//           if (trailingIcon != null)
//             Positioned(
//               right: 10.w,
//               top: (height / 2 - 10).h, // Center the icon vertically
//               child: trailingIcon!,
//             ),
//         ],
//       ),
//     );
//   }
// }
