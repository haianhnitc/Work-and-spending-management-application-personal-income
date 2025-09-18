import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecase/budget_usecase.dart';
import '../../data/models/budget_model.dart';

@injectable
class BudgetController extends GetxController {
  final BudgetUseCase _budgetUseCase;

  BudgetController(this._budgetUseCase);

  final RxList<BudgetModel> budgets = <BudgetModel>[].obs;
  final Rx<BudgetModel?> selectedBudget = Rx<BudgetModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, dynamic> budgetOverview = <String, dynamic>{}.obs;
  final RxList<BudgetAlertModel> alerts = <BudgetAlertModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
    loadBudgetOverview();
  }

  Future<void> loadBudgets() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      await for (final result in _budgetUseCase.getBudgets(userId)) {
        result.fold(
          (failure) {
            errorMessage.value = failure.message;
          },
          (budgetList) {
            budgets.value = budgetList;
          },
        );
        break;
      }
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải danh sách ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Load budget overview
  Future<void> loadBudgetOverview() async {
    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.getBudgetOverview(userId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (overview) {
          budgetOverview.value = overview;
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải tổng quan ngân sách: $e';
    }
  }

  // Create new budget
  Future<void> createBudget(BudgetModel budget) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.createBudget(userId, budget);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          loadBudgets(); // Reload budgets
          Get.snackbar('Thành công', 'Đã tạo ngân sách mới');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tạo ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Update budget
  Future<void> updateBudget(BudgetModel budget) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.updateBudget(userId, budget);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          loadBudgets(); // Reload budgets
          Get.snackbar('Thành công', 'Đã cập nhật ngân sách');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi cập nhật ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Delete budget
  Future<void> deleteBudget(String budgetId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.deleteBudget(userId, budgetId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          loadBudgets(); // Reload budgets
          Get.snackbar('Thành công', 'Đã xóa ngân sách');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi xóa ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Update spent amount
  Future<void> updateSpentAmount(String budgetId, double amount) async {
    try {
      final userId = 'user_id';
      final result =
          await _budgetUseCase.updateSpentAmount(userId, budgetId, amount);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          loadBudgets(); // Reload budgets
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi cập nhật số tiền đã chi: $e';
    }
  }

  // Get budget report
  Future<BudgetReportModel?> getBudgetReport(String budgetId) async {
    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.getBudgetReport(userId, budgetId);

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return null;
        },
        (report) => report,
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi lấy báo cáo ngân sách: $e';
      return null;
    }
  }

  // Create smart budget
  Future<void> createSmartBudget(
      String category, DateTime startDate, DateTime endDate) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.createSmartBudget(
          userId, category, startDate, endDate);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets();
          Get.snackbar('Thành công', 'Đã tạo ngân sách thông minh');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tạo ngân sách thông minh: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Auto adjust budget
  Future<void> autoAdjustBudget(String budgetId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.autoAdjustBudget(userId, budgetId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets(); // Reload budgets
          Get.snackbar('Thành công', 'Đã điều chỉnh ngân sách tự động');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi điều chỉnh ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Check budget alerts
  Future<void> checkBudgetAlerts(String budgetId) async {
    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.checkBudgetAlerts(userId, budgetId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (alertList) {
          alerts.value = alertList;
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi kiểm tra cảnh báo: $e';
    }
  }

  // Get budgets by category
  Stream<List<BudgetModel>> getBudgetsByCategory(String category) {
    final userId = 'user_id';
    return _budgetUseCase.getBudgetsByCategory(userId, category).map((result) {
      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return <BudgetModel>[];
        },
        (budgetList) => budgetList,
      );
    });
  }

  // Get budgets by period
  Stream<List<BudgetModel>> getBudgetsByPeriod(String period) {
    final userId = 'user_id';
    return _budgetUseCase.getBudgetsByPeriod(userId, period).map((result) {
      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return <BudgetModel>[];
        },
        (budgetList) => budgetList,
      );
    });
  }

  // Create budget from template
  Future<void> createBudgetFromTemplate(String templateName) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      final result =
          await _budgetUseCase.createBudgetFromTemplate(userId, templateName);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets(); // Reload budgets
          Get.snackbar('Thành công', 'Đã tạo ngân sách từ template');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tạo ngân sách từ template: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Duplicate budget
  Future<void> duplicateBudget(String budgetId, DateTime newStartDate) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = 'user_id';
      final result =
          await _budgetUseCase.duplicateBudget(userId, budgetId, newStartDate);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets(); // Reload budgets
          Get.snackbar('Thành công', 'Đã sao chép ngân sách');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi sao chép ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Export budget report
  Future<String?> exportBudgetReport(String budgetId, String format) async {
    try {
      final userId = 'user_id';
      final result =
          await _budgetUseCase.exportBudgetReport(userId, budgetId, format);

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return null;
        },
        (reportPath) => reportPath,
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi xuất báo cáo: $e';
      return null;
    }
  }

  // Sync budget with expenses
  Future<void> syncBudgetWithExpenses(String budgetId) async {
    try {
      final userId = 'user_id';
      final result =
          await _budgetUseCase.syncBudgetWithExpenses(userId, budgetId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          loadBudgets(); // Reload budgets
          Get.snackbar('Thành công', 'Đã đồng bộ ngân sách với chi tiêu');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi đồng bộ ngân sách: $e';
    }
  }

  // Get budget suggestions
  Future<List<String>> getBudgetSuggestions() async {
    try {
      final userId = 'user_id';
      final result = await _budgetUseCase.getBudgetSuggestions(userId);

      return result.fold(
        (failure) {
          errorMessage.value = failure.message;
          return <String>[];
        },
        (suggestions) => suggestions,
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi lấy gợi ý ngân sách: $e';
      return <String>[];
    }
  }

  // Select budget
  void selectBudget(BudgetModel budget) {
    selectedBudget.value = budget;
  }

  // Clear selected budget
  void clearSelectedBudget() {
    selectedBudget.value = null;
  }

  // Get budget by ID
  BudgetModel? getBudgetById(String budgetId) {
    try {
      return budgets.firstWhere((budget) => budget.id == budgetId);
    } catch (e) {
      return null;
    }
  }

  // Get active budgets
  List<BudgetModel> get activeBudgets {
    return budgets.where((budget) => budget.isActive).toList();
  }

  // Get budgets near limit (80% or more)
  List<BudgetModel> get budgetsNearLimit {
    return budgets.where((budget) {
      final usagePercentage =
          budget.amount > 0 ? (budget.spentAmount / budget.amount) * 100 : 0;
      return usagePercentage >= 80;
    }).toList();
  }

  // Get over budget budgets
  List<BudgetModel> get overBudgetBudgets {
    return budgets
        .where((budget) => budget.spentAmount > budget.amount)
        .toList();
  }

  // Get total budget amount
  double get totalBudgetAmount {
    return budgets.fold(0.0, (sum, budget) => sum + budget.amount);
  }

  // Get total spent amount
  double get totalSpentAmount {
    return budgets.fold(0.0, (sum, budget) => sum + budget.spentAmount);
  }

  // Get total remaining amount
  double get totalRemainingAmount {
    return totalBudgetAmount - totalSpentAmount;
  }

  // Get overall usage percentage
  double get overallUsagePercentage {
    return totalBudgetAmount > 0
        ? (totalSpentAmount / totalBudgetAmount) * 100
        : 0;
  }
}
