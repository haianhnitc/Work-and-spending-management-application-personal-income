import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../budget/presentation/controllers/budget_controller.dart';
import '../../data/models/expense_model.dart';
import '../../domain/usecase/expense_usecase.dart';

@injectable
class ExpenseController extends GetxController {
  final ExpenseUseCase _expenseUseCase;
  final expenses = <ExpenseModel>[].obs;
  final isLoading = true.obs;

  final RxString selectedCategory = RxString('');
  final RxString timeFilter = RxString('month');
  final Rx<ChartType> selectedChartType = ChartType.pie.obs;
  final RxBool isOverviewExpanded = RxBool(true);

  ExpenseController(this._expenseUseCase);

  final authController = Get.find<AuthController>();

  List<ExpenseModel> get filteredExpenses {
    return expenses.where((expense) {
      final matchesCategory = selectedCategory.value.isEmpty ||
          categoryToString(expense.category) == selectedCategory.value;
      final matchesTime = filterByTime(expense.date);
      return matchesCategory && matchesTime;
    }).toList();
  }

  List<ExpenseModel> get filteredExpensesOnly {
    return filteredExpenses
        .where((expense) => expense.incomeType == IncomeType.none)
        .toList();
  }

  Map<String, double> get categoryTotals {
    final categoryTotals = <String, double>{};

    if (selectedCategory.value.isNotEmpty) {
      final categoryExpenses = expenses.where((expense) {
        final matchesCategory =
            categoryToString(expense.category) == selectedCategory.value;
        final matchesTime = filterByTime(expense.date);
        final isExpense = expense.incomeType == IncomeType.none;
        return matchesCategory && matchesTime && isExpense;
      });

      if (categoryExpenses.isNotEmpty) {
        categoryTotals[selectedCategory.value] =
            categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);
      }
    } else {
      for (var category in Category.values) {
        final categoryExpenses = expenses.where((expense) {
          final matchesCategory = expense.category == category.name;
          final matchesTime = filterByTime(expense.date);
          final isExpense = expense.incomeType == IncomeType.none;
          return matchesCategory && matchesTime && isExpense;
        });

        if (categoryExpenses.isNotEmpty) {
          categoryTotals[category.name] =
              categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);
        }
      }
    }

    return categoryTotals;
  }

  double get totalExpense {
    return filteredExpenses
        .where((e) => e.incomeType == IncomeType.none)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalIncome {
    return filteredExpenses
        .where((e) =>
            e.incomeType == IncomeType.fixed ||
            e.incomeType == IncomeType.variable)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  void fetchExpenses() {
    final userId = authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      isLoading.value = true;
      _expenseUseCase.getExpenses(userId).listen(
        (either) {
          isLoading.value = false;
          either.fold(
            (failure) {
              SnackbarHelper.showError(
                  'Lỗi tải danh sách giao dịch: ${failure.message}');
            },
            (expenseList) {
              expenses.assignAll(expenseList);
            },
          );
        },
      );
    } else {
      isLoading.value = false;
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final userId = authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      final result = await _expenseUseCase.addExpense(userId, expense);
      result.fold(
        (left) => SnackbarHelper.showError('Lỗi tạo giao dịch: $left'),
        (right) {
          if (expense.incomeType == IncomeType.none) {
            _updateBudgetSpentAmount(expense);
          }

          Get.back();
          Future.delayed(Duration(milliseconds: 300), () {
            SnackbarHelper.showSuccess(
                'Đã tạo giao dịch "${expense.title}" thành công');
          });
        },
      );
    } else {
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
    }
  }

  void _updateBudgetSpentAmount(ExpenseModel expense) {
    try {
      final budgetController = Get.find<BudgetController>();

      final activeBudgets = budgetController.budgets.where((budget) {
        final now = DateTime.now();
        final isActive =
            budget.startDate.isBefore(now) && budget.endDate.isAfter(now);
        final matchesCategory =
            budget.category == expense.category || budget.category == 'all';
        return isActive && matchesCategory;
      }).toList();

      for (final budget in activeBudgets) {
        final newSpentAmount = budget.spentAmount + expense.amount;
        budgetController.updateSpentAmount(budget.id, newSpentAmount);
      }
    } catch (e) {
      print('⚠️ Could not update budget spent amount: $e');
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    final userId = authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      final oldExpense = expenses.firstWhereOrNull((e) => e.id == expense.id);

      final result = await _expenseUseCase.updateExpense(userId, expense);
      result.fold(
        (left) => SnackbarHelper.showError('Lỗi cập nhật giao dịch: $left'),
        (right) {
          final index = expenses.indexWhere((e) => e.id == expense.id);
          if (index != -1) {
            expenses[index] = expense;
          }

          if (oldExpense != null &&
              (oldExpense.incomeType == IncomeType.none ||
                  expense.incomeType == IncomeType.none)) {
            _updateBudgetForExpenseChange(oldExpense, expense);
          }

          Get.back();
          Future.delayed(Duration(milliseconds: 300), () {
            SnackbarHelper.showSuccess('Đã cập nhật giao dịch thành công');
          });
        },
      );
    } else {
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    final userId = authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      final expenseToDelete =
          expenses.firstWhereOrNull((e) => e.id == expenseId);

      final result = await _expenseUseCase.deleteExpense(userId, expenseId);
      result.fold(
        (left) => SnackbarHelper.showError('Lỗi xóa giao dịch: $left'),
        (right) {
          if (expenseToDelete != null &&
              expenseToDelete.incomeType == IncomeType.none) {
            _removeBudgetSpentAmount(expenseToDelete);
          }

          SnackbarHelper.showSuccess('Đã xóa giao dịch thành công');
        },
      );
    } else {
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
    }
  }

  void _updateBudgetForExpenseChange(
      ExpenseModel oldExpense, ExpenseModel newExpense) {
    try {
      final budgetController = Get.find<BudgetController>();

      if (oldExpense.incomeType == IncomeType.none) {
        _removeBudgetSpentAmountHelper(oldExpense, budgetController);
      }

      if (newExpense.incomeType == IncomeType.none) {
        _addBudgetSpentAmountHelper(newExpense, budgetController);
      }

      print(
          '🔄 Updated budget for expense change: ${oldExpense.title} -> ${newExpense.title}');
    } catch (e) {
      print('⚠️ Could not update budget for expense change: $e');
    }
  }

  void _removeBudgetSpentAmount(ExpenseModel expense) {
    try {
      final budgetController = Get.find<BudgetController>();
      _removeBudgetSpentAmountHelper(expense, budgetController);
    } catch (e) {
      print('⚠️ Could not remove expense from budget: $e');
    }
  }

  void _addBudgetSpentAmountHelper(
      ExpenseModel expense, BudgetController budgetController) {
    final activeBudgets = budgetController.budgets.where((budget) {
      final now = DateTime.now();
      final isActive =
          budget.startDate.isBefore(now) && budget.endDate.isAfter(now);
      final matchesCategory =
          budget.category == expense.category || budget.category == 'all';
      return isActive && matchesCategory;
    }).toList();

    for (final budget in activeBudgets) {
      final newSpentAmount = budget.spentAmount + expense.amount;
      budgetController.updateSpentAmount(budget.id, newSpentAmount);
    }
  }

  void _removeBudgetSpentAmountHelper(
      ExpenseModel expense, BudgetController budgetController) {
    final activeBudgets = budgetController.budgets.where((budget) {
      final now = DateTime.now();
      final isActive =
          budget.startDate.isBefore(now) && budget.endDate.isAfter(now);
      final matchesCategory =
          budget.category == expense.category || budget.category == 'all';
      return isActive && matchesCategory;
    }).toList();

    for (final budget in activeBudgets) {
      final newSpentAmount =
          (budget.spentAmount - expense.amount).clamp(0.0, double.infinity);
      budgetController.updateSpentAmount(budget.id, newSpentAmount);
    }
  }

  bool filterByTime(DateTime date) {
    final now = DateTime.now();
    if (timeFilter.value == 'week') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return date.isAfter(startOfWeek.subtract(Duration(days: 1)));
    } else if (timeFilter.value == 'month') {
      return date.month == now.month && date.year == now.year;
    } else {
      return date.year == now.year;
    }
  }

  void clearCategoryFilter() {
    selectedCategory.value = '';
  }

  void setTimeFilter(String filter) {
    timeFilter.value = filter;
  }

  void setCategoryFilter(String category) {
    selectedCategory.value = category;
  }

  void setChartType(ChartType chartType) {
    selectedChartType.value = chartType;
  }

  void toggleOverview() {
    isOverviewExpanded.value = !isOverviewExpanded.value;
  }
}
