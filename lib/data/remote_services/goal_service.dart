import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/remote_services/base_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/goal_model.dart';
import '../models/market_product_model.dart';
import '../models/notification_model.dart';

class GoalService extends BaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection = 'goals';
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createGoal(GoalModel goal, bool isFirstGoal) async {
    return withTimeout(
      () async {
        await _firestore.runTransaction((transaction) async {
          // STEP 1: PERFORM ALL READS FIRST
          String? goalPhotoUrl;
          DocumentSnapshot? kidDoc;

          if (isFirstGoal) {
            kidDoc = await transaction
                .get(_firestore.collection('kids').doc(goal.userId));
            if (!kidDoc.exists) {
              throw Exception('Kid not found');
            }
          }

          // STEP 2: If there's a photo, upload it to Storage (this is not part of the transaction)
          if (goal.photo != null && goal.photo!.isNotEmpty) {
            final goalRef = _firestore.collection(collection).doc();
            final String goalId = goalRef.id;
            final String fileName =
                'goals/$goalId.${goal.photo!.split('.').last}';
            final Reference ref = _storage.ref().child(fileName);

            final UploadTask uploadTask = ref.putFile(File(goal.photo!));
            final TaskSnapshot snapshot = await uploadTask;
            goalPhotoUrl = await snapshot.ref.getDownloadURL();
          }

          // STEP 3: PERFORM ALL WRITES
          final goalRef = _firestore.collection(collection).doc();
          final String goalId = goalRef.id;

          final goalToCreate = goal.copyWith(
            id: goalId,
            photo: goalPhotoUrl ?? '',
          );

          transaction.set(goalRef, goalToCreate.toJson());

          // Update CoinKids balance if this is the first goal
          if (isFirstGoal && kidDoc != null) {
            transaction.update(kidDoc.reference, {'coinKidsBalance': 2});
          }
        });
      },
      customMessage: 'Unable to create goal. Please check your connection.',
    );
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
      final goal =
          GoalModel.fromProduct(appState.currentKid.value!.kidId, product);

      // Create the goal document
      final docRef = await _firestore.collection('goals').add(goal.toJson());

      Get.log("Goal created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      Get.log("Error adding product to goals: $e");
      return null;
    }
  }

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
  Future<void> updateGoal(GoalModel goal) async {
    try {
      await _firestore
          .collection(collection)
          .doc(goal.id)
          .update(goal.toJson());
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
              isEqualTo: GoalStatus.inProgress.toString().split('.').last)
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
  Future<void> cancelGoal(GoalModel goal) async {
    try {
      final updatedGoal = goal.copyWith(status: GoalStatus.rejected);
      await updateGoal(updatedGoal);
    } catch (e) {
      throw Exception('Failed to cancel goal: ${e.toString()}');
    }
  }

  // Approve goal
  Future<void> approveGoal(GoalModel goal) async {
    try {
      final updatedGoal = goal.copyWith(
        status: GoalStatus.approved,
        completedAt: DateTime.now(),
      );
      await updateGoal(updatedGoal);
    } catch (e) {
      throw Exception('Failed to approve goal: ${e.toString()}');
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
    final stream = _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GoalModel.fromJson(doc.data(), id: doc.id))
            .toList());

    return stream;
  }

  Future<void> updateGoalProgressWithRewards(
      String goalId, double newAmount) async {
    try {
      // Use a Firestore transaction to ensure all operations succeed or fail together
      await _firestore.runTransaction((transaction) async {
        // STEP 1: PERFORM ALL READS FIRST

        // Read the goal document
        final goalDoc = await transaction
            .get(_firestore.collection(collection).doc(goalId));
        if (!goalDoc.exists) {
          throw Exception('Goal not found');
        }

        final goal = GoalModel.fromJson(goalDoc.data()!, id: goalId);
        final oldAmount = goal.savedAmount;
        final targetAmount = goal.targetAmount;

        // Calculate percentages for milestone detection
        final oldPercentage = (oldAmount / targetAmount) * 100;
        final newPercentage = (newAmount / targetAmount) * 100;

        // Determine if any milestones were reached
        int coinKidsToAward = 0;
        String? notificationTitle;
        String? notificationBody;
        double? milestonePercentage;
        NotificationType? notificationType;

       /* // Check for milestone achievements (25%, 50%, 75%, 100%)
        if (oldPercentage < 25 && newPercentage >= 25) {
          coinKidsToAward = 1;
          notificationTitle = "25% Milestone Reached!";
          notificationBody = "You've reached 25% of your goal: ${goal.title}";
          milestonePercentage = 25.0;
          notificationType = NotificationType.goalMilestone;
        } else if (oldPercentage < 50 && newPercentage >= 50) {
          coinKidsToAward = 2;
          notificationTitle = "50% Milestone Reached!";
          notificationBody = "You've reached 50% of your goal: ${goal.title}";
          milestonePercentage = 50.0;
          notificationType = NotificationType.goalMilestone;
        } else if (oldPercentage < 75 && newPercentage >= 75) {
          coinKidsToAward = 3;
          notificationTitle = "75% Milestone Reached!";
          notificationBody = "You've reached 75% of your goal: ${goal.title}";
          milestonePercentage = 75.0;
          notificationType = NotificationType.goalMilestone;
        } else*/
        if (newPercentage == 100) {
          coinKidsToAward = 5;
          notificationTitle = "Goal Achieved!";
          notificationBody =
              "Congratulations! You've completed your goal: ${goal.title}";
          milestonePercentage = 100.0;
          notificationType = NotificationType.goalCompleted;
        }

        // Read kid document if needed
        DocumentSnapshot? kidDoc;
        if (coinKidsToAward > 0) {
          kidDoc = await transaction
              .get(_firestore.collection('kids').doc(goal.userId));
          if (!kidDoc.exists) {
            Get.log("Kid document not found for userId: ${goal.userId}");
            throw Exception('Kid not found for userId: ${goal.userId}');
          }
        }

        // Only proceed with kid-related operations if we have a valid kidDoc
        if (kidDoc != null) {
          final kidData = kidDoc.data() as Map<String, dynamic>?;
          if (kidData == null) {
            Get.log("Kid data is null for userId: ${goal.userId}");
            throw Exception('Kid data is null for userId: ${goal.userId}');
          }

          final kid = KidModel.fromJson(kidData);

          // STEP 2: PERFORM ALL WRITES

          // Update the goal with new amount
          final updatedGoal = goal.copyWith(
            savedAmount: newAmount,
            status:
                newAmount >= targetAmount ? GoalStatus.completed : goal.status,
            completedAt: newAmount >= targetAmount ? DateTime.now() : null,
          );

          transaction.update(_firestore.collection(collection).doc(goalId),
              updatedGoal.toJson());

          // If a milestone was reached, update CoinKids balance and create notification
          // if (coinKidsToAward > 0) {
          if (coinKidsToAward >= 0) {
            // Update CoinKids balance
            final currentCoinKids = kid.coinKidsBalance;
            final newCoinKids = currentCoinKids + coinKidsToAward;

            transaction.update(_firestore.collection('kids').doc(goal.userId),
                {'coinKidsBalance': newCoinKids});

            // Create notification
            if (notificationTitle != null &&
                notificationBody != null &&
                milestonePercentage != null &&
                notificationType != null) {
              final metadata =
              // milestonePercentage == 100.0 ?
              GoalCompletedMetadata(
                      goalId: goalId,
                      goalName: goal.title,
                      targetAmount: goal.targetAmount,
                      name: kid.name,
                      photo: kid.avatar,
                    );
                  // :GoalMilestoneMetadata(
                  //     goalId: goalId,
                  //     goalName: goal.title,
                  //     targetAmount: goal.targetAmount,
                  //     currentAmount: newAmount,
                  //     name: kid.name,
                  //     photo: kid.avatar,
                  //   );

              final notificationData = NotificationModel(
                userId: kid.parentId,
                senderId: kid.kidId,
                title: notificationTitle,
                type: notificationType,
                isRead: false,
                timestamp: DateTime.now(),
                metadata: metadata,
              );

              final notificationRef =
                  _firestore.collection('notifications').doc();
              transaction.set(notificationRef, notificationData.toJson());
            }
          }
        } else {
          // If no kidDoc is needed (no rewards), just update the goal
          final updatedGoal = goal.copyWith(
            savedAmount: newAmount,
            status:
                newAmount >= targetAmount ? GoalStatus.completed : goal.status,
            completedAt: newAmount >= targetAmount ? DateTime.now() : null,
          );

          transaction.update(_firestore.collection(collection).doc(goalId),
              updatedGoal.toJson());
        }
      });

      Get.log(
          "Goal progress updated successfully with rewards and notifications");
    } catch (e) {
      Get.log("Error updating goal progress with rewards: $e");
      throw Exception('Failed to update goal progress: $e');
    }
  }
}
