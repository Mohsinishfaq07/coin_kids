import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/common/App_small_button.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/controllers/parent/messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  final MessagesController controller = Get.put(MessagesController());

  MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          showBackButton: false,
          title: 'Messages',
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.background),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                CustomCard(
                  avatarImage: "assets/child_avatar_image_pngs/Frame 1.png",
                  avatarImage1: "assets/image.png",
                  title: "Saving Goals Completed!",
                  subtitle: "Today at 9:42 AM",
                  icon: Icons.import_contacts,
                  iconBgColor: Colors.white,
                  titleColor: AppColors.textPrimary,
                  subtitleColor: Colors.grey,
                  actionText: "See details",
                  onActionTap: () {
                    // Define your action here
                    debugPrint("See details clicked!");
                  },
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.grey.shade200,
                              child: Image.asset(
                                "assets/child_avatar_image_pngs/Frame 1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Tairoh',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14.sp,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13.sp,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 1.38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'requested',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14.sp,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13.sp,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 1.38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '5 euros ',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14.sp,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 45.w,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: AppSmallButton(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.buttonPrimary,
                                onPressed: () {},
                                text: "Decline",
                                fontSize: 14.sp,
                              )

                                  // Container(
                                  //   width: 130.w,
                                  //   height: 36.h,
                                  //   decoration: ShapeDecoration(
                                  //     shape: RoundedRectangleBorder(
                                  //       side: BorderSide(
                                  //           width: 1.w, color: Color(0xFFA1A1A1)),
                                  //       borderRadius: BorderRadius.circular(24),
                                  //     ),
                                  //     shadows: const [
                                  //       BoxShadow(
                                  //         color: Color(0x0F101828),
                                  //         blurRadius: 3.59,
                                  //         offset: Offset(0, 1.80),
                                  //         spreadRadius: -1.80,
                                  //       ),
                                  //       BoxShadow(
                                  //         color: Color(0x19101828),
                                  //         blurRadius: 7.19,
                                  //         offset: Offset(0, 3.59),
                                  //         spreadRadius: -1.80,
                                  //       ),
                                  //     ],
                                  //     color: Colors.white,
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Text(
                                  //         'Decline',
                                  //         style: TextStyle(
                                  //           color: const Color(0xFFA421D9),
                                  //           fontSize: 14.sp,
                                  //           fontFamily: 'Open Sans',
                                  //           fontWeight: FontWeight.w700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

                                  ),
                              SizedBox(
                                width: 18.w,
                              ),
                              Expanded(
                                  child: AppSmallButton(
                                onPressed: () {},
                                text: "Approve",
                                fontSize: 14.sp,
                              )

                                  // Container(
                                  //   width: 130.w,
                                  //   height: 45.h,
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 18, vertical: 13),
                                  //   decoration: ShapeDecoration(
                                  //     color: Color(0xFFA421D9),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(24),
                                  //     ),
                                  //   ),
                                  //   child: const Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Text(
                                  //         'Approve',
                                  //         style: TextStyle(
                                  //           color: Colors.white,
                                  //           fontSize: 14,
                                  //           fontFamily: 'Open Sans',
                                  //           fontWeight: FontWeight.w700,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 52.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Today at 9:42 AM",
                                style: AppTextStyle.bodySmall.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                CustomCard(
                  avatarImage: "assets/child_avatar_image_pngs/Frame 7.png",
                  title: "James Goals Completed!",
                  subtitle: "Today at 9:42 AM",
                  icon: Icons.import_contacts,
                  iconBgColor: Colors.pink,
                  titleColor: Colors.blue.shade900,
                  subtitleColor: Colors.grey,
                  actionText: "",
                  onActionTap: () {
                    // Define your action here
                    debugPrint("See details clicked!");
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class CustomCard extends StatelessWidget {
  final String avatarImage;
  final String? avatarImage1;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final Color titleColor;
  final Color subtitleColor;
  final String actionText;
  final VoidCallback onActionTap;

  const CustomCard({
    Key? key,
    required this.avatarImage,
    this.avatarImage1,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.actionText,
    required this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.grey.shade200,
                      child: Image.asset(
                        avatarImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(title,
                        style: AppTextStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: AppColors.textPrimary)),
                  ],
                ),
                if (avatarImage1 != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        0), // Set this to 0 for a square, or increase for rounded corners
                    child: SizedBox(
                      width: 30.w, // Specify the width of the square
                      height: 30.h, // Specify the height of the square
                      child: Image.asset(
                        avatarImage1!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 52.w),
              child: Text(subtitle,
                  style: AppTextStyle.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: AppColors.textSecondary)),
            ),
            if (actionText.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(actionText,
                    style: AppTextStyle.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: AppColors.textHighlighted)),
              ),
            // Avatar Section
            // Column(
            //   children: [
            //     CircleAvatar(
            //       radius: 20,
            //       backgroundColor: Colors.grey.shade200,
            //       child: Image.asset(
            //         avatarImage,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //     const SizedBox(height: 10),
            //     const Text(
            //       "", // Static for now; customize further if needed.
            //     ),
            //   ],
            // ),

            // Main Text Section
            // Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 12.w),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [

            //         SizedBox(height: 13.5.h),

            //       ],
            //     ),
            //   ),
            // ),

            // Icon and Action Section
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Container(
            //       height: 40,
            //       width: 40,
            //       decoration: BoxDecoration(
            //         color: iconBgColor,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: Icon(
            //         icon,
            //         color: Colors.white,
            //         size: 24,
            //       ),
            //     ),
            //     const SizedBox(height: 10),
            //     GestureDetector(
            //       onTap: onActionTap,
            //       child: Text(
            //         actionText,
            //         style: const TextStyle(
            //           fontSize: 14,
            //           color: Colors.purple,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
