import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'notifications';

  // Create new notification
  Future<DocumentReference> createNotification(NotificationModel notification) async {
    try {
      final docRef = await _firestore.collection(collection).add(notification.toJson());
      return docRef;
    } catch (e) {
      throw Exception('Failed to create notification: ${e.toString()}');
    }
  }

  // Fetch notification by ID
  Future<NotificationModel?> fetchNotificationById(String notificationId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(collection).doc(notificationId).get();
      
      if (!doc.exists) {
        return null;
      }

      return NotificationModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
    } catch (e) {
      throw Exception('Failed to fetch notification: ${e.toString()}');
    }
  }

  // Fetch notifications for a user
  Future<List<NotificationModel>> fetchUserNotifications(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user notifications: ${e.toString()}');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection(collection).doc(notificationId).update({
        'isRead': true
      });
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
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
  Future<int> getUnreadCount(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread count: ${e.toString()}');
    }
  }

  // Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: ${e.toString()}');
    }
  }
}