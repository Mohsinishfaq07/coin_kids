import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(NotificationActionId)? onActionPressed;

  const NotificationCard({
    super.key,
    required this.notification,
    this.isSelected = false,
    this.onTap,
    this.onActionPressed,
  });

  String _getTitle() {
    return notification.title;
  }

  String _getDesc() {
    final metadata = notification.metadata;
    if (metadata == null) return notification.title;

    switch (metadata.type) {
      case NotificationType.goalMilestone:
        final goalMetadata = metadata as GoalMilestoneMetadata;
        return goalMetadata.goalName;

      case NotificationType.transactionPending:
        final data = metadata as TransactionPendingMetadata;
        return '${data.name} request ${data.amount}';

      case NotificationType.goalCompleted:
        final goalMetadata = metadata as GoalCompletedMetadata;
        return '${goalMetadata.name} Completed Goal <b>${goalMetadata.goalName}, saved ${goalMetadata.targetAmount}</b>';

      case NotificationType.balanceAdded:
      case NotificationType.balanceRemoved:
        final balanceMetadata = metadata as BalanceMetadata;
        final action = metadata.type == NotificationType.balanceAdded ? "added to" : "deducted from";
        return "${balanceMetadata.amount.toMoneyFormat()} $action balance";

      case NotificationType.defaultNotification:
      default:
        return notification.title;
    }
  }

  String? _getKidAvatarUrl() {
    final metadata = notification.metadata;
    if (metadata is GoalCompletedMetadata) {
      return metadata.photo;
    } else if (metadata is TransactionPendingMetadata) {
      return metadata.photo;
    } else if (metadata is GoalMilestoneMetadata) {
      return metadata.photo;
    }
    return null;
  }

  List<Widget> _getActionButtons() {
    final metadata = notification.metadata;
    if (metadata == null) return [];

    if (metadata is TransactionPendingMetadata) {
      if (metadata.status == TransactionPendingStatus.approved || 
          metadata.status == TransactionPendingStatus.declined) {
        return [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              metadata.status == TransactionPendingStatus.approved 
                ? "Request Approved" 
                : "Request Declined",
              style: AppTextStyle.bodyMedium.copyWith(color: metadata.status == TransactionPendingStatus.approved? AppColors.notificationPositive : AppColors.notificationWarning),
            ),
          ),
        ];
      }
      return metadata.actions.map((action) {
        Color buttonColor;
        switch (action.type) {
          case NotificationActionType.critical:
            buttonColor = AppColors.critical;
            break;
          case NotificationActionType.secondary:
            buttonColor = AppColors.colorSecondary;
            break;
          default:
            buttonColor = AppColors.colorPrimary;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ElevatedButton(
            onPressed: () => onActionPressed?.call(action.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
            ),
            child: Text(
              action.label,
              style: AppTextStyle.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        );
      }).toList();
    }

    return metadata.actions.map((action) {
      Color buttonColor;
      switch (action.type) {
        case NotificationActionType.critical:
          buttonColor = AppColors.critical;
          break;
        case NotificationActionType.secondary:
          buttonColor = AppColors.colorSecondary;
          break;
        default:
          buttonColor = AppColors.colorPrimary;
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ElevatedButton(
          onPressed: () => onActionPressed?.call(action.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
          ),
          child: Text(
            action.label,
            style: AppTextStyle.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final kidAvatarUrl = _getKidAvatarUrl();
    final actionButtons = _getActionButtons();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.colorSecondary.withValues(alpha: 0.1) : const Color(0xFFEDFAFF),
          border: Border.all(color: const Color(0xFFCBE5F4)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kid Avatar
                      CircleAvatarWidget(
                        size: 40,
                        imagePath: kidAvatarUrl,
                        imageType: ImageType.network,
                      ),
                      SizedBox(width: 12.w),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTitle(),
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              timeago.format(notification.timestamp),
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (_getDesc().isNotEmpty) SizedBox(height: 12.h),
                            if (_getDesc().isNotEmpty)
                              Text(
                                _getDesc(),
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread Indicator
                if (!notification.isRead)
                  Positioned(
                    top: 12.r,
                    right: 12.r,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            // Action Buttons
            if (actionButtons.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actionButtons,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
