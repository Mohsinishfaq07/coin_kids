import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as time_ago;

class KidNotificationDialog extends StatefulWidget {
  final List<NotificationModel> notifications;
  final Function(NotificationModel) onDismissSingle;
  final VoidCallback onDismissAll;

  const KidNotificationDialog({
    super.key,
    required this.notifications,
    required this.onDismissSingle,
    required this.onDismissAll,
  });

  @override
  State<KidNotificationDialog> createState() => _KidNotificationDialogState();
}

class _KidNotificationDialogState extends State<KidNotificationDialog> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void nextNotification() {
    if (currentIndex < widget.notifications.length - 1) {
      final currentNotification = widget.notifications[currentIndex];
      setState(() {
        currentIndex++;
      });
      widget.onDismissSingle(currentNotification);
      print("Next Notification Tapped");
    }
  }

  void previousNotification() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add safety check
    if (widget.notifications.isEmpty) {
      Get.log("No notifications to display");
      return const SizedBox.shrink();
    }

    final notification = widget.notifications[currentIndex];
    final hasMultipleNotifications = widget.notifications.length > 1;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: 350.w,
            ),
            decoration: BoxDecoration(
                color:  AppColors.colorPrimary,
                borderRadius: BorderRadius.circular(24.r),
                image: DecorationImage(
                    image: AssetImage(Assets.kidDialogBgPng),
                    fit: BoxFit.fill
                )
            ),
            // margin: EdgeInsets.symmetric(vertical:14.r),
            width: MediaQuery.of(context).size.width *0.35,
            padding: EdgeInsets.all(4.r),

            child: Column(
               mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button and notification count
                Container(
                  color:Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Notification count
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${currentIndex + 1}/${widget.notifications.length}',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Close button
                      Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 48.w,  // Increased tap area
                          height: 48.w,  // Increased tap area
                          child: Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,  // Important for capturing all taps
                              onTap: () {
                                Get.log("Close button tapped");
                                Get.back();
                                widget.onDismissSingle(notification);
                                widget.onDismissAll();
                              },
                              child: SvgPicture.asset(
                                Assets.icRoundClose,
                                height: 32.w,
                                width: 32.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Padding(
                      padding:  EdgeInsets.only(bottom:6.h),
                      child: Text(
                        notification.title,
                        style: AppTextStyle.headingMedium.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        // maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ),


                    // Message
                      if (getNotificationDescription(notification).isNotEmpty)
                        Padding(
                          padding:  EdgeInsets.all(6.h),

                          child: Text(
                            getNotificationDescription(notification),
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textOnPrimary,

                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),

                    // SizedBox(height: 10.h),

                    // Timestamp
                    Text(
                      time_ago.format(notification.timestamp),
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.textOnPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),

                      SizedBox(height: 6.h),
                  ],
                ),
                // Navigation and action buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Previous button (only if multiple notifications)
                      if (hasMultipleNotifications)
                        Opacity(
                          opacity: currentIndex > 0 ? 1.0 : 0.3,
                          child: KidButton.iconOnly(
                            onTap: currentIndex > 0 ? previousNotification : () {},
                            baseColor: AppColors.btnColorOrange,
                            iconPath: Assets.icBack,
                            size: 40.r,
                            iconSize: 20.r,
                          ),
                        ),

                      // SizedBox(width: hasMultipleNotifications ? 10.w : 0),

                      // Action button
                      KidButton(
                        onTap: () {
                          if (currentIndex < widget.notifications.length - 1) {
                            nextNotification();
                          } else {
                            widget.onDismissSingle(notification);
                            widget.onDismissAll();
                          }
                        },
                        text: currentIndex < widget.notifications.length - 1
                            ? "Next"
                            : "Got it!",
                        baseColor: AppColors.btnColorGreen,
                      ),

                                 //     SizedBox(width: hasMultipleNotifications ? 16.w : 0),

                      // Next button (only if multiple notifications)
                      if (hasMultipleNotifications)
                        Opacity(
                          opacity: currentIndex < widget.notifications.length - 1
                              ? 1.0
                              : 0.3,
                          child: KidButton.iconOnly(
                            onTap: currentIndex < widget.notifications.length - 1
                                ? nextNotification
                                : () {},
                            baseColor: AppColors.btnColorOrange,
                            iconPath: Assets.icNext,
                            size: 40.r,
                            iconSize: 20.r,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -30.h,
            left: 0,
            right: 0,
            child:  _buildNotificationHeader(notification),)
        ],
      ),
    );
  }

  Widget _buildNotificationHeader(NotificationModel notification) {
    String iconPath;

    switch (notification.type) {
      case NotificationType.balanceRemoved:
      case NotificationType.goalRejected:
        iconPath = Assets.emojiSad;
        break;
      case NotificationType.balanceAdded:
      case NotificationType.transactionApproved:
      iconPath = Assets.icCoinEuro;
      case NotificationType.goalApproved:
        // iconPath = Assets.icCoinEuro;
      iconPath = Assets.icStar;
        break;
      case NotificationType.transactionRejected:
        iconPath = Assets.emojiSad;
        break;
      default:
        iconPath = Assets.icCoinEuro;
    }

    return iconPath.endsWith("svg")
        ? SvgPicture.asset(
            iconPath,
            width: 64.r,
            height: 64.r,
          )
        : Image.asset(
            iconPath,
            width: 64.r,
            height: 64.r,
          );
  }

  String getNotificationDescription(NotificationModel notification) {
    if (notification.type == NotificationType.balanceAdded ||
        notification.type == NotificationType.balanceRemoved) {
      final BalanceMetadata metaData = notification.metadata as BalanceMetadata;
      if (metaData.type == NotificationType.balanceAdded) {
        String text = "You received ${metaData.amount.toMoneyFormat()}";
        if (metaData.message != null && metaData.message!.isNotEmpty) {
          text = "$text\nMessage: ${metaData.message}";
        }
        return text;
      } else {
        String text = "${metaData.amount.toMoneyFormat()} Deducted from you";
        if (metaData.message != null && metaData.message!.isNotEmpty) {
          text = "$text\nMessage: ${metaData.message}";
        }
        return text;
      }
    } else if (notification.type == NotificationType.transactionApproved ||
        notification.type == NotificationType.transactionRejected) {
      final TransactionMetadata metaData = notification.metadata as TransactionMetadata;
      String text = notification.type == NotificationType.transactionApproved
          ? "${metaData.amount.toMoneyFormat()} added to your account"
          : "${metaData.amount.toMoneyFormat()} money request rejected";

      if (metaData.message != null && metaData.message!.isNotEmpty) {
        text = "$text\nMessage: ${metaData.message}";
      }
      return text;
    } else if (notification.type == NotificationType.goalApproved) {
      final GoalApprovedMetadata metaData =
          notification.metadata as GoalApprovedMetadata;
      // return "${metaData.name} has approved your goal '${metaData.goalName}'";
      return "it'll arrive soon ";
    } else if (notification.type == NotificationType.goalRejected) {
      final GoalRejectedMetadata metaData =
          notification.metadata as GoalRejectedMetadata;
      // return "${metaData.name} has rejected your goal '${metaData.goalName}'";
      return "The amount ${metaData.targetAmount} will be refunded";
    }
    return "";
  }
}


