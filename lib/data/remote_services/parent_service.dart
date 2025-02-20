import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/presentation/screens/common/authentication/parent_signup/parent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch parent data
  Future<ParentModel?> fetchParentData() async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      final DocumentSnapshot doc =
          await _firestore.collection('parents').doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return ParentModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch parent data: ${e.toString()}');
    }
  }

  // Create new parent
  Future<void> createParent(ParentModel parent) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('parents').doc(userId).set(parent.toJson());
    } catch (e) {
      throw Exception('Failed to create parent: ${e.toString()}');
    }
  }

  // Update parent data
  Future<void> updateParent(ParentModel parent) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('parents')
          .doc(userId)
          .update(parent.toJson());
    } catch (e) {
      throw Exception('Failed to update parent: ${e.toString()}');
    }
  }

  // Update parent PIN
  Future<void> updatePin(int newPin) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('parents')
          .doc(userId)
          .update({'pin': newPin});
    } catch (e) {
      throw Exception('Failed to update PIN: ${e.toString()}');
    }
  }

  // Verify parent PIN
  Future<bool> verifyPin(int pin) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      final DocumentSnapshot doc =
          await _firestore.collection('parents').doc(userId).get();
      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>;
      return data['pin'] == pin;
    } catch (e) {
      throw Exception('Failed to verify PIN: ${e.toString()}');
    }
  }

}
