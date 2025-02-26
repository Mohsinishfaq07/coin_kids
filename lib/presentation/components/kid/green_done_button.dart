import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GreenDoneButton extends StatelessWidget {
  final VoidCallback onTap;
  const GreenDoneButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      
      child: Container(
        width: 120.w,
        height: 32.h,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFF19B859),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.22.w, color: const Color(0xFF0E9454)),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20.w,
              right: 12.w,
              top: 4.h,
              bottom: 4.h,
              child: Row(
                children: [
                  Text(
                    "Done",
                    style: AppTextStyle.headingMedium.copyWith(
                        color: AppColors.textOnPrimary, fontSize: 22.sp),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.transparent, // Background color (optional)
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Blur radius for the shadow
                            offset:
                                const Offset(2, 4), // Shadow position (x, y)
                          ),
                        ],
                        shape: BoxShape
                            .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                      ),
                      child: SvgPicture.asset(
                        "assets/arrorDirectionNoShadow.svg",
                        fit: BoxFit.cover,
                        height: 10.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                left: 1,
                top: 1.29,
                child: Image.asset(
                  "assets/Button_shadow.png",
                  height: 10.h,
                )),
          ],
        ),
      ),
    );
  }
}
