import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification_metadata.dart';

enum NotificationType {
  //Send to Parent
  goalMilestone, // Goal progress notifications
  goalCompleted, // Goal completion
  transactionPending, // New transaction needs approval

  //Send to Kid
  transactionApproved, // Transaction was approved
  transactionRejected, // Transaction was rejected
  balanceAdded, // Money added to account
  balanceRemoved, // Money remove to account
  goalApproved, // Goal was approved by parent
  goalRejected, // Goal was rejected by parent

  //Common
  defaultNotification,
}

class NotificationModel {
  final String? id;
  final String userId; // Recipient's ID
  final String senderId; // Sender's ID
  final NotificationType type;
  final String title;
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
    required this.title,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
    this.imageUrl,
    this.actionUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final type = _stringToNotificationType(json['type'] ?? '');
    final metadata = json['metadata'] != null
        ? _parseMetadata(type, json['metadata'])
        : null;

    return NotificationModel(
      id: id,
      userId: json['userId'] ?? '',
      senderId: json['senderId'] ?? '',
      type: type,
      title: json['title'] ?? '',
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
      'title': title,
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
      orElse: () => NotificationType.defaultNotification,
    );
  }

  static NotificationMetadata? _parseMetadata(
      NotificationType type, Map<String, dynamic> json) {
    switch (type) {
      case NotificationType.goalMilestone:
        return GoalMilestoneMetadata.fromJson(json);
      case NotificationType.goalCompleted:
        return GoalCompletedMetadata.fromJson(json);
      case NotificationType.goalApproved:
        return GoalApprovedMetadata.fromJson(json);
      case NotificationType.goalRejected:
        return GoalRejectedMetadata.fromJson(json);
      case NotificationType.transactionPending:
        return TransactionPendingMetadata.fromJson(json);
      case NotificationType.balanceAdded:
      case NotificationType.balanceRemoved:
        return BalanceMetadata.fromJson(json, type);
      case NotificationType.transactionApproved:
      case NotificationType.transactionRejected:
        return TransactionMetadata.fromJson(json, type);
      default:
        return null;
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
      title: message ?? title,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}
