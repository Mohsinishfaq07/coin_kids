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

  // Future<void> deleteGoal(String goalId) async {
  //   try {
  //     await _firestore
  //         .collection('goals')
  //         .doc(goalId)
  //         .update({'deleted': true});
  //   } catch (e) {
  //     throw Exception('Failed to delete goal: ${e.toString()}');
  //   }
  // }

  Future<void> addToGoals(ProductModel product) async {
    try {
      final String parentId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';
      if (parentId.isEmpty) {
        throw Exception('User not authenticated');
      }
      Get.log('Adding new goal for kid with parent ID: $parentId');
      QuerySnapshot kidSnapshot = await _firestore
          .collection('kids')
          .where('parentId', isEqualTo: parentId) // Match parentId
          .get();
      if (kidSnapshot.docs.isEmpty) {
        // Handle error if no kid document is found for the given parentId
        throw Exception("No kid document found for this parent ID");
      }

      DocumentSnapshot kidDoc = kidSnapshot.docs.first;
      DocumentReference kidRef = kidDoc.reference;

      final goalRef = _firestore.collection('goals').doc();
      final goalModel = GoalModel.fromProduct(kidRef.id, product, goalRef.id);

      await goalRef.set(goalModel.toJson());
    } catch (e) {
      throw Exception('Failed to add to goals: ${e.toString()}');
    }
  }
}
