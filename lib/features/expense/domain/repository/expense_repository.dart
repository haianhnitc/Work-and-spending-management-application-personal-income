import 'package:dartz/dartz.dart';
import 'package:task_expense_manager/core/constants/failure.dart';
import 'package:task_expense_manager/features/expense/data/models/expense_model.dart';

abstract class ExpenseRepository {
  Stream<Either<Failure, List<ExpenseModel>>> getExpenses(String userId);
  Future<Either<Failure, void>> addExpense(String userId, ExpenseModel expense);
  Future<Either<Failure, void>> updateExpense(
      String userId, ExpenseModel expense);
  Future<Either<Failure, void>> deleteExpense(String userId, String expenseId);
}
