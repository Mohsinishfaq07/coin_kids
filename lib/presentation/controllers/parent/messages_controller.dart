import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/quick_transfer_controller.dart';
import 'package:coin_kids/presentation/dialogs/parent/app_parent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/utils/toast_util.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/remote_services/notification_service.dart';

class MessagesController extends GetxController {
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final selectedNotifications = <String>[].obs;
  final notifications = <NotificationModel>[].obs;
  final unreadNotificationsCount = 0.obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMoreData = true.obs;
  final GoalService goalService = Get.find<GoalService>();
  final appState = Get.find<AppStateController>();
  DocumentSnapshot? _lastDocument;
  final refreshController = RefreshController(initialRefresh: false);
  StreamSubscription? _notificationCountSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(refresh: true);
    getUnReadNotificationCount();
  }

  @override
  void onClose() {
    _notificationCountSubscription?.cancel();
    super.onClose();
  }

  void getUnReadNotificationCount() async {
    final userId = Get.find<AuthService>().user.value?.uid;
    if (userId == null) {
      ToastUtil.showToast("Session Expired");
      Get.offAllNamed(Routes.signIn);
      return;
    }

    _notificationCountSubscription =
        _notificationService.getUnreadCount(userId).listen((int count) {
      unreadNotificationsCount.value = count;
    });
  }

  Future<void> onRefresh() async {
    hasMoreData.value = true;
    _lastDocument = null;
    await fetchNotifications(refresh: true);
    refreshController.refreshCompleted();
  }

  Future<void> onLoading() async {
    await fetchNotifications();
    refreshController.loadComplete();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    try {
      if (refresh) {
        notifications.clear();
        _lastDocument = null;
      }

      if (!hasMoreData.value && !refresh) {
        refreshController.loadNoData();
        return;
      }

      final userId = Get.find<AuthService>().user.value?.uid;
      if (userId == null) return;

      final result = await _notificationService.getNotificationsPaginated(
        userId,
        lastDocument: _lastDocument,
      );

      if (result.notifications.isEmpty) {
        hasMoreData.value = false;
        if (!refresh) {
          refreshController.loadNoData();
        }
      } else {
        if (refresh) {
          notifications.clear();
        }
        notifications.addAll(result.notifications);
        _lastDocument = result.lastDocument;
      }
    } catch (e) {
      Get.log('Error fetching notifications: $e');
      ToastUtil.showToast('Failed to load notifications');
      if (refresh) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void toggleSelection(String notificationId) {
    if (selectedNotifications.contains(notificationId)) {
      selectedNotifications.remove(notificationId);
    } else {
      selectedNotifications.add(notificationId);
    }
  }

  Future<void> markSelectedAsRead(bool isRead) async {
    if (selectedNotifications.isEmpty) return;

    try {
      await _notificationService.updateSelectedNotifications(
        selectedNotifications,
        isRead: isRead,
      );

      // Update local notifications
      for (var i = 0; i < notifications.length; i++) {
        if (selectedNotifications.contains(notifications[i].id)) {
          final updatedNotification = notifications[i].copyWith(isRead: isRead);
          notifications[i] = updatedNotification;
        }
      }

      selectedNotifications.clear();
      ToastUtil.showToast('Notifications updated');
    } catch (e) {
      Get.log('Error updating notifications: $e');
      ToastUtil.showToast('Failed to update notifications');
    }
  }

  Future<void> updatePendingTransactionStatus(
      String notificationId, TransactionPendingStatus status) async {
    try {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final metaData =
            notifications[index].metadata as TransactionPendingMetadata;
        metaData.copyWith(status: status);
        notifications[index] =
            notifications[index].copyWith(metadata: metaData);
        notifications.refresh();
      }

      await _notificationService.updatePendingTransactionStatus(
          notificationId, status);
    } catch (e) {
      Get.log('Error updating status: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        notifications.refresh();
      }

      // await _notificationService.markAsRead(notificationId);
    } catch (e) {
      Get.log('Error updating notifications: $e');
      ToastUtil.showToast('Failed to update notifications');
    }
  }

  Future<void> deleteSelected() async {
    try {
      await _notificationService
          .deleteSelectedNotifications(selectedNotifications);
      notifications.removeWhere((n) => selectedNotifications.contains(n.id));
      selectedNotifications.clear();
      ToastUtil.showToast('Notifications deleted');
    } catch (e) {
      Get.log('Error deleting notifications: $e');
      ToastUtil.showToast('Failed to delete notifications');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      notifications
          .removeWhere((notification) => notification.id == notificationId);
    } catch (e) {
      Get.log('Error deleting notification: $e');
      ToastUtil.showToast('Failed to delete notification');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final userId = Get.find<AuthService>().user.value?.uid;
      if (userId == null) return;

      await _notificationService.deleteAllNotifications(userId);
      ToastUtil.showToast('All notifications deleted');
    } catch (e) {
      Get.log('Error deleting all notifications: $e');
      ToastUtil.showToast('Failed to delete all notifications');
    }
  }

  void clearSelection() {
    selectedNotifications.clear();
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = Get.find<AuthService>().user.value?.uid;
      if (userId == null) return;

      await _notificationService.markAllAsRead(userId);

      // // Update all local notifications
      // for (var i = 0; i < notifications.length; i++) {
      //   if (!notifications[i].isRead) {
      //     final updatedNotification = notifications[i].copyWith(isRead: true);
      //     notifications[i] = updatedNotification;
      //   }
      // }
    } catch (e) {
      Get.log('Error marking all notifications as read: $e');
      ToastUtil.showToast('Failed to mark all as read');
    }
  }

  Future<void> handleActionClick(
      NotificationModel notification, NotificationActionId actionId) async {
    if (notification.type == NotificationType.transactionPending) {
      Get.log(notification.type.name);
      if (actionId == NotificationActionId.positive) {
        final metadata = notification.metadata as TransactionPendingMetadata;
        // Get.toNamed(Routes.parentQuickTransfer, arguments: {
        //   'amount': metadata.amount,
        //   'mode': TransferMode.requestedMoney,
        // });
        Get.log(notification.id!);
        await markAsRead(notification.id!);
        await updatePendingTransactionStatus(
            notification.id!, TransactionPendingStatus.approved);
      } else if (actionId == NotificationActionId.negative) {
        Get.log(notification.id!);
        await markAsRead(notification.id!);
        await updatePendingTransactionStatus(
            notification.id!, TransactionPendingStatus.declined);
      }
    } else if (notification.type == NotificationType.goalMilestone) {
      if (actionId == NotificationActionId.positive) {
        await markAsRead(notification.id!);
        Get.toNamed(Routes.parentKidProfile, arguments: KidProfileTabs.goals);
      }
    } else if (notification.type == NotificationType.goalCompleted) {
      final metadata = notification.metadata as GoalCompletedMetadata;
      await markAsRead(notification.id!);

      try {
        final kidName = appState.currentKid.value?.name ?? "child";
        // Fetch the goal directly using goalService
        final goal = await goalService.fetchGoalById(metadata.goalId);
        if (goal == null) {
          ToastUtil.showToast('Goal not found');
          return;
        }

        if (actionId == NotificationActionId.positive) {
          // Show approval confirmation dialog
          final shouldApprove = await Get.dialog<bool>(
            AppParentDialog(
              iconPath: Assets.icCoinEuro,
              title: "Approve Goal",
              subtitle:
              "An amount of ${goal.targetAmount.toMoneyFormat()} will be deducted from $kidName's account",
               buttons: [
                DialogButton(
                  text: "Cancel",
                  onPressed: () => Get.back(result: false),
                  backgroundColor: AppColors.btnColorOrange,
                  textColor: Colors.white,
                ),
                DialogButton(
                  text: "Approve",
                  onPressed: () => Get.back(result: true),
                  backgroundColor: AppColors.btnColorGreen,
                  textColor: Colors.white,
                ),
              ],
            ),
          );

          if (shouldApprove == true) {
            // Approve the goal
            await goalService.approveGoal(goal);

            // Create notification for the kid
            final notification = NotificationModel(
              userId: goal.userId,
              senderId: Get.find<AuthService>().user.value?.uid ?? '',
              title: "Goal Approved!",
              type: NotificationType.goalApproved,
              isRead: false,
              timestamp: DateTime.now(),
              metadata: GoalApprovedMetadata(
                goalId: goal.id!,
                goalName: goal.title,
                targetAmount: goal.targetAmount,
                name: appState.currentParent.value?.name ?? '',
                photo: appState.currentParent.value?.imageUrl ?? '',
              ),
            );

            await _notificationService.createNotification(notification);
            ToastUtil.showToast('Goal approved successfully');
          }
        } else if (actionId == NotificationActionId.negative) {
          // Show rejection confirmation dialog
          final shouldReject = await Get.dialog<bool>(
            AppParentDialog(
              iconPath: Assets.icCoinEuro,
              title: "Confirm Rejection",
            subtitle:   "An amount of ${goal.targetAmount.toMoneyFormat()} will be refunded from $kidName's account",
              buttons: [
                DialogButton(
                  text: "Cancel",
                  onPressed: () => Get.back(result: false),
                  backgroundColor: AppColors.btnColorGreen,
                  textColor: Colors.white,
                ),
                DialogButton(
                  text: "Reject",
                  onPressed: () => Get.back(result: true),
                  backgroundColor: AppColors.critical,
                  textColor: Colors.white,
                ),
              ],
            ),
          );

          if (shouldReject == true) {
            // Get the current kid
            final kid = appState.currentKid.value;
            if (kid == null) {
              ToastUtil.showToast('Session Expired. Login Again');
              Get.offAllNamed(Routes.signIn);
              return;
            }

            // Get the kid service
            final kidService = Get.find<KidService>();

            // Calculate new spending jar balance by adding the goal's saved amount
            final newSpendingBalance =
                kid.wallet.spendingJar.balance + goal.savedAmount;

            // Update spending jar balance to refund the amount
            await kidService.updateSpendingJar(kid.kidId, newSpendingBalance);

            // Update goal status
            await goalService.cancelGoal(goal);

            // Create notification for the kid
            final notification = NotificationModel(
              userId: goal.userId,
              senderId: Get.find<AuthService>().user.value?.uid ?? '',
              title: "Goal Rejected",
              type: NotificationType.goalRejected,
              isRead: false,
              timestamp: DateTime.now(),
              metadata: GoalRejectedMetadata(
                goalId: goal.id!,
                goalName: goal.title,
                targetAmount: goal.targetAmount,
                name: appState.currentParent.value?.name ?? '',
                photo: appState.currentParent.value?.imageUrl ?? '',
              ),
            );

            await _notificationService.createNotification(notification);
            ToastUtil.showToast(
                'Goal rejected and amount refunded successfully');
          }
        }

        // Remove the notification after successful action
        await deleteNotification(notification.id!);

        // Refresh the notifications list
        await fetchNotifications(refresh: true);
      } catch (e) {
        ToastUtil.showToast('Failed to process goal action: ${e.toString()}');
        Get.log('Error processing goal action: $e');
      }
    }
  }
}
