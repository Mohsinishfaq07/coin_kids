import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/goal_model.dart';
import '../models/market_product_model.dart';
import 'package:get/get.dart';

class GoalService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection = 'goals';
  final KidService _kidService = Get.find<KidService>();

  // Change return type to Future<String> to return goalId directly
  Future<String> createGoal(GoalModel goal) async {
    try {
      // Get current kid data to validate spending balance
      final kid = await _kidService.fetchKidById(goal.userId);
      if (kid == null) {
        throw Exception('Kid not found');
      }

      final spendingBalance = kid.wallet.spendingJar.balance;
      if (spendingBalance < goal.targetAmount) {
        throw Exception('Insufficient funds in spending jar');
      }

      // Use a transaction to ensure both operations succeed or fail together
      final docRef = await _firestore
          .runTransaction<DocumentReference>((transaction) async {
        // Create the goal
        final goalRef = _firestore.collection(collection).doc();
        transaction.set(goalRef, goal.toJson());

        // Update kid's spending jar balance
        final newSpendingBalance = spendingBalance - goal.targetAmount;
        transaction.update(
          _firestore.collection('kids').doc(goal.userId),
          {
            'wallet.spendingJar.balance': newSpendingBalance,
          },
        );

        return goalRef;
      });

      return docRef.id; // Return the ID directly
    } catch (e) {
      throw Exception('Failed to create goal: ${e.toString()}');
    }
  }

  // Create goal from product
  // Future<String?> addToGoalsWithProduct(MarketProductModel product) async {
  //   try {
  //     // Get current user
  //     final user = _auth.currentUser;
  //     if (user == null) {
  //       throw Exception('User not authenticated');
  //     }

  //     // Get current kid
  //     final kids = await _kidService.fetchKidsByParentId(user.uid);
  //     if (kids.isEmpty) {
  //       throw Exception('No kid found');
  //     }
  //     final currentKid = kids.first;

  //     // Create goal from product
  //     final goal = GoalModel.fromProduct(product, currentKid.kidId);

  //     // Create the goal document
  //     final docRef = await _firestore.collection('goals').add(goal.toJson());

  //     print("Goal created successfully with ID: ${docRef.id}");
  //     return docRef.id;
  //   } catch (e) {
  //     print("Error adding product to goals: $e");
  //     return null;
  //   }
  // }

  // Fetch goal by ID
  Future<GoalModel?> fetchGoalById(String goalId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection(collection).doc(goalId).get();

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
          .map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>,
              id: doc.id))
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
        status:
            newAmount >= goal.targetAmount ? GoalStatus.completed : goal.status,
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
          .where('status',
              isEqualTo: GoalStatus.completed.toString().split('.').last)
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>,
              id: doc.id))
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
          .where('status',
              isEqualTo: GoalStatus.in_progress.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>,
              id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch in-progress goals: ${e.toString()}');
    }
  }

  // Fetch achievable goals
  Future<List<GoalModel>> fetchAchievableGoals(
      String userId, double balance) async {
    try {
      final goals = await fetchInProgressGoals(userId);
      return goals
          .where((goal) => goal.isAchievableWithBalance(balance))
          .toList();
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

  // Stream a single goal
  Stream<GoalModel?> streamGoal(String goalId) {
    return _firestore.collection(collection).doc(goalId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
    });
  }

  // Stream user goals
  Stream<List<GoalModel>> streamUserGoals(String userId) {
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        // .where('deleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GoalModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  id: doc.id,
                ))
            .toList());
  }

  // Add market product as goal
  Future<DocumentReference<Map<String, dynamic>>> addMarketProductAsGoal(
    MarketProductModel product,
  ) async {
    try {
      // Get current user
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get current kid
      final kids = await _kidService.fetchKidsByParentId(user.uid);
      if (kids.isEmpty) {
        throw Exception('No kid found');
      }
      final currentKid = kids.first;

      // Create goal from market product with transaction
      final docRef = await _firestore
          .runTransaction<DocumentReference<Map<String, dynamic>>>(
              (transaction) async {
        // Create goal document
        final goalRef = _firestore.collection('goals').doc();

        // Create goal with network image URL
        final goal = GoalModel(
          userId: currentKid.kidId,
          title: product.name,
          photo: product.imageUrl, // Use the network image URL directly
          targetAmount: product.price,
          savedAmount: 0,
          status: GoalStatus.in_progress,
          createdAt: DateTime.now(),
        );

        // Set goal data with additional product info
        transaction.set(goalRef, {
          ...goal.toJson(),
          'goalId': goalRef.id,
          'productId': product.id,
          'isMarketProduct': true, // Flag to identify market products
          'productUrl': product.url,
          'productRating': product.rating,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return goalRef;
      });

      print('Market product added as goal successfully: ${docRef.id}');
      return docRef;
    } catch (e) {
      print('Error adding market product as goal: $e');
      throw Exception('Failed to add product as goal: ${e.toString()}');
    }
  }
}
