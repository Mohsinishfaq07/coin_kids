import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/kid/green_next_button.dart';

class DeleteGoalDialog extends StatelessWidget {
  final String label;
  final String subLabel;
  final Function YesonTap;
  final String? imageAsset; // Can be SVG, PNG, or null

  const DeleteGoalDialog({
    Key? key,
    required this.label,
    required this.subLabel,
    this.imageAsset, // Optional
    required this.YesonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40.h),
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
              _buildIcon(imageAsset), // Fixed: Handles null values
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
                        fontSize: 15.sp,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
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
                    onTap: () async {
                      try {
                        await YesonTap(); // Handle potential errors
                        Navigator.pop(context);
                      } catch (e) {
                        print("Error while deleting goal: $e");
                      }
                    },
                    buttonText: "Yes",
                    showPrefix: true,
                    prefixSvg: AppAssets.kidTickButton,
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  /// **Helper function to load either SVG or PNG**
  Widget _buildIcon(String? assetPath) {
    if (assetPath == null) {
      // Use default SVG icon if assetPath is null
      assetPath = "assets/bin.svg";
    }

    if (assetPath.toLowerCase().endsWith(".svg")) {
      return SvgPicture.asset(
        assetPath,
        width: 30.w,
        height: 26.h,
        placeholderBuilder: (context) => _defaultIcon(),
      );
    } else if (assetPath.toLowerCase().endsWith(".png") ||
        assetPath.toLowerCase().endsWith(".jpg")) {
      return Image.asset(
        assetPath,
        width: 40.w,
        height: 26.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print("Failed to load image: $error");
          return _defaultIcon();
        },
      );
    } else {
      return _defaultIcon();
    }
  }

  /// **Default fallback icon**
  Widget _defaultIcon() {
    return Icon(
      Icons.delete,
      size: 30.w,
      color: Colors.white,
    );
  }
}

/// **Function to show the delete goal confirmation dialog**
void showDeleteGoalDialog(
  BuildContext context, {
  required String label,
  required String subLabel,
  required Function YesonTap,
  String? imageAsset, // Can be SVG or PNG
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
      imageAsset: imageAsset, // Can be null
    ),
  );
}
