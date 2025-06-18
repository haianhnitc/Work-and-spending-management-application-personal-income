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

  ExpenseController(this._expenseUseCase);

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  void fetchExpenses() {
    final userId = Get.find<AuthController>().authUseCase.getCurrentUserId();
    if (userId != null) {
      isLoading.value = true;
      _expenseUseCase.getExpenses(userId).listen(
        (expenseList) {
          isLoading.value = false;
          expenses.assignAll(expenseList as Iterable<ExpenseModel>);
        },
        onError: (e) {
          isLoading.value = false;
          Get.snackbar('Lỗi', 'Không thể lấy danh sách chi tiêu');
        },
      );
    } else {
      isLoading.value = false;
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final userId = Get.find<AuthController>().authUseCase.getCurrentUserId();
    if (userId != null) {
      final result = await _expenseUseCase.addExpense(userId, expense);
      Get.snackbar('Thành công', 'Tạo chi tiêu thành công');
    } else {
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    final userId = Get.find<AuthController>().authUseCase.getCurrentUserId();
    if (userId != null) {
      final result = await _expenseUseCase.updateExpense(userId, expense);
      Get.snackbar('Thành công', 'Cập nhật chi tiêu thành công');
    } else {
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    final userId = Get.find<AuthController>().authUseCase.getCurrentUserId();
    if (userId != null) {
      final result = await _expenseUseCase.deleteExpense(userId, expenseId);
      Get.snackbar('Thành công', 'Xóa chi tiêu thành công');
    } else {
      Get.snackbar('Lỗi', 'Chưa đăng nhập');
    }
  }
}
