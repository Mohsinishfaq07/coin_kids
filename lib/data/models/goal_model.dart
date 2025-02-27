import 'package:cloud_firestore/cloud_firestore.dart';

import 'market_product_model.dart';

enum GoalStatus { in_progress, completed, cancelled, pending, deleted }

class GoalModel {
  final String? id;
  final String userId;
  final String title;
  final String? photo;
  final double targetAmount;
  final double savedAmount;
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  GoalModel({
    this.id,
    required this.userId,
    required this.title,
    required this.photo,
    required this.targetAmount,
    required this.savedAmount,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return GoalModel(
      id: id,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      photo: json['photo'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      savedAmount: (json['savedAmount'] ?? 0.0).toDouble(),
      status: _stringToGoalStatus(json['status'] ?? ''),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'photo': photo,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
    };
  }

  GoalModel copyWith({
    String? id,
    String? userId,
    String? title,
    double? targetAmount,
    double? savedAmount,
    GoalStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      photo: photo ?? this.photo,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Helper method to convert string to GoalStatus
  static GoalStatus _stringToGoalStatus(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return GoalStatus.in_progress;
      case 'completed':
        return GoalStatus.completed;
      case 'cancelled':
        return GoalStatus.cancelled;
      default:
        return GoalStatus.in_progress;
    }
  }

  // Calculate progress percentage
  double get progressPercentage =>
      (savedAmount / targetAmount * 100).clamp(0, 100);

  // Check if goal is achievable with current balance
  bool isAchievableWithBalance(double balance) {
    return (targetAmount - savedAmount) <= balance;
  }

  // Get remaining amount needed
  double get remainingAmount => targetAmount - savedAmount;

  // Format amounts with currency symbol
  String get formattedTargetAmount => '\$${targetAmount.toStringAsFixed(2)}';

  String get formattedSavedAmount => '\$${savedAmount.toStringAsFixed(2)}';

  String get formattedRemainingAmount =>
      '\$${remainingAmount.toStringAsFixed(2)}';

  // Create a new goal from a product
  factory GoalModel.fromProduct(
      String kidId, MarketProductModel product, String goalId) {
    return GoalModel(
      id: goalId,
      userId: kidId,
      title: product.name,
      photo: product.imageUrl,
      targetAmount: product.price,
      savedAmount: 0,
      status: GoalStatus.in_progress,
      createdAt: DateTime.now(),
      completedAt: null,
    );
  }
}
