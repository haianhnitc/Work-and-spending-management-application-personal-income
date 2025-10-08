import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:task_expense_manager/features/auth/presentation/controllers/auth_controller.dart';
import '../../../../core/services/file_export_service.dart';
import '../../../../core/utils/snackbar_helper.dart';
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
  final authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
    loadBudgetOverview();
  }

  Future<void> loadBudgets() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userId = authController.getCurrentUserId();

      if (userId.isEmpty) {
        errorMessage.value = 'Người dùng chưa đăng nhập';
        print(' User chưa đăng nhập, không thể tải ngân sách');
        SnackbarHelper.showError('Vui lòng đăng nhập để xem ngân sách');
        return;
      }

      print(' Đang tải ngân sách cho user: $userId');

      await for (final result in _budgetUseCase.getBudgets(userId)) {
        result.fold(
          (failure) {
            errorMessage.value = failure.message;
            print(' Lỗi tải ngân sách: ${failure.message}');
            SnackbarHelper.showError(
                'Không thể tải ngân sách: ${failure.message}');
          },
          (budgetList) {
            budgets.value = budgetList;
            print(' Đã tải ${budgetList.length} ngân sách');
          },
        );
        break;
      }
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải danh sách ngân sách: $e';
      print(' Exception trong loadBudgets: $e');
      SnackbarHelper.showError('Đã xảy ra lỗi hệ thống khi tải ngân sách');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBudgetOverview() async {
    try {
      final userId = authController.getCurrentUserId();

      if (userId.isEmpty) {
        print(' User chưa đăng nhập, không thể tải overview ngân sách');
        return;
      }

      final result = await _budgetUseCase.getBudgetOverview(userId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          print(' Lỗi tải overview ngân sách: ${failure.message}');
        },
        (overview) {
          budgetOverview.value = overview;
          print(' Đã tải overview ngân sách');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải tổng quan ngân sách: $e';
      print(' Exception trong loadBudgetOverview: $e');
    }
  }

  Future<void> createBudget(BudgetModel budget) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result = await _budgetUseCase.createBudget(userId, budget);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          SnackbarHelper.showError('Lỗi tạo ngân sách: ${failure.message}');
        },
        (_) {
          loadBudgets();
          Get.back();
          Future.delayed(Duration(milliseconds: 300), () {
            SnackbarHelper.showSuccess('Đã tạo ngân sách thành công');
          });
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tạo ngân sách: $e';
      SnackbarHelper.showError('Không thể tạo ngân sách');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBudget(BudgetModel budget) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result = await _budgetUseCase.updateBudget(userId, budget);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          SnackbarHelper.showError(
              'Lỗi cập nhật ngân sách: ${failure.message}');
        },
        (_) {
          final index = budgets.indexWhere((b) => b.id == budget.id);
          if (index != -1) {
            budgets[index] = budget;
          }
          Get.back();
          Future.delayed(Duration(milliseconds: 300), () {
            SnackbarHelper.showSuccess(
                'Đã cập nhật ngân sách "${budget.name}"');
          });
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi cập nhật ngân sách: $e';
      SnackbarHelper.showError('Không thể cập nhật ngân sách');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result = await _budgetUseCase.deleteBudget(userId, budgetId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          SnackbarHelper.showError('Lỗi xóa ngân sách: ${failure.message}');
        },
        (_) {
          loadBudgets();
          SnackbarHelper.showSuccess('Đã xóa ngân sách thành công');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi xóa ngân sách: $e';
      SnackbarHelper.showError('Không thể xóa ngân sách');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSpentAmount(String budgetId, double amount) async {
    try {
      final userId = authController.getCurrentUserId();
      final result =
          await _budgetUseCase.updateSpentAmount(userId, budgetId, amount);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          loadBudgets();
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi cập nhật số tiền đã chi: $e';
    }
  }

  Future<void> resetBudget(String budgetId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result =
          await _budgetUseCase.updateSpentAmount(userId, budgetId, 0.0);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          SnackbarHelper.showError('Lỗi reset ngân sách: ${failure.message}');
        },
        (_) {
          loadBudgets();
          SnackbarHelper.showSuccess('Đã reset ngân sách về 0');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi reset ngân sách: $e';
      SnackbarHelper.showError('Không thể reset ngân sách');
    } finally {
      isLoading.value = false;
    }
  }

  Future<BudgetReportModel?> getBudgetReport(String budgetId) async {
    try {
      final userId = authController.getCurrentUserId();
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

  Future<void> createSmartBudget(
      String category, DateTime startDate, DateTime endDate) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result = await _budgetUseCase.createSmartBudget(
          userId, category, startDate, endDate);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets();
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tạo ngân sách thông minh: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> autoAdjustBudget(String budgetId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result = await _budgetUseCase.autoAdjustBudget(userId, budgetId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets();
          SnackbarHelper.showSuccess('Đã điều chỉnh ngân sách tự động');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi điều chỉnh ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkBudgetAlerts(String budgetId) async {
    try {
      final userId = authController.getCurrentUserId();
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

  Stream<List<BudgetModel>> getBudgetsByCategory(String category) {
    final userId = authController.getCurrentUserId();
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

  Stream<List<BudgetModel>> getBudgetsByPeriod(String period) {
    final userId = authController.getCurrentUserId();
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

  Future<void> createBudgetFromTemplate(String templateName) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result =
          await _budgetUseCase.createBudgetFromTemplate(userId, templateName);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets();
          SnackbarHelper.showSuccess('Đã tạo ngân sách từ template');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi tạo ngân sách từ template: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> duplicateBudget(String budgetId, DateTime newStartDate) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userId = authController.getCurrentUserId();
      final result =
          await _budgetUseCase.duplicateBudget(userId, budgetId, newStartDate);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (budget) {
          loadBudgets();
          SnackbarHelper.showSuccess('Đã sao chép ngân sách');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi sao chép ngân sách: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportBudgetReport(String budgetId,
      {String format = 'pdf'}) async {
    try {
      BudgetModel? budget;
      for (var b in budgets) {
        if (b.id == budgetId) {
          budget = b;
          break;
        }
      }
      if (budget == null) {
        SnackbarHelper.showError('Không tìm thấy ngân sách');
        return;
      }

      final fileExportService = Get.find<FileExportService>();
      await fileExportService.showExportOptionsDialog(
        budget: budget,
        availableFormats: ['pdf', 'excel', 'csv'],
      );
    } catch (e) {
      SnackbarHelper.showInfo('Đang chuyển sang chia sẻ text...');
      BudgetModel? budget;
      for (var b in budgets) {
        if (b.id == budgetId) {
          budget = b;
          break;
        }
      }
      if (budget != null) {
        try {
          final fileExportService = Get.find<FileExportService>();
          await fileExportService.fallbackToTextShare(budget);
        } catch (fallbackError) {
          SnackbarHelper.showError('Không thể export báo cáo: $e');
        }
      }
    }
  }

  Future<String?> exportBudgetReportDirect(
    String budgetId,
    String format, {
    bool autoShare = true,
  }) async {
    try {
      BudgetModel? budget;
      for (var b in budgets) {
        if (b.id == budgetId) {
          budget = b;
          break;
        }
      }
      if (budget == null) {
        SnackbarHelper.showError('Không tìm thấy ngân sách');
        return null;
      }

      final fileExportService = Get.find<FileExportService>();
      return await fileExportService.exportBudgetReport(
        budget: budget,
        format: format,
        autoShare: autoShare,
      );
    } catch (e) {
      SnackbarHelper.showError('Không thể export báo cáo: $e');
      return null;
    }
  }

  Future<void> syncBudgetWithExpenses(String budgetId) async {
    try {
      final userId = authController.getCurrentUserId();
      final result =
          await _budgetUseCase.syncBudgetWithExpenses(userId, budgetId);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          loadBudgets();
          SnackbarHelper.showSuccess('Đã đồng bộ ngân sách với chi tiêu');
        },
      );
    } catch (e) {
      errorMessage.value = 'Lỗi khi đồng bộ ngân sách: $e';
    }
  }

  Future<List<String>> getBudgetSuggestions() async {
    try {
      final userId = authController.getCurrentUserId();
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

  void selectBudget(BudgetModel budget) {
    selectedBudget.value = budget;
  }

  void clearSelectedBudget() {
    selectedBudget.value = null;
  }

  BudgetModel? getBudgetById(String budgetId) {
    try {
      return budgets.firstWhere((budget) => budget.id == budgetId);
    } catch (e) {
      return null;
    }
  }

  List<BudgetModel> get activeBudgets {
    return budgets.where((budget) => budget.isActive).toList();
  }

  List<BudgetModel> get budgetsNearLimit {
    return budgets.where((budget) {
      final usagePercentage =
          budget.amount > 0 ? (budget.spentAmount / budget.amount) * 100 : 0;
      return usagePercentage >= 80;
    }).toList();
  }

  List<BudgetModel> get overBudgetBudgets {
    return budgets
        .where((budget) => budget.spentAmount > budget.amount)
        .toList();
  }

  double get totalBudgetAmount {
    return budgets.fold(0.0, (sum, budget) => sum + budget.amount);
  }

  double get totalSpentAmount {
    return budgets.fold(0.0, (sum, budget) => sum + budget.spentAmount);
  }

  double get totalRemainingAmount {
    return totalBudgetAmount - totalSpentAmount;
  }

  double get overallUsagePercentage {
    return totalBudgetAmount > 0
        ? (totalSpentAmount / totalBudgetAmount) * 100
        : 0;
  }
}
