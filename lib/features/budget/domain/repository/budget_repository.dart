import 'package:dartz/dartz.dart';
import '../../../../core/constants/failure.dart';
import '../../data/models/budget_model.dart';

abstract class BudgetRepository {
  Stream<Either<Failure, List<BudgetModel>>> getBudgets(String userId);

  Future<Either<Failure, BudgetModel?>> getBudgetById(
      String userId, String budgetId);

  Future<Either<Failure, void>> createBudget(String userId, BudgetModel budget);

  Future<Either<Failure, void>> updateBudget(String userId, BudgetModel budget);

  Future<Either<Failure, void>> deleteBudget(String userId, String budgetId);

  // Cập nhật số tiền đã chi
  Future<Either<Failure, void>> updateSpentAmount(
      String userId, String budgetId, double amount);

  // Lấy báo cáo ngân sách
  Future<Either<Failure, BudgetReportModel>> getBudgetReport(
      String userId, String budgetId);

  // Tạo ngân sách thông minh dựa trên lịch sử
  Future<Either<Failure, BudgetModel>> createSmartBudget(
      String userId, String category, DateTime startDate, DateTime endDate);

  // Điều chỉnh ngân sách tự động
  Future<Either<Failure, BudgetModel>> autoAdjustBudget(
      String userId, String budgetId);

  // Kiểm tra cảnh báo ngân sách
  Future<Either<Failure, List<BudgetAlertModel>>> checkBudgetAlerts(
      String userId, String budgetId);

  // Lấy ngân sách theo danh mục
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByCategory(
      String userId, String category);

  // Lấy ngân sách theo thời gian
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByPeriod(
      String userId, String period);

  // Lấy tổng quan ngân sách
  Future<Either<Failure, Map<String, dynamic>>> getBudgetOverview(
      String userId);

  // Tạo ngân sách từ template
  Future<Either<Failure, BudgetModel>> createBudgetFromTemplate(
      String userId, String templateName);

  // Sao chép ngân sách
  Future<Either<Failure, BudgetModel>> duplicateBudget(
      String userId, String budgetId, DateTime newStartDate);

  // Đồng bộ ngân sách với chi tiêu
  Future<Either<Failure, void>> syncBudgetWithExpenses(
      String userId, String budgetId);

  // Lấy gợi ý ngân sách
  Future<Either<Failure, List<String>>> getBudgetSuggestions(String userId);

  // Lấy ngân sách theo trạng thái
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByStatus(
      String userId, bool isActive);

  // Lấy ngân sách theo khoảng thời gian
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByDateRange(
      String userId, DateTime startDate, DateTime endDate);

  // Lấy ngân sách theo tag
  Stream<Either<Failure, List<BudgetModel>>> getBudgetsByTag(
      String userId, String tag);
}
