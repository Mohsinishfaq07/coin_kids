import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/kid_model.dart';

class KidService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch kid data by ID
  Future<KidModel?> fetchKidById(String kidId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('kids').doc(kidId).get();

      if (!doc.exists) {
        return null;
      }

      return KidModel.fromJson(doc.data() as Map<String, dynamic>,
          documentId: kidId);
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

  // Single method to create kid
  Future<String> createKid({
    required String name,
    required int age,
    required String parentId,
    String? customImagePath,
    String? selectedAvatarUrl,
  }) async {
    try {
      String avatarUrl = selectedAvatarUrl ?? '';

      // Create initial wallet
      final wallet = Wallet(
        savingJar: WalletJar(balance: 0.0, color: '#000000'),
        spendingJar: WalletJar(balance: 0.0, color: '#000000'),
      );

      // Create kid model
      final KidModel kid = KidModel(
        name: name,
        age: age,
        avatar: avatarUrl,
        parentId: parentId,
        wallet: wallet,
        coinKidsBalance: 0.0,
        createdAt: DateTime.now(),
        kidId: '', // Will be updated after creation
      );

      // Create kid document and get ID
      final DocumentReference docRef =
          await _firestore.collection('kids').add(kid.toJson());
      final String kidId = docRef.id;

      // If custom image provided, upload it
      if (customImagePath != null && customImagePath.isNotEmpty) {
        final String fileName =
            'user_avatars/kids/$kidId.${customImagePath.split('.').last}';
        final Reference ref = _storage.ref().child(fileName);

        final UploadTask uploadTask = ref.putFile(File(customImagePath));
        final TaskSnapshot snapshot = await uploadTask;
        avatarUrl = await snapshot.ref.getDownloadURL();
      }

      // Update kid with its ID and final avatar URL
      final updatedKid = kid.copyWith(
        kidId: kidId,
        avatar: avatarUrl,
      );
      await _firestore
          .collection('kids')
          .doc(kidId)
          .update(updatedKid.toJson());

      return kidId;
    } catch (e) {
      throw Exception('Failed to create kid: $e');
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
  Future<void> updateSavingJarBalance(String kidId, double newBalance,
      {dynamic color}) async {
    try {
      // Get current kid data to validate
      final kidDoc = await _firestore.collection('kids').doc(kidId).get();
      if (!kidDoc.exists) {
        throw Exception('Kid not found');
      }

      final kidData = KidModel.fromJson(
        kidDoc.data() as Map<String, dynamic>,
        documentId: kidDoc.id,
      );

      // Calculate the difference to be transferred from spending
      final transferAmount = newBalance - kidData.wallet.savingJar.balance;

      // If it's a transfer from spending, validate spending balance
      if (transferAmount > 0) {
        final currentSpendingBalance = kidData.wallet.spendingJar.balance;
        if (currentSpendingBalance < transferAmount) {
          throw Exception('Insufficient funds in spending jar');
        }

        // Update both jars in a single transaction
        await _firestore.runTransaction((transaction) async {
          transaction.update(
            _firestore.collection('kids').doc(kidId),
            {
              'wallet.savingJar.balance': newBalance,
              'wallet.spendingJar.balance':
                  currentSpendingBalance - transferAmount,
              if (color != null) 'wallet.savingJar.color': color,
            },
          );
        });
      } else {
        // If it's not a transfer (direct update), just update saving jar
        final Map<String, dynamic> updateData = {
          'wallet.savingJar.balance': newBalance,
        };

        if (color != null) {
          updateData['wallet.savingJar.color'] = color;
        }

        await _firestore.collection('kids').doc(kidId).update(updateData);
      }
    } catch (e) {
      throw Exception('Failed to update saving jar balance: ${e.toString()}');
    }
  }

  // Update spending jar balance
  Future<void> updateSpendingJarBalance(String kidId, double newBalance,
      {dynamic color}) async {
    try {
      final Map<String, dynamic> updateData = {
        'wallet.spendingJar.balance': newBalance,
      };

      if (color != null) {
        updateData['wallet.spendingJar.color'] = color;
      }

      await _firestore.collection('kids').doc(kidId).update(updateData);
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

  // Fetch all predefined avatars from Firebase Storage
  Future<List<String>> fetchPredefinedAvatars() async {
    try {
      final ListResult result = await _storage.ref('avatars').listAll();
      final List<String> urls = await Future.wait(
        result.items.map((ref) => ref.getDownloadURL()),
      );
      return urls;
    } catch (e) {
      throw Exception('Failed to fetch avatars: $e');
    }
  }

  // Upload custom avatar image and get URL
  Future<String> uploadCustomAvatar(File imageFile) async {
    try {
      final String fileName =
          'user_avatars/${DateTime.now().millisecondsSinceEpoch}${imageFile.path.split('.').last}';
      final Reference ref = _storage.ref().child(fileName);

      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  // Stream to count number of kids for a parent
  Stream<int> streamKidsCount(String parentId) {
    return _firestore
        .collection('kids')
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream to check if parent has any kids
  Stream<bool> streamHasKids(String parentId) {
    return _firestore
        .collection('kids')
        .where('parentId', isEqualTo: parentId)
        .limit(1) // More efficient than fetching all docs
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // Stream single kid by parent ID
  Stream<KidModel?> streamKidByParentId(String parentId) {
    return _firestore
        .collection('kids')
        .where('parentId', isEqualTo: parentId)
        .limit(1) // Ensure we only get one kid
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      final doc = snapshot.docs.first;
      return KidModel.fromJson(
        doc.data(),
        documentId: doc.id,
      );
    });
  }

  Stream<List<KidModel>> streamKids(String parentId) {
    try {
      return _firestore
          .collection('kids')
          .where('parentId', isEqualTo: parentId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return KidModel.fromJson(
            doc.data(),
            documentId: doc.id,
          );
        }).toList();
      });
    } catch (e) {
      print("Error streaming kids: $e");
      return Stream.value([]);
    }
  }

  // Transfer from spending to saving jar
  Future<void> transferFromSpendingToSaving(String kidId, double amount) async {
    try {
      // Get current kid data
      final kidDoc = await _firestore.collection('kids').doc(kidId).get();
      if (!kidDoc.exists) {
        throw Exception('Kid not found');
      }

      final kidData = KidModel.fromJson(
        kidDoc.data() as Map<String, dynamic>,
        documentId: kidDoc.id,
      );

      // Validate spending jar has enough balance
      if (kidData.wallet.spendingJar.balance < amount) {
        throw Exception('Insufficient funds in spending jar');
      }

      // Calculate new balances
      final newSpendingBalance = kidData.wallet.spendingJar.balance - amount;
      final newSavingBalance = kidData.wallet.savingJar.balance + amount;

      // Update both jars in a single transaction
      await _firestore.runTransaction((transaction) async {
        transaction.update(
          _firestore.collection('kids').doc(kidId),
          {
            'wallet.spendingJar.balance': newSpendingBalance,
            'wallet.savingJar.balance': newSavingBalance,
          },
        );
      });
    } catch (e) {
      throw Exception('Failed to transfer to savings: ${e.toString()}');
    }
  }

  // Transfer from saving to spending jar
  Future<void> transferFromSavingToSpending(String kidId, double amount) async {
    try {
      // Get current kid data
      final kidDoc = await _firestore.collection('kids').doc(kidId).get();
      if (!kidDoc.exists) {
        throw Exception('Kid not found');
      }

      final kidData = KidModel.fromJson(
        kidDoc.data() as Map<String, dynamic>,
        documentId: kidDoc.id,
      );

      // Validate saving jar has enough balance
      if (kidData.wallet.savingJar.balance < amount) {
        throw Exception('Insufficient funds in saving jar');
      }

      // Calculate new balances
      final newSavingBalance = kidData.wallet.savingJar.balance - amount;
      final newSpendingBalance = kidData.wallet.spendingJar.balance + amount;

      // Update both jars in a single transaction
      await _firestore.runTransaction((transaction) async {
        transaction.update(
          _firestore.collection('kids').doc(kidId),
          {
            'wallet.savingJar.balance': newSavingBalance,
            'wallet.spendingJar.balance': newSpendingBalance,
          },
        );
      });
    } catch (e) {
      throw Exception('Failed to transfer to spending: ${e.toString()}');
    }
  }
}
