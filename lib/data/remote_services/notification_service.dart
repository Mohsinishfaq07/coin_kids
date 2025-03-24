import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:get/get.dart';

import '../models/notification_model.dart';

class NotificationService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'notifications';
  final int pageSize = 20; // Number of notifications per page

  // Create new notification
  Future<DocumentReference> createNotification(
      NotificationModel notification) async {
    try {
      return await _firestore.collection(collection).add(notification.toJson());
    } catch (e) {
      throw Exception('Failed to create notification: ${e.toString()}');
    }
  }

  // Fetch notifications for a user
  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data(), id: doc.id))
            .toList());
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(collection)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in notifications.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception(
          'Failed to mark all notifications as read: ${e.toString()}');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection(collection).doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: ${e.toString()}');
    }
  }

  // Get unread notifications count
  Stream<int> getUnreadCount(String userId) {
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Delete all notifications for a user
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in notifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all notifications: ${e.toString()}');
    }
  }

  // Get notifications by type
  Future<List<NotificationModel>> getNotificationsByType(
      String userId, NotificationType type) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type.toString().split('.').last)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(
              doc.data() as Map<String, dynamic>,
              id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications by type: ${e.toString()}');
    }
  }

  // Update the pagination method
  Future<PaginationResult> getNotificationsPaginated(
    String userId, {
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromJson(
              doc.data() as Map<String, dynamic>,
              id: doc.id))
          .toList();

      return PaginationResult(
        notifications,
        snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      throw Exception('Failed to fetch notifications: ${e.toString()}');
    }
  }

  // Batch update for selected notifications
  Future<void> updateSelectedNotifications(
    List<String> notificationIds, {
    required bool isRead,
  }) async {
    try {
      final batch = _firestore.batch();
      for (var id in notificationIds) {
        final docRef = _firestore.collection('notifications').doc(id);
        batch.update(docRef, {'isRead': isRead});
      }
      await batch.commit();
    } catch (e) {
      throw Exception(
          'Failed to update selected notifications: ${e.toString()}');
    }
  }

  // Delete selected notifications
  Future<void> deleteSelectedNotifications(List<String> notificationIds) async {
    try {
      final batch = _firestore.batch();
      for (var id in notificationIds) {
        final docRef = _firestore.collection('notifications').doc(id);
        batch.delete(docRef);
      }
      await batch.commit();
    } catch (e) {
      throw Exception(
          'Failed to delete selected notifications: ${e.toString()}');
    }
  }

  // Get all notifications for a user (non-paginated)
  Future<List<NotificationModel>> getAllNotifications(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(
              doc.data() as Map<String, dynamic>,
              id: doc.id))
          .toList();
    } catch (e) {
      Get.log('Failed to fetch all notifications: ${e.toString()}');
      return []; // Return empty list instead of throwing to handle errors gracefully
    }
  }

  // Get all unread notifications for a user
  Future<List<NotificationModel>> getAllUnreadNotifications(
      String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(
              doc.data() as Map<String, dynamic>,
              id: doc.id))
          .toList();
    } catch (e) {
      Get.log('Failed to fetch unread notifications: ${e.toString()}');
      return []; // Return empty list instead of throwing to handle errors gracefully
    }
  }

  // Mark notification as read
  Future<void> updatePendingTransactionStatus(
      String notificationId, TransactionPendingStatus status) async {
    try {
      await _firestore
          .collection(collection)
          .doc(notificationId)
          .update({'metadata.status': status.name});
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }
}

class PaginationResult {
  final List<NotificationModel> notifications;
  final DocumentSnapshot? lastDocument;

  PaginationResult(this.notifications, this.lastDocument);
}
