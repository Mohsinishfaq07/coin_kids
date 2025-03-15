import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as time_ago;

Widget buildNotificationTile(MessagesController controller, NotificationModel notification) {
  return Obx(() {
    final isSelected = controller.selectedNotifications.contains(notification.id);

    return ListTile(
      selected: isSelected,
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            if (controller.selectedNotifications.isNotEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue : Colors.transparent,
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Icon(
                    isSelected ? Icons.check : _getNotificationIcon(notification.type),
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
      onTap: () {
        if (controller.selectedNotifications.isNotEmpty) {
          controller.toggleSelection(notification.id!);
        } else {
          _handleNotificationTap(notification);
        }
      },
      onLongPress: () => controller.toggleSelection(notification.id!),
      title: Text(
        notification.title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        time_ago.format(notification.timestamp),
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey,
        ),
      ),
      trailing: !notification.isRead
          ? Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColors.buttonPrimary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  });
}

Widget buildNotificationTileCompact(KidProfileController controller, NotificationModel notification) {
  return ListTile(
    leading: Icon(
      _getNotificationIcon(notification.type),
    ),
    onTap: () {
      _handleNotificationTap(notification);
    },
    title: Text(
      notification.title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
      ),
    ),
    subtitle: Text(
      time_ago.format(notification.timestamp),
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.grey,
      ),
    ),
    trailing: !notification.isRead
        ? Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary,
              shape: BoxShape.circle,
            ),
          )
        : null,
  );
}

IconData _getNotificationIcon(NotificationType type) {
  switch (type) {
    case NotificationType.goalMilestone:
      return Icons.flag;
    case NotificationType.goalCompleted:
      return Icons.emoji_events;
    case NotificationType.transactionPending:
      return Icons.pending;
    case NotificationType.balanceAdded:
      return Icons.add_card;
    case NotificationType.defaultNotification:
      return Icons.notifications;
    default:
      return Icons.notifications;
  }
}

void _handleNotificationTap(NotificationModel notification) {
  if (notification.actionUrl != null) {
    // Handle deep linking
  }

  switch (notification.type) {
    case NotificationType.goalMilestone:
    case NotificationType.goalCompleted:
      Get.toNamed(Routes.parentKidProfile);
      break;

    case NotificationType.transactionPending:
      Get.toNamed(Routes.parentQuickTransfer);
      break;
    default:
      Get.log(notification.toString());
  }
}
