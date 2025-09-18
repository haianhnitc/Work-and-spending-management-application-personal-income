import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
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

  ExpenseController(this._expenseUseCase);

  final authController = Get.find<AuthController>();

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
}
