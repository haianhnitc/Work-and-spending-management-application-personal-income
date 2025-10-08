import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/failure.dart';
import '../../domain/repository/budget_repository.dart';
import '../datasources/budget_remote_data_source.dart';
import '../models/budget_model.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource _remoteDataSource;

  BudgetRepositoryImpl(this._remoteDataSource);

  @override
  Stream<Either<Failure, List<BudgetModel>>> getBudgets(String userId) async* {
    try {
      await for (final budgets in _remoteDataSource.getBudgets(userId)) {
        yield Right(budgets);
      }
    } catch (error) {
      yield Left(Failure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetModel?>> getBudgetById(
      String userId, String budgetId) async {
    try {
      final budget = await _remoteDataSource.getBudgetById(userId, budgetId);
      if (budget != null) {
        return Right(budget);
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createBudget(
      String userId, BudgetModel budget) async {
    try {
      await _remoteDataSource.createBudget(userId, budget);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBudget(
      String userId, BudgetModel budget) async {
    try {
      await _remoteDataSource.updateBudget(userId, budget);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(
      String userId, String budgetId) async {
    try {
      await _remoteDataSource.deleteBudget(userId, budgetId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSpentAmount(
      String userId, String budgetId, double amount) async {
    try {
      await _remoteDataSource.updateSpentAmount(userId, budgetId, amount);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetReportModel>> getBudgetReport(
      String userId, String budgetId) async {
    try {
      final report = await _remoteDataSource.getBudgetReport(userId, budgetId);
      return Right(report);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetModel>> createSmartBudget(String userId,
      String category, DateTime startDate, DateTime endDate) async {
    try {
      final budget = await _remoteDataSource.createSmartBudget(
          userId, category, startDate, endDate);
      return Right(budget);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetModel>> autoAdjustBudget(
      String userId, String budgetId) async {
    try {
      final budget = await _remoteDataSource.autoAdjustBudget(userId, budgetId);
      return Right(budget);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BudgetAlertModel>>> checkBudgetAlerts(
      String userId, String budgetId) async {
    try {
      final alerts =
          await _remoteDataSource.checkBudgetAlerts(userId, budgetId);
      return Right(alerts);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByCategory(
      String userId, String category) async* {
    try {
      await for (final budgets
          in _remoteDataSource.getBudgetsByCategory(userId, category)) {
        yield Right(budgets);
      }
    } catch (error) {
      yield Left(Failure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByPeriod(
      String userId, String period) async* {
    try {
      await for (final budgets
          in _remoteDataSource.getBudgetsByPeriod(userId, period)) {
        yield Right(budgets);
      }
    } catch (error) {
      yield Left(Failure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBudgetOverview(
      String userId) async {
    try {
      final overview = await _remoteDataSource.getBudgetOverview(userId);
      return Right(overview);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetModel>> createBudgetFromTemplate(
      String userId, String templateName) async {
    try {
      final budget = await _remoteDataSource.createBudgetFromTemplate(
          userId, templateName);
      return Right(budget);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BudgetModel>> duplicateBudget(
      String userId, String budgetId, DateTime newStartDate) async {
    try {
      final budget = await _remoteDataSource.duplicateBudget(
          userId, budgetId, newStartDate);
      return Right(budget);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncBudgetWithExpenses(
      String userId, String budgetId) async {
    try {
      await _remoteDataSource.syncBudgetWithExpenses(userId, budgetId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getBudgetSuggestions(
      String userId) async {
    try {
      final suggestions = await _remoteDataSource.getBudgetSuggestions(userId);
      return Right(suggestions);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByStatus(
      String userId, bool isActive) async* {
    try {
      await for (final budgets in _remoteDataSource.getBudgets(userId)) {
        final filteredBudgets =
            budgets.where((budget) => budget.isActive == isActive).toList();
        yield Right(filteredBudgets);
      }
    } catch (error) {
      yield Left(Failure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByDateRange(
      String userId, DateTime startDate, DateTime endDate) async* {
    try {
      await for (final budgets in _remoteDataSource.getBudgets(userId)) {
        final filteredBudgets = budgets
            .where((budget) =>
                budget.startDate.isAfter(startDate) &&
                budget.endDate.isBefore(endDate))
            .toList();
        yield Right(filteredBudgets);
      }
    } catch (error) {
      yield Left(Failure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByTag(
      String userId, String tag) async* {
    try {
      await for (final budgets in _remoteDataSource.getBudgets(userId)) {
        final filteredBudgets =
            budgets.where((budget) => budget.tags.contains(tag)).toList();
        yield Right(filteredBudgets);
      }
    } catch (error) {
      yield Left(Failure(error.toString()));
    }
  }
}
