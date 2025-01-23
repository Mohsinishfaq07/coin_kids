import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_custom_button.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set your background color here
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background SVG
            Positioned(
              top: 60.h, // Adjust the position to match the design
              left: 100.w,
              child: SvgPicture.asset(
                AppAssets.kidOnBoarding1SpotLight, // Path to your SVG
                // fit: BoxFit.cover,
                width: 291.w,
                height: 104.h,
              ),
            ),
            // Text
            Positioned(
              top: 75.h, // Adjust the position to match the design
              left: 0.w,
              right: 0.w, // Adjust the position to match the design
              child: Text(
                "What's your name? ✍️",
                style: AppTextStyle.headingMedium.copyWith(
                  color: AppColors.textOnPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Dialog Box
            Positioned(
              top: 156.h, // Adjust the position to align with the design
              left: -30.w, // Adjust the position to align with the design
              child: Container(
                width: 463.w,
                height: 82.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffD9D9D9),
                ),
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  width: 444.w,
                  height: 65.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.iconDisabled, width: 3),
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color(0xffFFFFFF),
                  ),
                  child: Text(
                    "“Enter your name” e.g. Alex",
                    style: AppTextStyle.headingMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SpotLight2DialogueBox extends StatelessWidget {
//   const SpotLight2DialogueBox({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> ageList = ['6', '7', '8', '9', '10', '11', '12', '13', '14+'];
//     return Scaffold(
//       backgroundColor: Colors.transparent, // Set your background color here
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Positioned(
//               top: 156.h, // Adjust the position to align with the design
//               left: -30.w, // Adjust the position to align with the design
//               child: Container(
//                 width: 463.w,
//                 height: 82.h,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   color: AppColors.buttonDisabled,
//                 ),
//                 child: SizedBox(
//                   height: 50.h,
//                   width: double.infinity,
//                   child: ListView.builder(
//                     itemCount: ageList.length,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(right: 5.w),
//                         child: kidCustomButton(
//                           height: 50.h,
//                           width: 50.w,
//                           buttonColor: AppColors.textOnPrimary,
//                           borderColor: AppColors.textPrimary,
//                           radius: 50.0,
//                           onTap: () {},
//                           buttonWidget: Text(
//                             ageList[index],
//                             style: AppTextStyle.headingMedium,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             // Background SVG
//             Positioned(
//               top: 80.h, // Adjust the position to match the design
//               left: 100.w,
//
//               child: SvgPicture.asset(
//                 AppAssets.kidOnBoarding2SpotLight, // Path to your SVG
//                 fit: BoxFit.cover,
//                 width: 295.5.w,
//                 height: 94.5.h,
//               ),
//             ),
//             // Text
//             Positioned(
//               top: 90.h, // Adjust the position to match the design
//               left: 60.w,
//               right: 0.w,
//               // Adjust the position to match the design
//
//               child: Text(
//                 "How old are you? 🎂",
//                 style: AppTextStyle.headingMedium.copyWith(
//                   color: AppColors.textOnPrimary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             // Dialog Box
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SpotLight3DialogueBox extends StatelessWidget {
//   const SpotLight3DialogueBox({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> avatars = [
//       "assets/child_avatar_image_pngs/Frame 1.png",
//       "assets/child_avatar_image_pngs/Frame 2.png",
//       "assets/child_avatar_image_pngs/Frame 3.png",
//       "assets/child_avatar_image_pngs/Frame 4.png",
//       "assets/child_avatar_image_pngs/Frame 5.png",
//       "assets/child_avatar_image_pngs/Frame 6.png",
//       "assets/child_avatar_image_pngs/Frame 7.png",
//       "assets/child_avatar_image_pngs/Frame 8.png",
//       "assets/child_avatar_image_pngs/Frame 9.png",
//       "assets/child_avatar_image_pngs/Frame 10.png",
//       "assets/child_avatar_image_pngs/Frame 11.png",
//       "assets/child_avatar_image_pngs/Frame 12.png",
//       "assets/child_avatar_image_pngs/Frame 13.png",
//       "assets/child_avatar_image_pngs/Frame 14.png",
//       "assets/child_avatar_image_pngs/Frame 15.png",
//       "assets/child_avatar_image_pngs/Frame 16.png",
//       "assets/child_avatar_image_pngs/Frame 17.png",
//       "assets/child_avatar_image_pngs/Frame 18.png",
//       "assets/child_avatar_image_pngs/Frame 19.png",
//       "assets/child_avatar_image_pngs/Frame 20.png",
//       "assets/child_avatar_image_pngs/Frame 21.png",
//       "assets/child_avatar_image_pngs/Frame 22.png",
//       "assets/child_avatar_image_pngs/Frame 23.png",
//       "assets/child_avatar_image_pngs/Frame 24.png",
//       "assets/child_avatar_image_pngs/Frame 25.png",
//       "assets/child_avatar_image_pngs/Frame 26.png",
//       "assets/child_avatar_image_pngs/Frame 27.png",
//       "assets/child_avatar_image_pngs/Frame 28.png",
//       "assets/child_avatar_image_pngs/Frame 29.png",
//       "assets/child_avatar_image_pngs/Frame 30.png",
//       "assets/child_avatar_image_pngs/Frame 31.png",
//       "assets/child_avatar_image_pngs/Frame 32.png",
//       "assets/child_avatar_image_pngs/Frame 33.png",
//       "assets/child_avatar_image_pngs/Frame 34.png",
//       "assets/child_avatar_image_pngs/Frame 35.png",
//       "assets/child_avatar_image_pngs/Frame 36.png"
//     ];
//     return Scaffold(
//       backgroundColor: Colors.transparent, // Set your background color here
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Positioned(
//               top: 156.h, // Adjust the position to align with the design
//               left: -30.w, // Adjust the position to align with the design
//               child: Container(
//                 width: 461.w,
//                 height: 255.h,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   color: AppColors.buttonDisabled,
//                 ),
//                 child: Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 5, // Number of avatars in one row
//                       crossAxisSpacing: 26.w, // Space between columns
//                       mainAxisSpacing: 16.h, // Space between rows
//                     ),
//                     itemCount: avatars.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.all(4.h),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // Avatar Image
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(60.r),
//                               ),
//                               child: Image.asset(
//                                 avatars[index],
//                                 height: 60.h, // Adjust the size of the avatar
//                                 width: 60.w,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             // Background SVG
//             Positioned(
//               top: 80.h, // Adjust the position to match the design
//               left: 100.w,
//               child: SvgPicture.asset(
//                 AppAssets.kidOnBoarding1SpotLight, // Path to your SVG
//                 fit: BoxFit.cover,
//                 width: 295.5.w,
//                 height: 94.5.h,
//               ),
//             ),
//             // Text
//             Positioned(
//               top: 90.h, // Adjust the position to match the design
//               left: 0.w,
//               right: 0.w, // Adjust the position to match the design
//               child: Text(
//                 "Choose an Avatar",
//                 style: AppTextStyle.headingMedium.copyWith(
//                   color: AppColors.textOnPrimary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             // Dialog Box
//           ],
//         ),
//       ),
//     );
//   }
// }
