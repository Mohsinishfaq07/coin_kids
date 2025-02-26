import 'package:cached_network_image/cached_network_image.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BasicInfoWidget extends GetView<KidProfileController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 36.h),
      child: Center(
        child: Container(
          width: 126.w,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: ShapeDecoration(
            color: const Color(0xFFEDFAFF),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 6,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.appState.currentKid.value!.name, style: AppTextStyle.bodyLarge),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundImage: CachedNetworkImageProvider(controller.appState.currentKid.value!.avatar),
                ),
              ),
              Text(
                'Available Money',
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 12.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "€${controller.appState.currentKid.value!.wallet.spendingJar.balance.toStringAsFixed(2)}",
                style: AppTextStyle.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
