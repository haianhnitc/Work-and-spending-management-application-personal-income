import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/failure.dart';
import '../repository/budget_repository.dart';
import '../../data/models/budget_model.dart';

@injectable
class BudgetUseCase {
  final BudgetRepository _repository;

  BudgetUseCase(this._repository);

  Stream<Either<Failure, List<BudgetModel>>> getBudgets(String userId) {
    return _repository.getBudgets(userId);
  }

  Future<Either<Failure, BudgetModel?>> getBudgetById(
      String userId, String budgetId) {
    return _repository.getBudgetById(userId, budgetId);
  }

  Future<Either<Failure, void>> createBudget(
      String userId, BudgetModel budget) {
    return _repository.createBudget(userId, budget);
  }

  Future<Either<Failure, void>> updateBudget(
      String userId, BudgetModel budget) {
    return _repository.updateBudget(userId, budget);
  }

  Future<Either<Failure, void>> deleteBudget(String userId, String budgetId) {
    return _repository.deleteBudget(userId, budgetId);
  }

  Future<Either<Failure, void>> updateSpentAmount(
      String userId, String budgetId, double amount) {
    return _repository.updateSpentAmount(userId, budgetId, amount);
  }

  Future<Either<Failure, BudgetReportModel>> getBudgetReport(
      String userId, String budgetId) {
    return _repository.getBudgetReport(userId, budgetId);
  }

  Future<Either<Failure, BudgetModel>> createSmartBudget(
      String userId, String category, DateTime startDate, DateTime endDate) {
    return _repository.createSmartBudget(userId, category, startDate, endDate);
  }

  Future<Either<Failure, BudgetModel>> autoAdjustBudget(
      String userId, String budgetId) {
    return _repository.autoAdjustBudget(userId, budgetId);
  }

  Future<Either<Failure, List<BudgetAlertModel>>> checkBudgetAlerts(
      String userId, String budgetId) {
    return _repository.checkBudgetAlerts(userId, budgetId);
  }

  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByCategory(
      String userId, String category) {
    return _repository.getBudgetsByCategory(userId, category);
  }

  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByPeriod(
      String userId, String period) {
    return _repository.getBudgetsByPeriod(userId, period);
  }

  Future<Either<Failure, Map<String, dynamic>>> getBudgetOverview(
      String userId) {
    return _repository.getBudgetOverview(userId);
  }

  Future<Either<Failure, BudgetModel>> createBudgetFromTemplate(
      String userId, String templateName) {
    return _repository.createBudgetFromTemplate(userId, templateName);
  }

  Future<Either<Failure, BudgetModel>> duplicateBudget(
      String userId, String budgetId, DateTime newStartDate) {
    return _repository.duplicateBudget(userId, budgetId, newStartDate);
  }

  Future<Either<Failure, String>> exportBudgetReport(
      String userId, String budgetId, String format) {
    return _repository.exportBudgetReport(userId, budgetId, format);
  }

  Future<Either<Failure, void>> syncBudgetWithExpenses(
      String userId, String budgetId) {
    return _repository.syncBudgetWithExpenses(userId, budgetId);
  }

  Future<Either<Failure, List<String>>> getBudgetSuggestions(String userId) {
    return _repository.getBudgetSuggestions(userId);
  }

  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByStatus(
      String userId, bool isActive) {
    return _repository.getBudgetsByStatus(userId, isActive);
  }

  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByDateRange(
      String userId, DateTime startDate, DateTime endDate) {
    return _repository.getBudgetsByDateRange(userId, startDate, endDate);
  }

  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByTag(
      String userId, String tag) {
    return _repository.getBudgetsByTag(userId, tag);
  }
}
