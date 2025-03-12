import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/remote_services/notification_service.dart';
import '../../../core/utils/toast_util.dart';

class MessagesController extends GetxController {
  final NotificationService _notificationService = Get.find<NotificationService>();
  final selectedNotifications = <String>[].obs;
  final notifications = <NotificationModel>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMoreData = true.obs;

  DocumentSnapshot? _lastDocument;
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(refresh: true);
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

      final userId = Get
          .find<AuthService>()
          .user
          .value
          ?.uid;
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
      print('Error fetching notifications: $e');
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
      print('Error updating notifications: $e');
      ToastUtil.showToast('Failed to update notifications');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (selectedNotifications.isEmpty) return;

    try {
      await _notificationService.markAsRead(notificationId);

      // Update local notifications
      for (var i = 0; i < notifications.length; i++) {
        if (selectedNotifications.contains(notifications[i].id)) {
          final updatedNotification = notifications[i].copyWith(isRead: true);
          notifications[i] = updatedNotification;
        }
      }

      selectedNotifications.clear();
      ToastUtil.showToast('Notifications updated');
    } catch (e) {
      print('Error updating notifications: $e');
      ToastUtil.showToast('Failed to update notifications');
    }
  }

  Future<void> deleteSelected() async {
    if (selectedNotifications.isEmpty) return;

    try {
      await _notificationService.deleteSelectedNotifications(selectedNotifications);
      notifications.removeWhere((n) => selectedNotifications.contains(n.id));
      selectedNotifications.clear();
      ToastUtil.showToast('Notifications deleted');
    } catch (e) {
      print('Error deleting notifications: $e');
      ToastUtil.showToast('Failed to delete notifications');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      ToastUtil.showToast('Notification deleted');
    } catch (e) {
      print('Error deleting notification: $e');
      ToastUtil.showToast('Failed to delete notification');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final userId = Get
          .find<AuthService>()
          .user
          .value
          ?.uid;
      if (userId == null) return;

      await _notificationService.deleteAllNotifications(userId);
      ToastUtil.showToast('All notifications deleted');
    } catch (e) {
      print('Error deleting all notifications: $e');
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
      
      // Update all local notifications
      for (var i = 0; i < notifications.length; i++) {
        if (!notifications[i].isRead) {
          final updatedNotification = notifications[i].copyWith(isRead: true);
          notifications[i] = updatedNotification;
        }
      }
      
      ToastUtil.showToast('All notifications marked as read');
    } catch (e) {
      print('Error marking all notifications as read: $e');
      ToastUtil.showToast('Failed to mark all as read');
    }
  }
}
