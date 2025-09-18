import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:task_expense_manager/core/constants/failure.dart';
import 'package:task_expense_manager/features/expense/data/datasource/expense_datasource.dart';
import 'package:task_expense_manager/features/expense/domain/repository/expense_repository.dart';
import '../models/expense_model.dart';

@Injectable(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDatasource expenseDatasource;

  ExpenseRepositoryImpl(this.expenseDatasource);

  @override
  Stream<Either<Failure, List<ExpenseModel>>> getExpenses(String userId) {
    return expenseDatasource
        .getExpenses(userId)
        .map(
          (data) => Right<Failure, List<ExpenseModel>>(data),
        )
        .handleError((error) => Left(Failure(error.toString())));
  }

  @override
  Future<Either<Failure, void>> addExpense(
      String userId, ExpenseModel expense) async {
    try {
      await expenseDatasource.addExpense(userId, expense);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(
      String userId, ExpenseModel expense) async {
    try {
      await expenseDatasource.updateExpense(userId, expense);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(
      String userId, String expenseId) async {
    try {
      await expenseDatasource.deleteExpense(userId, expenseId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
