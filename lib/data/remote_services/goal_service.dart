import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/goal_model.dart';
import '../models/market_product_model.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection = 'goals';

  // Create new goal
  Future<DocumentReference> createGoal(GoalModel goal) async {
    try {
      final docRef = await _firestore.collection(collection).add(goal.toJson());
      return docRef;
    } catch (e) {
      throw Exception('Failed to create goal: ${e.toString()}');
    }
  }

  // Create goal from product
  Future<DocumentReference> addToGoalsWithProduct(MarketProductModel product) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) throw Exception('User not authenticated');

      final goal = GoalModel(
        userId: userId,
        title: product.name,
        photo: product.imageUrl,
        targetAmount: product.price,
        savedAmount: 0,
        status: GoalStatus.in_progress,
        createdAt: DateTime.now(),
      );

      return await createGoal(goal);
    } catch (e) {
      throw Exception('Failed to add product to goals: ${e.toString()}');
    }
  }

  // Fetch goal by ID
  Future<GoalModel?> fetchGoalById(String goalId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(collection).doc(goalId).get();
      
      if (!doc.exists) {
        return null;
      }

      return GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
    } catch (e) {
      throw Exception('Failed to fetch goal: ${e.toString()}');
    }
  }

  // Fetch all goals for a user
  Future<List<GoalModel>> fetchUserGoals(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user goals: ${e.toString()}');
    }
  }

  // Update goal
  Future<void> updateGoal(String goalId, GoalModel goal) async {
    try {
      await _firestore.collection(collection).doc(goalId).update(goal.toJson());
    } catch (e) {
      throw Exception('Failed to update goal: ${e.toString()}');
    }
  }

  // Update goal saved amount
  Future<void> updateSavedAmount(String goalId, double newAmount) async {
    try {
      final goal = await fetchGoalById(goalId);
      if (goal == null) throw Exception('Goal not found');

      final updatedGoal = goal.copyWith(
        savedAmount: newAmount,
        status: newAmount >= goal.targetAmount ? GoalStatus.completed : goal.status,
        completedAt: newAmount >= goal.targetAmount ? DateTime.now() : null,
      );

      await updateGoal(goalId, updatedGoal);
    } catch (e) {
      throw Exception('Failed to update saved amount: ${e.toString()}');
    }
  }

  // Delete goal
  Future<void> deleteGoal(String goalId) async {
    try {
      await _firestore.collection(collection).doc(goalId).delete();
    } catch (e) {
      throw Exception('Failed to delete goal: ${e.toString()}');
    }
  }

  // Fetch completed goals
  Future<List<GoalModel>> fetchCompletedGoals(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: GoalStatus.completed.toString().split('.').last)
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch completed goals: ${e.toString()}');
    }
  }

  // Fetch in-progress goals
  Future<List<GoalModel>> fetchInProgressGoals(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: GoalStatus.in_progress.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch in-progress goals: ${e.toString()}');
    }
  }

  // Fetch achievable goals
  Future<List<GoalModel>> fetchAchievableGoals(String userId, double balance) async {
    try {
      final goals = await fetchInProgressGoals(userId);
      return goals.where((goal) => goal.isAchievableWithBalance(balance)).toList();
    } catch (e) {
      throw Exception('Failed to fetch achievable goals: ${e.toString()}');
    }
  }

  // Cancel goal
  Future<void> cancelGoal(String goalId) async {
    try {
      final goal = await fetchGoalById(goalId);
      if (goal == null) throw Exception('Goal not found');

      final updatedGoal = goal.copyWith(
        status: GoalStatus.cancelled,
      );

      await updateGoal(goalId, updatedGoal);
    } catch (e) {
      throw Exception('Failed to cancel goal: ${e.toString()}');
    }
  }
}
