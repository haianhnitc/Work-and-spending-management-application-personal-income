import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:task_expense_manager/core/constants/failure.dart';
import 'package:task_expense_manager/features/expense/domain/repository/expense_repository.dart';
import '../../data/models/expense_model.dart';

@injectable
class ExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  ExpenseUseCase(this._expenseRepository);

  Stream<Either<Failure, List<ExpenseModel>>> getExpenses(String userId) {
    return _expenseRepository.getExpenses(userId);
  }

  Future<Either<Failure, void>> addExpense(
      String userId, ExpenseModel expense) async {
    return await _expenseRepository.addExpense(userId, expense);
  }

  Future<Either<Failure, void>> updateExpense(
      String userId, ExpenseModel expense) async {
    return await _expenseRepository.updateExpense(userId, expense);
  }

  Future<Either<Failure, void>> deleteExpense(
      String userId, String expenseId) async {
    return await _expenseRepository.deleteExpense(userId, expenseId);
  }
}
