import 'dart:io';

import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KidAvatarContainer extends StatelessWidget {
  final String kidName;
  final String avatarUrl;

  const KidAvatarContainer({
    super.key,
    required this.kidName,
    required this.avatarUrl,
  });

  String getKidAvatar(String localPath) {
    return File(localPath).existsSync() ? localPath : Assets.icAvatarPlaceholder;
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = 30.r;
    final iconSize = 30.r;
    return SizedBox(
      height: containerHeight + 10.r,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(left: iconSize / 2 + 12.r),
              child: Container(
                height: containerHeight,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  border: Border.all(color: const Color(0xff0095e5), width: 2.w),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: iconSize / 2, right: 12.w),
                  child: Text(
                    kidName,
                    style: AppTextStyle.headingMedium.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: containerHeight + 10.r,
              width: containerHeight + 10.r,
              child: CircleAvatarWidget(
                imagePath: avatarUrl,
                imageType: ImageType.network,
                placeholderAsset: Assets.icAvatarPlaceholder,
                errorAsset: Assets.icAvatarPlaceholder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
