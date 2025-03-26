import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/common/cached_network_image_widget.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timelines_plus/timelines_plus.dart';

class CustomTimeline extends StatelessWidget {
  final List<TimelineItem> items;

  const CustomTimeline({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0.2,
        color: AppColors.colorPrimary,
        connectorTheme: ConnectorThemeData(
          thickness: 2.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.after,
        itemCount: items.length,
        contentsBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(items[index].title,
                    style: AppTextStyle.headingMedium.copyWith(
                        color: items[index].isCompleted
                            ? AppColors.buttonPrimary
                            :
                            // AppColors.textPrimary
                            items[index].isRejected
                                ? AppColors.critical
                                : AppColors.textPrimary)),
                if (items[index].subtitle != null)
                  Text(items[index].subtitle!,
                      style: AppTextStyle.headingSmall.copyWith(
                          color: items[index].isRejected
                              ? AppColors.critical
                              : items[index].isCompleted
                                  ? AppColors.buttonPrimary
                                  : AppColors.iconDisabled)),
              ],
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return ContainerIndicator(
            child: SizedBox(
              width: 40.w,
              height: 40.w,
              child: Center(
                child: items[index].imageType != ImageType.network
                    ? SvgPicture.asset(
                        items[index].photo,
                        width: 36.w,
                        height: 36.w,
                        colorFilter: ColorFilter.mode(
                            items[index].isCompleted
                                ? Colors.transparent
                                : AppColors.iconDisabled,
                            BlendMode.srcATop),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.buttonPrimary, width: 2.w),
                            borderRadius: BorderRadius.circular(30.r)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: CachedNetworkImageWidget(
                            imageUrl: items[index].photo,
                            width: 36.w,
                            height: 36.w,
                            errorAsset: Assets.icAvatarPlaceholder,
                            fit: BoxFit.cover,
                            iconColor: items[index].isCompleted
                                ? null
                                : AppColors.iconDisabled,
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
        connectorBuilder: (_, index, __) {
          return items[index].isCompleted
              ? SolidLineConnector(
                  color: AppColors.colorPrimary,
                )
              : DashedLineConnector(
                  color: items[index].isCompleted
                      ? AppColors.colorPrimary
                      : AppColors.iconDisabled,
                );
        },
      ),
    );
  }
}

class TimelineItem {
  final String date;
  final String title;
  final String? subtitle;
  final String photo;
  final ImageType imageType;
  final bool isCompleted;
  final bool isRejected;

  TimelineItem({
    required this.date,
    required this.title,
    this.subtitle,
    required this.photo,
    required this.imageType,
    this.isCompleted = false,
    this.isRejected = false,
  });
}
