import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { earn, spend, transfer, reward }

enum TransactionStatus { pending, approved, rejected, completed }

class TransactionModel {
  final String? id; // Optional for new transactions
  final String userId;
  final String parentId;
  final double amount;
  final TransactionType type;
  final String description;
  final TransactionStatus status;
  final DateTime createdAt;

  TransactionModel({
    this.id,
    required this.userId,
    required this.parentId,
    required this.amount,
    required this.type,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return TransactionModel(
      id: id,
      userId: json['userId'] ?? '',
      parentId: json['parentId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: _stringToTransactionType(json['type'] ?? ''),
      description: json['description'] ?? '',
      status: _stringToTransactionStatus(json['status'] ?? ''),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'parentId': parentId,
      'amount': amount,
      'type': type.toString().split('.').last,
      'description': description,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? parentId,
    double? amount,
    TransactionType? type,
    String? description,
    TransactionStatus? status,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper method to convert string to TransactionType
  static TransactionType _stringToTransactionType(String type) {
    switch (type.toLowerCase()) {
      case 'earn':
        return TransactionType.earn;
      case 'spend':
        return TransactionType.spend;
      case 'transfer':
        return TransactionType.transfer;
      case 'reward':
        return TransactionType.reward;
      default:
        return TransactionType.earn; // Default value
    }
  }

  // Helper method to convert string to TransactionStatus
  static TransactionStatus _stringToTransactionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'approved':
        return TransactionStatus.approved;
      case 'rejected':
        return TransactionStatus.rejected;
      case 'completed':
        return TransactionStatus.completed;
      default:
        return TransactionStatus.pending; // Default value
    }
  }
}
