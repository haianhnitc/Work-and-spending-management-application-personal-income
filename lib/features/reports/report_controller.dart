import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../core/utils/snackbar_helper.dart';
import '../expense/presentation/controllers/expense_controller.dart';
import '../task/presentation/controllers/task_controller.dart';
import '../budget/presentation/controllers/budget_controller.dart';

class ReportController extends GetxController {
  final ExpenseController _expenseController = Get.find<ExpenseController>();
  final TaskController _taskController = Get.find<TaskController>();
  final BudgetController _budgetController = Get.find<BudgetController>();

  final RxBool isExporting = false.obs;

  Future<void> exportExpenseReport() async {
    try {
      isExporting.value = true;

      final expenses = _expenseController.filteredExpenses;
      final totalExpense = _expenseController.totalExpense;
      final totalIncome = _expenseController.totalIncome;

      final report =
          _generateExpenseReport(expenses, totalExpense, totalIncome);

      await Share.share(report);

      SnackbarHelper.showSuccess('Đã chia sẻ báo cáo chi tiêu');
    } catch (e) {
      SnackbarHelper.showError('Không thể xuất báo cáo: $e');
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> exportTaskReport() async {
    try {
      isExporting.value = true;

      final tasks = _taskController.tasks;
      final completedTasks = tasks.where((t) => t.isCompleted).length;
      final pendingTasks = tasks.length - completedTasks;

      final report =
          _generateTaskReport(tasks.toList(), completedTasks, pendingTasks);

      await Share.share(report);

      SnackbarHelper.showSuccess('Đã chia sẻ báo cáo công việc');
    } catch (e) {
      SnackbarHelper.showError('Không thể xuất báo cáo: $e');
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> exportBudgetReport() async {
    try {
      isExporting.value = true;

      final budgets = _budgetController.budgets;

      final report = _generateBudgetReport(budgets.toList());

      await Share.share(report);

      SnackbarHelper.showSuccess('Đã chia sẻ báo cáo ngân sách');
    } catch (e) {
      SnackbarHelper.showError('Không thể xuất báo cáo: $e');
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> exportFullReport() async {
    try {
      isExporting.value = true;

      final expenses = _expenseController.filteredExpenses;
      final tasks = _taskController.tasks.toList();
      final budgets = _budgetController.budgets.toList();

      final report = _generateFullReport(expenses, tasks, budgets);

      await Share.share(report);

      SnackbarHelper.showSuccess('Đã chia sẻ báo cáo tổng hợp');
    } catch (e) {
      SnackbarHelper.showError('Không thể xuất báo cáo: $e');
    } finally {
      isExporting.value = false;
    }
  }

  String _generateExpenseReport(
      dynamic expenses, double totalExpense, double totalIncome) {
    final balance = totalIncome - totalExpense;
    final now = DateTime.now();

    return '''
📊 BÁO CÁO CHI TIÊU
━━━━━━━━━━━━━━━━━━━━━━━━

📅 Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}
📈 Khoảng thời gian: ${_expenseController.timeFilter.value}

💰 TỔNG QUAN:
• Tổng thu nhập: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalIncome)}
• Tổng chi tiêu: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalExpense)}
• Số dư: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(balance)}

📊 THỐNG KÊ:
• Số giao dịch: ${expenses.length}
• Trung bình/giao dịch: ${expenses.isNotEmpty ? NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format((totalExpense + totalIncome) / expenses.length) : '0 VNĐ'}

${balance >= 0 ? '✅ Tình hình tài chính ổn định' : '⚠️ Cần cân nhắc tiết kiệm'}

──────────────────────────────────
Được tạo bởi Task & Expense Manager
''';
  }

  String _generateTaskReport(dynamic tasks, int completed, int pending) {
    final now = DateTime.now();
    final completionRate =
        tasks.isNotEmpty ? (completed / tasks.length * 100) : 0;

    return '''
✅ BÁO CÁO CÔNG VIỆC
━━━━━━━━━━━━━━━━━━━━━━━━

📅 Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}

📈 TỔNG QUAN:
• Tổng công việc: ${tasks.length}
• Đã hoàn thành: $completed
• Đang thực hiện: $pending
• Tỷ lệ hoàn thành: ${completionRate.toStringAsFixed(1)}%

💼 ĐÁNH GIÁ:
${completionRate >= 80 ? '🌟 Năng suất xuất sắc!' : completionRate >= 60 ? '👍 Năng suất tốt' : '📋 Cần cải thiện năng suất'}

──────────────────────────────────
Được tạo bởi Task & Expense Manager
''';
  }

  String _generateBudgetReport(dynamic budgets) {
    final now = DateTime.now();
    final activeBudgets = budgets.where((b) => b.isActive).length;
    final totalBudget = budgets.fold(0.0, (sum, b) => sum + b.amount);
    final totalSpent = budgets.fold(0.0, (sum, b) => sum + b.spentAmount);

    return '''
💰 BÁO CÁO NGÂN SÁCH
━━━━━━━━━━━━━━━━━━━━━━━━

📅 Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}

📊 TỔNG QUAN:
• Tổng ngân sách: ${activeBudgets}
• Tổng số tiền dự kiến: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalBudget)}
• Tổng số tiền đã chi: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalSpent)}
• Còn lại: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalBudget - totalSpent)}

📈 HIỆU SUẤT:
• Tỷ lệ sử dụng: ${totalBudget > 0 ? (totalSpent / totalBudget * 100).toStringAsFixed(1) : 0}%

──────────────────────────────────
Được tạo bởi Task & Expense Manager
''';
  }

  String _generateFullReport(dynamic expenses, dynamic tasks, dynamic budgets) {
    final now = DateTime.now();
    final totalExpense = _expenseController.totalExpense;
    final totalIncome = _expenseController.totalIncome;
    final balance = totalIncome - totalExpense;
    final completedTasks = tasks.where((t) => t.isCompleted).length;

    return '''
📋 BÁO CÁO TỔNG HỢP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📅 Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}

💰 TÀI CHÍNH:
• Thu nhập: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalIncome)}
• Chi tiêu: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalExpense)}
• Số dư: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(balance)}

✅ CÔNG VIỆC:
• Tổng task: ${tasks.length}
• Hoàn thành: $completedTasks
• Tỷ lệ: ${tasks.isNotEmpty ? (completedTasks / tasks.length * 100).toStringAsFixed(1) : 0}%

💰 NGÂN SÁCH:
• Số ngân sách: ${budgets.length}
• Đang hoạt động: ${budgets.where((b) => b.isActive).length}

🎯 ĐÁNH GIÁ TỔNG QUAN:
${_getOverallAssessment(balance, completedTasks, tasks.length)}

──────────────────────────────────
Được tạo bởi Task & Expense Manager
''';
  }

  String _getOverallAssessment(double balance, int completed, int total) {
    final financialHealth = balance >= 0;
    final productivityRate = total > 0 ? completed / total : 0;

    if (financialHealth && productivityRate >= 0.8) {
      return '🌟 Xuất sắc! Tài chính ổn định và năng suất cao.';
    } else if (financialHealth && productivityRate >= 0.6) {
      return '👍 Tốt! Tài chính ổn định, năng suất khá tốt.';
    } else if (financialHealth) {
      return '💰 Tài chính ổn định nhưng cần cải thiện năng suất.';
    } else if (productivityRate >= 0.8) {
      return '⚡ Năng suất cao nhưng cần cải thiện tài chính.';
    } else {
      return '📈 Cần cải thiện cả tài chính và năng suất.';
    }
  }
}
