import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:payroute_desktop/models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'transactions';

  List<TransactionModel> _getDemoTransactions() {
    return [
      TransactionModel(
        id: 'txn-demo-1',
        userId: 'demo-1234',
        recipientName: 'Alice Smith',
        recipientId: 'user-001',
        type: TransactionType.send,
        status: TransactionStatus.completed,
        amount: 250000.0,
        currency: 'NGN',
        sourceRail: 'ACH',
        destinationRail: 'SEPA',
        feeSaved: 1200.0,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      TransactionModel(
        id: 'txn-demo-2',
        userId: 'demo-1234',
        recipientName: 'Bob Johnson',
        recipientId: 'user-002',
        type: TransactionType.receive,
        status: TransactionStatus.completed,
        amount: 50000.0,
        currency: 'NGN',
        sourceRail: 'SWIFT',
        destinationRail: 'ACH',
        feeSaved: 300.0,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        id: 'txn-demo-3',
        userId: 'demo-1234',
        recipientName: 'Charlie Davis',
        recipientId: 'user-003',
        type: TransactionType.exchange,
        status: TransactionStatus.pending,
        amount: 15000.0,
        currency: 'USD',
        sourceRail: 'Card',
        destinationRail: 'Wallet',
        feeSaved: 0.0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<List<TransactionModel>> getTransactionsByUserId(String userId, {int limit = 50}) async {
    if (userId == 'demo-1234') {
      return _getDemoTransactions();
    }
    try {
      final query = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('TransactionService.getTransactionsByUserId error: $e');
      return [];
    }
  }

  Future<List<TransactionModel>> getAllTransactions({int limit = 50}) async {
    try {
      final query = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('TransactionService.getAllTransactions error: $e');
      return [];
    }
  }

  Stream<List<TransactionModel>> watchTransactionsByUserId(String userId, {int limit = 50}) {
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return TransactionModel.fromJson(data);
            }).toList());
  }

  Stream<List<TransactionModel>> watchAllTransactions({int limit = 50}) {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return TransactionModel.fromJson(data);
            }).toList());
  }

  Future<TransactionModel?> getTransactionById(String transactionId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(transactionId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('TransactionService.getTransactionById error: $e');
      return null;
    }
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      final docRef = _firestore.collection(_collectionName).doc();
      final data = transaction.copyWith(id: docRef.id).toJson();
      await docRef.set(data);
    } catch (e) {
      debugPrint('TransactionService.createTransaction error: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(transaction.id)
          .update(transaction.toJson());
    } catch (e) {
      debugPrint('TransactionService.updateTransaction error: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection(_collectionName).doc(transactionId).delete();
    } catch (e) {
      debugPrint('TransactionService.deleteTransaction error: $e');
      rethrow;
    }
  }

  // Aggregate KPIs
  Future<Map<String, dynamic>> getTransactionKPIs(String userId) async {
    try {
      final transactions = await getTransactionsByUserId(userId, limit: 1000);
      
      double totalVolume = 0;
      int successfulTransfers = 0;
      double totalFeeSaved = 0;
      int feeSavedCount = 0;

      for (final tx in transactions) {
        totalVolume += tx.amount;
        if (tx.status == TransactionStatus.completed) {
          successfulTransfers++;
        }
        if (tx.feeSaved != null && tx.feeSaved! > 0) {
          totalFeeSaved += tx.feeSaved!;
          feeSavedCount++;
        }
      }

      final avgFeeSaved = feeSavedCount > 0 ? totalFeeSaved / feeSavedCount : 0.0;

      return {
        'totalVolume': totalVolume,
        'successfulTransfers': successfulTransfers,
        'avgFeeSaved': avgFeeSaved,
        'totalTransactions': transactions.length,
      };
    } catch (e) {
      debugPrint('TransactionService.getTransactionKPIs error: $e');
      return {
        'totalVolume': 0.0,
        'successfulTransfers': 0,
        'avgFeeSaved': 0.0,
        'totalTransactions': 0,
      };
    }
  }
}
