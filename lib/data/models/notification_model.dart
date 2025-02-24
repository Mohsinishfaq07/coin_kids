import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  money_request_response,
  goal_completed,
  reward_earned,
  task_assigned,
  task_completed
}

class NotificationModel {
  final String? id;
  final String userId;
  final String senderId;
  final NotificationType type;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    this.id,
    required this.userId,
    required this.senderId,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return NotificationModel(
      id: id,
      userId: json['userId'] ?? '',
      senderId: json['senderId'] ?? '',
      type: _stringToNotificationType(json['type'] ?? ''),
      message: json['message'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
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
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? senderId,
    NotificationType? type,
    String? message,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  static NotificationType _stringToNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'money_request_response':
        return NotificationType.money_request_response;
      case 'goal_completed':
        return NotificationType.goal_completed;
      case 'reward_earned':
        return NotificationType.reward_earned;
      case 'task_assigned':
        return NotificationType.task_assigned;
      case 'task_completed':
        return NotificationType.task_completed;
      default:
        return NotificationType.money_request_response;
    }
  }
}