import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/goal_model.dart';
import '../models/market_product_model.dart';

class GoalService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection = 'goals';
  final KidService _kidService = Get.find<KidService>();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createGoal(GoalModel goal) async {
    try {
      final photo = goal.photo;

      final DocumentReference docRef = await _firestore.collection(collection).add(goal.copyWith(photo: '').toJson());
      final String goalId = docRef.id;

      if (photo != null || photo!.isNotEmpty) {
        final String fileName = 'goals/$goalId.${photo.split('.').last}';
        final Reference ref = _storage.ref().child(fileName);

        final UploadTask uploadTask = ref.putFile(File(photo));
        final TaskSnapshot snapshot = await uploadTask;
        final goalPhoto = await snapshot.ref.getDownloadURL();

        final updatedGoal = goal.copyWith(
          id: goalId,
          photo: goalPhoto,
        );
        await _firestore.collection(collection).doc(goalId).update(updatedGoal.toJson());
      }
    } catch (e) {
      throw Exception('Failed to create kid: $e');
    }
  }

  // Create goal from product
  Future<String?> addToGoalsWithProduct(MarketProductModel product) async {
    try {
      // Get current user
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final appState = Get.find<AppStateController>();

      // Create goal from product
      final goal = GoalModel.fromProduct(appState.currentKid.value!.kidId, product);

      // Create the goal document
      final docRef = await _firestore.collection('goals').add(goal.toJson());

      print("Goal created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding product to goals: $e");
      return null;
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
      final QuerySnapshot snapshot = await _firestore.collection(collection).where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).get();

      return snapshot.docs.map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user goals: ${e.toString()}');
    }
  }

  // Update goal
  Future<void> updateGoal(GoalModel goal) async {
    try {
      await _firestore.collection(collection).doc(goal.id).update(goal.toJson());
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

      await updateGoal(updatedGoal);
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

      return snapshot.docs.map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)).toList();
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

      return snapshot.docs.map((doc) => GoalModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)).toList();
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

      await updateGoal(updatedGoal);
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
                  doc.data(),
                  id: doc.id,
                ))
            .toList());
  }
}
