import '../../data/models/expense_model.dart';
import '../../data/repository/expense_repository.dart';

class ExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  ExpenseUseCase(this._expenseRepository);

  Stream<List> getExpenses(String userId) {
    return _expenseRepository.getExpenses(userId);
  }

  Future addExpense(String userId, ExpenseModel expense) async {
    await _expenseRepository.addExpense(userId, expense);
  }

  Future updateExpense(String userId, ExpenseModel expense) async {
    await _expenseRepository.updateExpense(userId, expense);
  }

  Future deleteExpense(String userId, String expenseId) async {
    await _expenseRepository.deleteExpense(userId, expenseId);
  }
}
