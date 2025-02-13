import '../kid_market/product_model.dart';

class GoalModel {
  final String goalId;
  final double amount;
  final bool completed;
  final double currentAmount;
  final bool deleted;
  final String image;
  final String kidId;
  final String name;
  final double progress;

  GoalModel({
    required this.goalId,
    required this.amount,
    required this.completed,
    required this.currentAmount,
    required this.deleted,
    required this.image,
    required this.kidId,
    required this.name,
    required this.progress,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      goalId: json['goalId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      completed: json['completed'] ?? false,
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      deleted: json['deleted'] ?? false,
      image: json['image'] ?? '',
      kidId: json['kidId'] ?? '',
      name: json['name'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goalId': goalId,
      'amount': amount,
      'completed': completed,
      'currentAmount': currentAmount,
      'deleted': deleted,
      'image': image,
      'kidId': kidId,
      'name': name,
      'progress': progress,
    };
  }

  // Create a new goal from a product
  factory GoalModel.fromProduct(
      String kidId, ProductModel product, String goalId) {
    return GoalModel(
      goalId: goalId,
      amount: product.price,
      completed: false,
      currentAmount: 0,
      deleted: false,
      image: product.imageUrl,
      kidId: kidId,
      name: product.name,
      progress: 0,
    );
  }
}
