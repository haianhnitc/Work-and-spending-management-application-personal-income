import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_config.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ExpenseModel>> getExpenses(String userId) {
    return _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> addExpense(String userId, ExpenseModel expense) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .doc(expense.id)
        .set(expense.toJson());
  }

  Future<void> updateExpense(String userId, ExpenseModel expense) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .doc(expense.id)
        .update(expense.toJson());
  }

  Future<void> deleteExpense(String userId, String expenseId) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .doc(expenseId)
        .delete();
  }
}
