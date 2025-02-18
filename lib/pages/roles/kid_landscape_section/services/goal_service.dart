import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/models/goal_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../kid_market/product_model.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<GoalModel>> fetchGoals(String kidId) async {
    try {
      final snapshot = await _firestore
          .collection('goals')
          .where('kidId', isEqualTo: kidId)
          .where('deleted', isEqualTo: false)
          .get();

      return snapshot.docs
          .map((doc) => GoalModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch goals: ${e.toString()}');
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    try {
      await _firestore
          .collection('goals')
          .doc(goal.goalId)
          .update(goal.toJson());
    } catch (e) {
      throw Exception('Failed to update goal: ${e.toString()}');
    }
  }

  // Future<void> addToGoals(ProductModel product) async {
  //   try {
  //     final String parentId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';
  //     if (parentId.isEmpty) {
  //       throw Exception('User not authenticated');
  //     }
  //     Get.log('Adding new goal for kid with parent ID: $parentId');
  //     QuerySnapshot kidSnapshot = await _firestore
  //         .collection('kids')
  //         .where('parentId', isEqualTo: parentId) // Match parentId
  //         .get();
  //     if (kidSnapshot.docs.isEmpty) {
  //       // Handle error if no kid document is found for the given parentId
  //       throw Exception("No kid document found for this parent ID");
  //     }

  //     DocumentSnapshot kidDoc = kidSnapshot.docs.first;
  //     DocumentReference kidRef = kidDoc.reference;

  //     final goalRef = _firestore.collection('goals').doc();
  //     final goalModel = GoalModel.fromProduct(kidRef.id, product, goalRef.id);
  //      final Map<String, dynamic> kidData = {
  //       'goals': FieldValue.arrayUnion(
  //           [goalRef]), // Add goal reference to goalsReference field
  //     };
  //       await _firestore.runTransaction((transaction) async {
  //       try {
  //         // Log the data you are passing to Firestore
  //         Get.log('Setting goal data: $goalData');

  //         // Set goal data
  //         transaction.set(goalRef, goalData);

  //         // Update kid document
  //         transaction.update(kidRef, kidData);

  //         // final String localPath =
  //         //     await saveImageLocally(File(goalImage.value), goalRef.id);
  //         // goalImage.value = localPath;
  //         await saveImageToPrefs(goalRef.id, File(goalImage.value));
  //         await saveGoalIdToPrefs(goalRef.id);
  //       } catch (e) {
  //         Get.log('Error in Firestore transaction: $e');
  //         rethrow; // Re-throw exception to be caught outside
  //       }
  //     }).timeout(const Duration(seconds: 20), onTimeout: () {
  //       throw TimeoutException("Firestore transaction timed out");
  //     });

  //     await goalRef.set(goalModel.toJson());
  //   } catch (e) {
  //     throw Exception('Failed to add to goals: ${e.toString()}');
  //   }
  // }
  Future<void> addToGoalsWithModel(ProductModel product) async {
    try {
      final String parentId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';
      if (parentId.isEmpty) {
        throw Exception('User not authenticated');
      }

      Get.log('Adding new goal for kid with parent ID: $parentId');

      // Fetch kid document linked to the parentId
      QuerySnapshot kidSnapshot = await _firestore
          .collection('kids')
          .where('parentId', isEqualTo: parentId)
          .get();

      if (kidSnapshot.docs.isEmpty) {
        throw Exception("No kid document found for this parent ID");
      }

      DocumentSnapshot kidDoc = kidSnapshot.docs.first;
      DocumentReference kidRef = kidDoc.reference;

      // Create a new goal reference
      final DocumentReference goalRef = _firestore.collection('goals').doc();
      final GoalModel goalModel =
          GoalModel.fromProduct(kidRef.id, product, goalRef.id);

      await _firestore.runTransaction((transaction) async {
        try {
          // Add goal reference to the kid's `goals` array
          transaction.update(kidRef, {
            'goals': FieldValue.arrayUnion([goalRef])
          });

          // Save goal data inside the transaction
          transaction.set(goalRef, goalModel.toJson());

          // Log data for debugging
          Get.log('Goal successfully added: ${goalModel.toJson()}');
        } catch (e) {
          Get.log('Error in Firestore transaction: $e');
          rethrow;
        }
      }).timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException("Firestore transaction timed out");
      });

      // **Save Image Locally (Ensure goalImage is valid)**
      // if (goalImage.value.isNotEmpty) {
      //   final File imageFile = File(goalImage.value);
      //   await saveImageToPrefs(goalRef.id, imageFile);
      // } else {
      //   Get.log("Goal image is empty, skipping saveImageToPrefs.");
      // }

      // // Save goal ID to preferences
      // await saveGoalIdToPrefs(goalRef.id);
    } catch (e) {
      throw Exception('Failed to add to goals: ${e.toString()}');
    }
  }
}
