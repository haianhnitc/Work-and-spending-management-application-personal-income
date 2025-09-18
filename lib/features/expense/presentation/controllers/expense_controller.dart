import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
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

  ExpenseController(this._expenseUseCase);

  final authController = Get.find<AuthController>();

  // Computed properties for filtered data
  List<ExpenseModel> get filteredExpenses {
    return expenses.where((expense) {
      final matchesCategory = selectedCategory.value.isEmpty ||
          expense.category == displayNameToCategory(selectedCategory.value);
      final matchesTime = filterByTime(expense.date);
      return matchesCategory && matchesTime;
    }).toList();
  }

  List<ExpenseModel> get filteredExpensesOnly {
    return filteredExpenses.where((expense) => expense.amount < 0).toList();
  }

  Map<String, double> get categoryTotals {
    final categoryTotals = <String, double>{};
    
    if (selectedCategory.value.isNotEmpty) {
      // Convert display name to category key for comparison
      final categoryKey = displayNameToCategory(selectedCategory.value);
      
      // Có filter category: chỉ hiển thị category đó với data đã filter theo time
      final categoryExpenses = expenses.where((expense) {
        final matchesCategory = expense.category == categoryKey;
        final matchesTime = filterByTime(expense.date);
        final isExpense = expense.amount < 0;
        return matchesCategory && matchesTime && isExpense;
      });
      
      if (categoryExpenses.isNotEmpty) {
        categoryTotals[categoryKey] = categoryExpenses
            .fold(0.0, (sum, e) => sum + e.amount.abs());
      }
    } else {
      // Không có filter category: hiển thị tất cả categories với data đã filter theo time
      for (var category in Category.values) {
        final categoryExpenses = expenses.where((expense) {
          final matchesCategory = expense.category == category.name;
          final matchesTime = filterByTime(expense.date);
          final isExpense = expense.amount < 0;
          return matchesCategory && matchesTime && isExpense;
        });
        
        if (categoryExpenses.isNotEmpty) {
          categoryTotals[category.name] = categoryExpenses
              .fold(0.0, (sum, e) => sum + e.amount.abs());
        }
      }
    }
    
    return categoryTotals;
  }

  double get totalExpense {
    return filteredExpenses
        .where((e) => e.amount < 0)
        .fold(0.0, (sum, e) => sum + e.amount.abs());
  }

  double get totalIncome {
    return filteredExpenses
        .where((e) => e.amount > 0)
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
              Get.snackbar('Có lỗi khi lấy danh sách expense', failure.message);
            },
            (expenseList) {
              expenses.assignAll(expenseList);
            },
          );
        },
      );
    } else {
      isLoading.value = false;
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final userId = authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      final result = await _expenseUseCase.addExpense(userId, expense);
      result.fold(
        (left) => Get.snackbar('Lỗi', left.toString()),
        (right) => Get.snackbar('Thành công', 'Tạo chi tiêu thành công'),
      );
    } else {
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    final userId = authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      final result = await _expenseUseCase.updateExpense(userId, expense);
      result.fold(
        (left) => Get.snackbar('Lỗi', left.toString()),
        (right) => Get.snackbar('Thành công', 'Cập nhật chi tiêu thành công'),
      );
    } else {
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    final userId = authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      final result = await _expenseUseCase.deleteExpense(userId, expenseId);
      result.fold(
        (left) => Get.snackbar('Lỗi', left.toString()),
        (right) => Get.snackbar('Thành công', 'Xóa chi tiêu thành công'),
      );
    } else {
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
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
}
