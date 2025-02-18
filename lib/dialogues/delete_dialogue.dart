import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/green_next_button.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteGoalDialog extends StatelessWidget {
  final String label;
  final String subLabel;
  final Function YesonTap;

  const DeleteGoalDialog(
      {Key? key,
      required this.label,
      required this.subLabel,
      required this.YesonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 40.h,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            AppAssets.dialogueBGSvg,
            fit: BoxFit.fill,
            height: 90.h,
            width: 100.w,
          ),
          Positioned(
            top: -12.h,
            left: 0.w,
            right: 0.w,
            child: Column(children: [
              SvgPicture.asset(
                "assets/bin.svg",
                width: 30.w,
                height: 26.h,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  subLabel,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GreenNextButton(
                        backgroundColor: AppColors.critical,
                        borderColor: AppColors.notificationCritical,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        buttonText: "No",
                        showPrefix: true,
                      ),
                      SizedBox(width: 20.w),
                      GreenNextButton(
                        onTap: () {
                          YesonTap();
                          Navigator.pop(context);
                        },
                        buttonText: "Yes",
                        showPrefix: true,
                        prefixSvg: AppAssets.kidTickButton,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// Function to show the delete goal confirmation dialog
void showDeleteGoalDialog(
  BuildContext context, {
  required String label,
  required String subLabel,
  required Function YesonTap,
}) {
  showModalBottomSheet(
    enableDrag: true,
    elevation: 0,
    barrierColor: Colors.black26,
    isDismissible: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DeleteGoalDialog(
      label: label,
      subLabel: subLabel,
      YesonTap: YesonTap,
    ),
  );
}
