import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/messages_screen/messages_screen.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
 
class MessagePlaceholderScreen extends StatelessWidget {
  const MessagePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Message"),
      body: Container(
          decoration: const BoxDecoration(gradient: AppColors.background),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  AppAssets.cloudImageSvg,
                  // height: 252.h,
                  width: 399.w,
                ),
              ),
              Positioned(
                  bottom: 100.h,
                  top: 100.h,
                  left: 0.w,
                  right: 0.w,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/messages.svg"),
                        SizedBox(
                          height: 20.h,
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.to(MessagesScreen());
                            },
                            child: SizedBox(
                              width: 312.w,
                              child: Text('No Messages!',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.bodyMedium),
                            )),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}
