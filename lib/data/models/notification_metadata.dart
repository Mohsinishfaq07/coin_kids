import 'package:coin_kids/data/models/notification_model.dart';
import 'package:get/get.dart';

enum NotificationActionType { primary, secondary, critical }

enum NotificationActionId { positive, negative, neutral }

class NotificationAction {
  final NotificationActionId id;
  final String label;
  final NotificationActionType type; // 'primary', 'secondary', 'critical'

  const NotificationAction({
    required this.id,
    required this.label,
    required this.type,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) {
    return NotificationAction(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      type: json['type'] ?? 'primary',
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'label': label,
        'type': type,
      };
}

abstract class NotificationMetadata {
  final NotificationType type;

  List<NotificationAction> get actions;

  const NotificationMetadata(this.type);

  Map<String, dynamic> toJson();
}

class GoalMilestoneMetadata extends NotificationMetadata {
  final String goalId;
  final String goalName;
  final String name;
  final String photo;
  final double targetAmount;
  final double currentAmount;

  GoalMilestoneMetadata({
    required this.goalId,
    required this.goalName,
    required this.name,
    required this.photo,
    required this.targetAmount,
    required this.currentAmount,
  }) : super(NotificationType.goalMilestone);

  factory GoalMilestoneMetadata.fromJson(Map<String, dynamic> json) {
    return GoalMilestoneMetadata(
      goalId: json['goalId'] ?? '',
      goalName: json['goalName'] ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'goalId': goalId,
        'goalName': goalName,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
      };

  @override
  List<NotificationAction> get actions =>
      [
        NotificationAction(
            id: NotificationActionId.positive,
            label: 'View details',
            type: NotificationActionType.primary),
      ];
}

class GoalCompletedMetadata extends NotificationMetadata {
  final String goalId;
  final String goalName;
  final double targetAmount;
  final String? photo;
  final String? name;

  GoalCompletedMetadata({
    required this.goalId,
    required this.goalName,
    required this.targetAmount,
    this.name,
    this.photo,
  }) : super(NotificationType.goalCompleted);

  factory GoalCompletedMetadata.fromJson(Map<String, dynamic> json) {
    return GoalCompletedMetadata(
      goalId: json['goalId'] ?? '',
      goalName: json['goalName'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      name: json['name'],
      photo: json['photo'],
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'goalId': goalId,
        'goalName': goalName,
        'targetAmount': targetAmount,
        'name': name,
        'photo': photo,
      };

  @override
  List<NotificationAction> get actions =>
      [
        NotificationAction(
          id: NotificationActionId.positive,
          label: 'See details',
          type: NotificationActionType.primary,
        ),
      ];
}

enum TransactionPendingStatus { pending, approved, declined }

class TransactionPendingMetadata extends NotificationMetadata {
  final double amount;
  final String name;
  final String photo;
  final TransactionPendingStatus status;

  TransactionPendingMetadata({
    required this.amount,
    required this.name,
    required this.photo,
    required this.status,
  }) : super(NotificationType.transactionPending);

  factory TransactionPendingMetadata.fromJson(Map<String, dynamic> json) {
    // Convert string status name back to enum
    TransactionPendingStatus status =
        TransactionPendingStatus.pending; // Default value

    if (json['status'] != null) {
      // Try to match the string name to an enum value
      try {
        final String statusName = json['status'];
        for (var enumValue in TransactionPendingStatus.values) {
          if (enumValue.name == statusName) {
            status = enumValue;
            break;
          }
        }
      } catch (e) {
        Get.log('Error parsing transaction status: $e');
      }
    }

    return TransactionPendingMetadata(
      amount: json['amount'] ?? 0.0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      status: status, // Use the converted enum value
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'amount': amount,
        'name': name,
        'photo': photo,
        'status': status.name,
      };

  TransactionPendingMetadata copyWith({
    double? amount,
    String? name,
    String? photo,
    TransactionPendingStatus? status,
  }) {
    return TransactionPendingMetadata(
      amount: amount ?? this.amount,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      status: status ?? this.status,
    );
  }

  @override
  List<NotificationAction> get actions =>
      [
        NotificationAction(
            id: NotificationActionId.negative,
            label: 'Decline',
            type: NotificationActionType.critical),
        NotificationAction(
            id: NotificationActionId.positive,
            label: 'Accept',
            type: NotificationActionType.primary),
      ];
}

class TransactionMetadata extends NotificationMetadata {
  final double amount;

  TransactionMetadata({
    required this.amount,
    required NotificationType type,
  }) : super(type);

  factory TransactionMetadata.fromJson(Map<String, dynamic> json,
      NotificationType type) {
    return TransactionMetadata(
      amount: json['amount'] ?? 0.0,
      type: type,
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'amount': amount,
      };

  @override
  List<NotificationAction> get actions => [];
}

class BalanceMetadata extends NotificationMetadata {
  final double amount;
  final String? message;

  BalanceMetadata({
    required this.amount,
    this.message,
    required NotificationType type,
  }) : super(type);

  factory BalanceMetadata.fromJson(Map<String, dynamic> json,
      NotificationType type) {
    return BalanceMetadata(
      amount: (json['amount'] ?? 0.0).toDouble(),
      message: (json['message'] ?? ""),
      type: type,
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'amount': amount,
        'message': message,
      };

  @override
  List<NotificationAction> get actions => [];
}

class GoalApprovedMetadata extends NotificationMetadata {
  final String goalId;
  final String goalName;
  final double targetAmount;
  final String name;
  final String photo;

  GoalApprovedMetadata({
    required this.goalId,
    required this.goalName,
    required this.targetAmount,
    required this.name,
    required this.photo,
  }) : super(NotificationType.goalApproved);

  factory GoalApprovedMetadata.fromJson(Map<String, dynamic> json) {
    return GoalApprovedMetadata(
      goalId: json['goalId'] ?? '',
      goalName: json['goalName'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'goalId': goalId,
        'goalName': goalName,
        'targetAmount': targetAmount,
        'name': name,
        'photo': photo,
      };

  @override
  List<NotificationAction> get actions =>
      [
        NotificationAction(
          id: NotificationActionId.positive,
          label: 'View details',
          type: NotificationActionType.primary,
        ),
      ];
}

class GoalRejectedMetadata extends NotificationMetadata {
  final String goalId;
  final String goalName;
  final double targetAmount;
  final String name;
  final String photo;

  GoalRejectedMetadata({
    required this.goalId,
    required this.goalName,
    required this.targetAmount,
    required this.name,
    required this.photo,
  }) : super(NotificationType.goalRejected);

  factory GoalRejectedMetadata.fromJson(Map<String, dynamic> json) {
    return GoalRejectedMetadata(
      goalId: json['goalId'] ?? '',
      goalName: json['goalName'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'goalId': goalId,
        'goalName': goalName,
        'targetAmount': targetAmount,
        'name': name,
        'photo': photo,
      };

  @override
  List<NotificationAction> get actions =>
      [
        NotificationAction(
          id: NotificationActionId.positive,
          label: 'View details',
          type: NotificationActionType.primary,
        ),
      ];
}
