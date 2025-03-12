import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/notification_model.dart';

class NotificationAction {
  final String id;
  final String label;
  final String type; // 'primary', 'secondary', 'critical'

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

  Map<String, dynamic> toJson() => {
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
  final double targetAmount;
  final double currentAmount;
  final double progressPercentage;

  GoalMilestoneMetadata({
    required this.goalId,
    required this.goalName,
    required this.targetAmount,
    required this.currentAmount,
    required this.progressPercentage,
  }) : super(NotificationType.goal_milestone);

  factory GoalMilestoneMetadata.fromJson(Map<String, dynamic> json) {
    return GoalMilestoneMetadata(
      goalId: json['goalId'] ?? '',
      goalName: json['goalName'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'goalId': goalId,
        'goalName': goalName,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'progressPercentage': progressPercentage,
      };

  @override
  List<NotificationAction> get actions => [
    NotificationAction(id: 'view', label: 'View Item', type: 'primary'),
  ];
}

class TransactionMetadata extends NotificationMetadata {
  final String transactionId;
  final double amount;
  final String fromJarId;
  final String toJarId;
  final String? note;

  TransactionMetadata({
    required this.transactionId,
    required this.amount,
    required this.fromJarId,
    required this.toJarId,
    this.note,
    required NotificationType type,
  })  : assert(
          type == NotificationType.transaction_pending || type == NotificationType.transaction_approved || type == NotificationType.transaction_rejected,
        ),
        super(type);

  factory TransactionMetadata.fromJson(Map<String, dynamic> json, NotificationType type) {
    return TransactionMetadata(
      transactionId: json['transactionId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      fromJarId: json['fromJarId'] ?? '',
      toJarId: json['toJarId'] ?? '',
      note: json['note'],
      type: type,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'amount': amount,
        'fromJarId': fromJarId,
        'toJarId': toJarId,
        if (note != null) 'note': note,
      };

  @override
  List<NotificationAction> get actions => type == NotificationType.transaction_pending
      ? [
          NotificationAction(id: 'approve', label: 'Approve', type: 'primary'),
          NotificationAction(id: 'decline', label: 'Decline', type: 'critical'),
        ]
      : [];
}

class BalanceMetadata extends NotificationMetadata {
  final String jarId;
  final String jarName;
  final double amount;
  final double newBalance;

  BalanceMetadata({
    required this.jarId,
    required this.jarName,
    required this.amount,
    required this.newBalance,
    required NotificationType type,
  })  : assert(
          type == NotificationType.balance_added || type == NotificationType.balance_removed,
        ),
        super(type);

  factory BalanceMetadata.fromJson(Map<String, dynamic> json, NotificationType type) {
    return BalanceMetadata(
      jarId: json['jarId'] ?? '',
      jarName: json['jarName'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      newBalance: (json['newBalance'] ?? 0.0).toDouble(),
      type: type,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'jarId': jarId,
        'jarName': jarName,
        'amount': amount,
        'newBalance': newBalance,
      };

  @override
  List<NotificationAction> get actions => [];
}

class WishlistMetadata extends NotificationMetadata {
  final String itemId;
  final String itemName;
  final double price;
  final String? imageUrl;

  WishlistMetadata({
    required this.itemId,
    required this.itemName,
    required this.price,
    this.imageUrl,
  }) : super(NotificationType.wishlist_added);

  factory WishlistMetadata.fromJson(Map<String, dynamic> json) {
    return WishlistMetadata(
      itemId: json['itemId'] ?? '',
      itemName: json['itemName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'itemName': itemName,
        'price': price,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

  @override
  List<NotificationAction> get actions => [
        NotificationAction(id: 'view', label: 'View Item', type: 'primary'),
      ];
}

class SystemNotificationMetadata extends NotificationMetadata {
  final String title;
  final String? actionType;
  final Map<String, dynamic>? additionalData;

  SystemNotificationMetadata({
    required this.title,
    this.actionType,
    this.additionalData,
  }) : super(NotificationType.system_notification);

  factory SystemNotificationMetadata.fromJson(Map<String, dynamic> json) {
    return SystemNotificationMetadata(
      title: json['title'] ?? '',
      actionType: json['actionType'],
      additionalData: json['additionalData'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        if (actionType != null) 'actionType': actionType,
        if (additionalData != null) 'additionalData': additionalData,
      };

  @override
  List<NotificationAction> get actions => [];
}

class GoalCompletedMetadata extends NotificationMetadata {
  final String goalId;
  final String goalName;
  final double targetAmount;
  final DateTime startDate;
  final DateTime completionDate;
  final String? imageUrl;
  final String? kidAvatarUrl;

  GoalCompletedMetadata({
    required this.goalId,
    required this.goalName,
    required this.targetAmount,
    required this.startDate,
    required this.completionDate,
    this.imageUrl,
    this.kidAvatarUrl,
  }) : super(NotificationType.goal_completed);

  factory GoalCompletedMetadata.fromJson(Map<String, dynamic> json) {
    return GoalCompletedMetadata(
      goalId: json['goalId'] ?? '',
      goalName: json['goalName'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      startDate: (json['startDate'] as Timestamp).toDate(),
      completionDate: (json['completionDate'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'],
      kidAvatarUrl: json['kidAvatarUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'goalId': goalId,
        'goalName': goalName,
        'targetAmount': targetAmount,
        'startDate': Timestamp.fromDate(startDate),
        'completionDate': Timestamp.fromDate(completionDate),
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (kidAvatarUrl != null) 'kidAvatarUrl': kidAvatarUrl,
      };

  @override
  List<NotificationAction> get actions => [
        NotificationAction(id: 'celebrate', label: 'Celebrate! 🎉', type: 'primary'),
      ];

  String get achievementDuration {
    final difference = completionDate.difference(startDate);
    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    }
  }
}

class TransactionPendingMetadata extends NotificationMetadata {
  final double amount;

  TransactionPendingMetadata({
    required this.amount,
  }) : super(NotificationType.goal_completed);

  factory TransactionPendingMetadata.fromJson(Map<String, dynamic> json) {
    return TransactionPendingMetadata(
      amount: json['amount'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'amount': amount,
      };

  @override
  List<NotificationAction> get actions => [
        NotificationAction(id: 'yes', label: 'Accept', type: 'primary'),
        NotificationAction(id: 'no', label: 'Decline', type: 'secondary'),
      ];
}
