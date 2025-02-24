import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/screens/parent/bottom_navigation/parent_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TransferSuccessDialog extends StatelessWidget {
  final String receiverName;
  final String amount;
  final String title;
  final String transferType;

  const TransferSuccessDialog({
    super.key,
    required this.receiverName,
    required this.amount,
    required this.title,
    required this.transferType,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),

              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.buttonPrimary, // Purple background
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: SvgPicture.asset(
                    "assets/Vector2.svg",
                    height: 30.h,
                    width: 30.w,
                  ),
                ),
              ),
              //Icon
              SizedBox(
                height: 10.h,
              ),
              // Transfer successful title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textHighlighted,
                  fontSize: 18.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),

              // Receiver information
              RichText(
                text: TextSpan(
                  text: '$receiverName $transferType ',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF015486),
                  ),
                  children: [
                    TextSpan(
                      text: '€ $amount',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF015486),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.off(() => ParentBaseScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
