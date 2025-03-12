import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/presentation/components/common/cached_network_image_widget.dart';
import 'package:coin_kids/presentation/components/common/circle_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(String)? onActionPressed;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.isSelected = false,
    this.onTap,
    this.onActionPressed,
  }) : super(key: key);

  String _getTitle() {
    final metadata = notification.metadata;
    if (metadata == null) return notification.message;

    switch (metadata.type) {
      case NotificationType.goal_milestone:
        final goalMetadata = metadata as GoalMilestoneMetadata;
        return 'Goal Progress: ${goalMetadata.goalName}';
      case NotificationType.transaction_pending:
      case NotificationType.transaction_approved:
      case NotificationType.transaction_rejected:
        final transactionMetadata = metadata as TransactionMetadata;
        return 'Transaction ${metadata.type.toString().split('_').last}: \$${transactionMetadata.amount}';
      case NotificationType.balance_added:
      case NotificationType.balance_removed:
        final balanceMetadata = metadata as BalanceMetadata;
        return '${metadata.type == NotificationType.balance_added ? 'Added' : 'Removed'} \$${balanceMetadata.amount} from ${balanceMetadata.jarName}';
      case NotificationType.wishlist_added:
        final wishlistMetadata = metadata as WishlistMetadata;
        return 'New Wishlist Item: ${wishlistMetadata.itemName}';
      case NotificationType.system_notification:
        final systemMetadata = metadata as SystemNotificationMetadata;
        return systemMetadata.title;
      case NotificationType.goal_completed:
        final goalMetadata = metadata as GoalCompletedMetadata;
        return 'Goal Completed: ${goalMetadata.goalName}';
    }
  }

  String _getDescription() {
    final metadata = notification.metadata;
    if (metadata == null) return '';

    switch (metadata.type) {
      case NotificationType.goal_milestone:
        final goalMetadata = metadata as GoalMilestoneMetadata;
        return 'Progress: ${(goalMetadata.progressPercentage * 100).toStringAsFixed(0)}% (\$${goalMetadata.currentAmount} of \$${goalMetadata.targetAmount})';
      case NotificationType.transaction_pending:
      case NotificationType.transaction_approved:
      case NotificationType.transaction_rejected:
        final transactionMetadata = metadata as TransactionMetadata;
        return transactionMetadata.note ?? 'No note provided';
      case NotificationType.balance_added:
      case NotificationType.balance_removed:
        final balanceMetadata = metadata as BalanceMetadata;
        return 'New Balance: \$${balanceMetadata.newBalance}';
      case NotificationType.wishlist_added:
        final wishlistMetadata = metadata as WishlistMetadata;
        return 'Price: \$${wishlistMetadata.price}';
      case NotificationType.system_notification:
        return notification.message;
      case NotificationType.goal_completed:
        final goalMetadata = metadata as GoalCompletedMetadata;
        return 'Achieved \$${goalMetadata.targetAmount} goal in ${goalMetadata.achievementDuration}! 🎉';
    }
  }

  String? _getImageUrl() {
    final metadata = notification.metadata;
    if (metadata == null) return notification.imageUrl;

    if (metadata is WishlistMetadata) {
      return metadata.imageUrl;
    } else if (metadata is GoalCompletedMetadata) {
      return metadata.imageUrl;
    }
    return notification.imageUrl;
  }

  String? _getKidAvatarUrl() {
    final metadata = notification.metadata;
    if (metadata is GoalCompletedMetadata) {
      return metadata.kidAvatarUrl;
    }
    return null;
  }

  List<Widget> _getActionButtons() {
    final metadata = notification.metadata;
    if (metadata == null) return [];

    return metadata.actions.map((action) {
      Color buttonColor;
      switch (action.type) {
        case 'critical':
          buttonColor = AppColors.critical;
          break;
        case 'secondary':
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
    final imageUrl = _getImageUrl();
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
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              timeago.format(notification.timestamp),
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _getDescription(),
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notification Image
                      if (imageUrl != null) ...[
                        SizedBox(width: 12.w),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: CachedNetworkImageWidget(
                            imageUrl: imageUrl,
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
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
                      decoration: const BoxDecoration(
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
