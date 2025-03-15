import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';
import './kid_service.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final KidService _kidService = KidService();

  // Create new transaction
  Future<DocumentReference> createTransaction(TransactionModel transaction) async {
    try {
      final docRef = await _firestore.collection('transactions').add(transaction.toJson());

      // If it's an earn or reward transaction, update kid's balance
      if ((transaction.type == TransactionType.earn || transaction.type == TransactionType.reward) && transaction.status == TransactionStatus.approved) {
        await _kidService.updateCoinKidsBalance(transaction.userId, (await _kidService.fetchKidById(transaction.userId))!.coinKidsBalance + transaction.amount);
      }

      return docRef;
    } catch (e) {
      throw Exception('Failed to create transaction: ${e.toString()}');
    }
  }

  // Fetch transaction by ID
  Future<TransactionModel?> fetchTransactionById(String transactionId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('transactions').doc(transactionId).get();

      if (!doc.exists) {
        return null;
      }

      return TransactionModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
    } catch (e) {
      throw Exception('Failed to fetch transaction: ${e.toString()}');
    }
  }

  // Fetch transactions by user ID (kid's transactions)
  Future<List<TransactionModel>> fetchTransactionsByUserId(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('transactions').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).get();

      return snapshot.docs.map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user transactions: ${e.toString()}');
    }
  }

  // Fetch transactions by parent ID
  Future<List<TransactionModel>> fetchTransactionsByParentId(String parentId) async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('transactions').where('parentId', isEqualTo: parentId).orderBy('createdAt', descending: true).get();

      return snapshot.docs.map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch parent transactions: ${e.toString()}');
    }
  }

  // Update transaction status
  Future<void> updateTransactionStatus(String transactionId, TransactionStatus newStatus) async {
    try {
      final transaction = await fetchTransactionById(transactionId);
      if (transaction == null) {
        throw Exception('Transaction not found');
      }

      await _firestore.collection('transactions').doc(transactionId).update({'status': newStatus.toString().split('.').last});

      // If status is changed to approved and it's an earn/reward transaction, update kid's balance
      if (newStatus == TransactionStatus.approved && (transaction.type == TransactionType.earn || transaction.type == TransactionType.reward)) {
        final kid = await _kidService.fetchKidById(transaction.userId);
        if (kid != null) {
          await _kidService.updateCoinKidsBalance(transaction.userId, kid.coinKidsBalance + transaction.amount);
        }
      }
    } catch (e) {
      throw Exception('Failed to update transaction status: ${e.toString()}');
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: ${e.toString()}');
    }
  }

  // Fetch pending transactions for parent
  Future<List<TransactionModel>> fetchPendingTransactions(String parentId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('parentId', isEqualTo: parentId)
          .where('status', isEqualTo: TransactionStatus.pending.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch pending transactions: ${e.toString()}');
    }
  }

  // Fetch transactions by date range
  Future<List<TransactionModel>> fetchTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions by date range: ${e.toString()}');
    }
  }
}
