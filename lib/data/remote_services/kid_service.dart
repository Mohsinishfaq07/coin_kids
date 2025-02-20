import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/kid_model.dart';

class KidService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch kid data by ID
  Future<KidModel?> fetchKidById(String kidId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('kids').doc(kidId).get();

      if (!doc.exists) {
        return null;
      }

      return KidModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch kid data: ${e.toString()}');
    }
  }

  // Fetch kids by parent ID
  Future<List<KidModel>> fetchKidsByParentId(String parentId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('kids')
          .where('parentId', isEqualTo: parentId)
          .get();

      return snapshot.docs
          .map((doc) => KidModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch kids: ${e.toString()}');
    }
  }

  // Create new kid
  Future<DocumentReference> createKid(KidModel kid) async {
    try {
      final docRef = await _firestore.collection('kids').add(kid.toJson());
      return docRef;
    } catch (e) {
      throw Exception('Failed to create kid: ${e.toString()}');
    }
  }

  // Update kid data
  Future<void> updateKid(String kidId, KidModel kid) async {
    try {
      await _firestore.collection('kids').doc(kidId).update(kid.toJson());
    } catch (e) {
      throw Exception('Failed to update kid: ${e.toString()}');
    }
  }

  // Delete kid
  Future<void> deleteKid(String kidId) async {
    try {
      await _firestore.collection('kids').doc(kidId).delete();
    } catch (e) {
      throw Exception('Failed to delete kid: ${e.toString()}');
    }
  }

  // Update saving jar balance
  Future<void> updateSavingJarBalance(String kidId, double newBalance) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'wallet.savingJar.balance': newBalance,
      });
    } catch (e) {
      throw Exception('Failed to update saving jar balance: ${e.toString()}');
    }
  }

  // Update spending jar balance
  Future<void> updateSpendingJarBalance(String kidId, double newBalance) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'wallet.spendingJar.balance': newBalance,
      });
    } catch (e) {
      throw Exception('Failed to update spending jar balance: ${e.toString()}');
    }
  }

  // Transfer money between jars
  Future<void> transferBetweenJars(
    String kidId,
    String fromJar,
    String toJar,
    double amount,
  ) async {
    try {
      // Get current kid data
      final kidDoc = await _firestore.collection('kids').doc(kidId).get();
      if (!kidDoc.exists) {
        throw Exception('Kid not found');
      }

      final kidData = kidDoc.data() as Map<String, dynamic>;
      final wallet = kidData['wallet'] as Map<String, dynamic>;

      // Get current balances
      final fromBalance = (wallet[fromJar]?['balance'] ?? 0.0) as double;
      final toBalance = (wallet[toJar]?['balance'] ?? 0.0) as double;

      // Validate transfer
      if (fromBalance < amount) {
        throw Exception('Insufficient funds in $fromJar');
      }

      // Update balances
      await _firestore.collection('kids').doc(kidId).update({
        'wallet.$fromJar.balance': fromBalance - amount,
        'wallet.$toJar.balance': toBalance + amount,
      });
    } catch (e) {
      throw Exception('Failed to transfer between jars: ${e.toString()}');
    }
  }

  // Update CoinKids balance
  Future<void> updateCoinKidsBalance(String kidId, double newBalance) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'coinKidsBalance': newBalance,
      });
    } catch (e) {
      throw Exception('Failed to update CoinKids balance: ${e.toString()}');
    }
  }

  // Update kid's avatar
  Future<void> updateAvatar(String kidId, String newAvatarUrl) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'avatar': newAvatarUrl,
      });
    } catch (e) {
      throw Exception('Failed to update avatar: ${e.toString()}');
    }
  }

  // Update kid's grade
  Future<void> updateGrade(String kidId, String newGrade) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'grade': newGrade,
      });
    } catch (e) {
      throw Exception('Failed to update grade: ${e.toString()}');
    }
  }
}
