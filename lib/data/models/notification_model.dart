import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_metadata.dart';

enum NotificationType {
  goal_milestone, // Goal progress notifications
  goal_completed, // Goal completion
  transaction_pending, // New transaction needs approval
  transaction_approved, // Transaction was approved
  transaction_rejected, // Transaction was rejected
  balance_added, // Money added to account
  balance_removed, // Money remove to account
  wishlist_added, // Item added to wishlist
  system_notification // General system notifications
}

class NotificationModel {
  final String? id;
  final String userId; // Recipient's ID
  final String senderId; // Sender's ID
  final NotificationType type;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationMetadata? metadata;
  final String? imageUrl; // Optional image URL
  final String? actionUrl; // Optional deep link or action URL

  NotificationModel({
    this.id,
    required this.userId,
    required this.senderId,
    required this.type,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
    this.imageUrl,
    this.actionUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final type = _stringToNotificationType(json['type'] ?? '');
    final metadata = json['metadata'] != null ? _parseMetadata(type, json['metadata']) : null;

    return NotificationModel(
      id: id,
      userId: json['userId'] ?? '',
      senderId: json['senderId'] ?? '',
      type: type,
      message: json['message'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
      metadata: metadata,
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'senderId': senderId,
      'type': type.toString().split('.').last,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (actionUrl != null) 'actionUrl': actionUrl,
    };
  }

  static NotificationType _stringToNotificationType(String type) {
    return NotificationType.values.firstWhere(
      (e) => e.toString().split('.').last == type,
      orElse: () => NotificationType.system_notification,
    );
  }

  static NotificationMetadata? _parseMetadata(NotificationType type, Map<String, dynamic> json) {
    switch (type) {
      case NotificationType.goal_milestone:
        return GoalMilestoneMetadata.fromJson(json);
      case NotificationType.transaction_pending:
      case NotificationType.transaction_approved:
      case NotificationType.transaction_rejected:
        return TransactionMetadata.fromJson(json, type);
      case NotificationType.balance_added:
      case NotificationType.balance_removed:
        return BalanceMetadata.fromJson(json, type);
      case NotificationType.wishlist_added:
        return WishlistMetadata.fromJson(json);
      case NotificationType.system_notification:
        return SystemNotificationMetadata.fromJson(json);
      default:
        return null;
    }
  }

  // Helper method to get relative time
  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 7) {
      return timestamp.toString().split(' ')[0]; // Return date only
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? senderId,
    NotificationType? type,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationMetadata? metadata,
    String? imageUrl,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}
