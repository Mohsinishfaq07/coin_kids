import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/parent/quick_transfer_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/utils/toast_util.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/remote_services/notification_service.dart';

class MessagesController extends GetxController {
  final NotificationService _notificationService = Get.find<NotificationService>();
  final selectedNotifications = <String>[].obs;
  final notifications = <NotificationModel>[].obs;
  final unreadNotificationsCount = 0.obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMoreData = true.obs;


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

    _notificationCountSubscription = _notificationService.getUnreadCount(userId).listen((int count) {
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

  Future<void> updatePendingTransactionStatus(String notificationId, TransactionPendingStatus status) async {
    try {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final metaData = notifications[index].metadata as TransactionPendingMetadata;
        metaData.copyWith(status: status);
        notifications[index] = notifications[index].copyWith(metadata: metaData);
        notifications.refresh();
      }

      await _notificationService.updatePendingTransactionStatus(notificationId, status);
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
      await _notificationService.deleteSelectedNotifications(selectedNotifications);
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
      notifications.removeWhere((notification) => notification.id == notificationId);
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

  void handleActionClick(NotificationModel notification, NotificationActionId actionId) {
    if (notification.type == NotificationType.transactionPending) {
      Get.log(notification.type.name);
      if (actionId == NotificationActionId.positive) {
        final metadata = notification.metadata as TransactionPendingMetadata;
        Get.toNamed(Routes.parentQuickTransfer, arguments: {
          'amount': metadata.amount,
          'mode': TransferMode.requestedMoney,
        });
        Get.log(notification.id!);
        markAsRead(notification.id!);
        updatePendingTransactionStatus(notification.id!, TransactionPendingStatus.approved);
      } else if (actionId == NotificationActionId.negative) {
        Get.log(notification.id!);
        markAsRead(notification.id!);
        updatePendingTransactionStatus(notification.id!, TransactionPendingStatus.declined);
      }
    } else if (notification.type == NotificationType.goalMilestone) {
      if (actionId == NotificationActionId.positive) {
        markAsRead(notification.id!);
        Get.toNamed(Routes.parentKidProfile, arguments: KidProfileTabs.goals);
      }
    } else if (notification.type == NotificationType.goalCompleted) {
      if (actionId == NotificationActionId.positive) {
        markAsRead(notification.id!);
        Get.toNamed(Routes.parentKidProfile, arguments: 2);
      }
    }
  }
}
