import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:task_expense_manager/core/constants/firebase_config.dart';
import 'package:task_expense_manager/features/expense/data/models/expense_model.dart';

abstract class ExpenseDatasource {
  Stream<List<ExpenseModel>> getExpenses(String userId);
  Future<void> addExpense(String userId, ExpenseModel expense);
  Future<void> updateExpense(String userId, ExpenseModel expense);
  Future<void> deleteExpense(String userId, String expenseId);
}

@Injectable(as: ExpenseDatasource)
class ExpenseDatasourceImpl implements ExpenseDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ExpenseModel>> getExpenses(String userId) {
    return _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList()
            .cast<ExpenseModel>());
  }

  @override
  Future<void> addExpense(String userId, ExpenseModel expense) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .doc(expense.id)
        .set(expense.toJson());
  }

  @override
  Future<void> updateExpense(String userId, ExpenseModel expense) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .doc(expense.id)
        .update(expense.toJson());
  }

  @override
  Future<void> deleteExpense(String userId, String expenseId) async {
    await _firestore
        .collection(FirebaseConfig.usersCollection)
        .doc(userId)
        .collection(FirebaseConfig.expensesCollection)
        .doc(expenseId)
        .delete();
  }
}
