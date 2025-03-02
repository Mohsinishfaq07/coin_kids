// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:avatar_glow/avatar_glow.dart';
// import 'dart:math';
//
// class HalfCircleWithButtonsWidget extends StatelessWidget {
//   final RxInt clickedIndex;
//   final Function(int) onButtonTap;
//
//   HalfCircleWithButtonsWidget({
//     required this.clickedIndex,
//     required this.onButtonTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.green, // Background color
//       child: Stack(
//         children: [
//           HalfCircleWidget(), // The half-circle widget
//           Positioned(
//             right: 0, // Aligns the child to the right corner
//             top: 0, // Aligns the child to the top
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the top
//               children: [
//                 // First Button
//                 GestureDetector(
//                   onTap: () {
//                     onButtonTap(0);
//                   },
//                   child: Obx(() {
//                     final isSelected = clickedIndex.value == 0;
//                     return isSelected
//                         ? AvatarGlow(
//                       glowRadiusFactor: 0.3.r,
//                       startDelay: const Duration(seconds: 2),
//                       repeat: true,
//                       glowCount: 2,
//                       glowShape: BoxShape.circle,
//                       animate: true, // Glow only when selected
//                       duration: const Duration(seconds: 2),
//                       glowColor: Colors.blue,
//                       child: _buildButton(isSelected, "assets/notes.svg"),
//                     )
//                         : _buildButton(isSelected, "assets/notes.svg");
//                   }),
//                 ),
//                 SizedBox(height: 20.h),
//                 // Second Button
//                 GestureDetector(
//                   onTap: () {
//                     onButtonTap(1);
//                   },
//                   child: Obx(() {
//                     final isSelected = clickedIndex.value == 1;
//                     return isSelected
//                         ? AvatarGlow(
//                       glowRadiusFactor: 0.3.r,
//                       startDelay: const Duration(seconds: 2),
//                       repeat: true,
//                       glowCount: 2,
//                       glowShape: BoxShape.circle,
//                       animate: true, // Glow only when selected
//                       duration: const Duration(seconds: 2),
//                       glowColor: Colors.blue,
//                       child: _buildButton(isSelected, "assets/Coin.svg"),
//                     )
//                         : _buildButton(isSelected, "assets/Coin.svg");
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButton(bool isSelected, String assetPath) {
//     return Container(
//       width: 50.w,
//       height: 50.h,
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.blue : Colors.grey,
//         shape: BoxShape.circle,
//       ),
//       child: SvgPicture.asset(
//         assetPath,
//         width: 30.w,
//         height: 30.h,
//       ),
//     );
//   }
// }
//
// class HalfCircleWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: RightHalfCircleClipper(), // Clip the right half circle
//       child: Container(
//         width: 155.w, // Set the width for the right half-circle
//         height: 80.h, // Set the height for the right half-circle
//         color: Colors.blue, // Fill color for the right half-circle
//         child: CustomPaint(
//           painter: RightHalfCircleBorderPainter(),
//         ),
//       ),
//     );
//   }
// }
//
// class RightHalfCircleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final Path path = Path();
//     path.moveTo(size.width / 2, 0); // Start from the middle of the top
//     path.arcTo(
//       Rect.fromLTWH(0, 0, size.width, size.height), // Full oval bounds
//       -pi / 2, // Start angle (top center)
//       pi, // Sweep angle (half circle to the bottom center)
//       false,
//     );
//     path.lineTo(size.width / 2, size.height); // Closing the path
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
//
// class RightHalfCircleBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Color(0xFFC0E1EB) // Border color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2; // Border thickness
//
//     final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     canvas.drawArc(rect, -pi / 2, pi, false, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
