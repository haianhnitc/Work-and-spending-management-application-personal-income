import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../report_controller.dart';
import '../../../../core/services/file_export_service.dart';
import '../../../expense/data/models/expense_model.dart';
import '../../../task/data/models/task_model.dart';
import '../../../budget/data/models/budget_model.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';
import '../../../task/presentation/controllers/task_controller.dart';
import '../../../budget/presentation/controllers/budget_controller.dart';
import '../../../../core/utils/snackbar_helper.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen({super.key});

  final ReportController controller = Get.put(ReportController());
  final FileExportService _fileExportService = Get.put(FileExportService());

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Xuất Báo cáo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: isTablet ? 40 : 32,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Báo cáo Tài chính',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Xuất báo cáo chi tiết từ dữ liệu hiện có',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
            SizedBox(height: 24),
            _buildReportOption(
              context,
              icon: Icons.receipt_long,
              title: 'Báo cáo Chi tiêu',
              subtitle: 'Tổng hợp thu chi, số dư, thống kê giao dịch',
              color: Colors.red,
              onTap: () => _showExportOptions(context, 'expense'),
              isTablet: isTablet,
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
            SizedBox(height: 16),
            _buildReportOption(
              context,
              icon: Icons.task_alt,
              title: 'Báo cáo Công việc',
              subtitle: 'Năng suất, tỷ lệ hoàn thành, danh sách task',
              color: Colors.blue,
              onTap: () => _showExportOptions(context, 'task'),
              isTablet: isTablet,
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
            SizedBox(height: 16),
            _buildReportOption(
              context,
              icon: Icons.account_balance_wallet,
              title: 'Báo cáo Ngân sách',
              subtitle: 'Hiệu suất ngân sách, tỷ lệ sử dụng',
              color: Colors.green,
              onTap: () => _showExportOptions(context, 'budget'),
              isTablet: isTablet,
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            SizedBox(height: 24),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isExporting.value
                        ? null
                        : () => _showExportOptions(context, 'full'),
                    icon: Icon(
                      controller.isExporting.value
                          ? Icons.hourglass_empty
                          : Icons.summarize,
                      size: isTablet ? 24 : 20,
                    ),
                    label: Text(
                      controller.isExporting.value
                          ? 'Đang xuất...'
                          : 'Báo cáo Tổng hợp',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 20 : 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                )).animate().fadeIn(duration: 300.ms, delay: 400.ms),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[800]?.withValues(alpha: 0.3)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Thông tin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Hỗ trợ nhiều định dạng: PDF, Excel, CSV, Text\n'
                    '• PDF: Định dạng chuyên nghiệp, dễ in ấn\n'
                    '• Excel: Dữ liệu bảng tính, có thể chỉnh sửa\n'
                    '• CSV: Dữ liệu thô, import được vào các ứng dụng khác\n'
                    '• Text: Chia sẻ nhanh qua email, tin nhắn',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: isTablet ? 28 : 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 18 : 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: isTablet ? 14 : 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.download,
          color: color,
          size: isTablet ? 24 : 20,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showExportOptions(BuildContext context, String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, color: Theme.of(context).primaryColor),
            SizedBox(width: 8),
            Text(_getReportTitle(reportType)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Chọn định dạng xuất báo cáo:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: ListTile(
                leading:
                    Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                title:
                    Text('PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Định dạng chuyên nghiệp, dễ in ấn'),
                onTap: () {
                  Get.back();
                  _performFileExport(reportType, 'pdf');
                },
              ),
            ),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.table_chart, color: Colors.green, size: 32),
                title: Text('Excel',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Bảng tính .xlsx, có thể chỉnh sửa'),
                onTap: () {
                  Get.back();
                  _performFileExport(reportType, 'excel');
                },
              ),
            ),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.description, color: Colors.blue, size: 32),
                title:
                    Text('CSV', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Dữ liệu thô .csv, import được'),
                onTap: () {
                  Get.back();
                  _performFileExport(reportType, 'csv');
                },
              ),
            ),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.share, color: Colors.orange, size: 32),
                title: Text('Chia sẻ Text',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Chia sẻ nhanh qua tin nhắn/email'),
                onTap: () {
                  Get.back();
                  _shareAsText(reportType);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Hủy'),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  String _getReportTitle(String reportType) {
    switch (reportType) {
      case 'expense':
        return 'Báo cáo Chi tiêu';
      case 'task':
        return 'Báo cáo Công việc';
      case 'budget':
        return 'Báo cáo Ngân sách';
      case 'full':
        return 'Báo cáo Tổng hợp';
      default:
        return 'Báo cáo';
    }
  }

  Future<void> _performFileExport(String reportType, String format) async {
    try {
      controller.isExporting.value = true;

      switch (reportType) {
        case 'expense':
          try {
            final expenseController = Get.find<ExpenseController>();
            final expenses = expenseController.expenses.cast<ExpenseModel>();
            final totalIncome = expenseController.totalIncome;
            final totalExpense = expenseController.totalExpense;
            await _fileExportService.exportExpenseReport(
              expenses: expenses,
              totalIncome: totalIncome,
              totalExpense: totalExpense,
              format: format,
            );
          } catch (e) {
            await _fileExportService.exportExpenseReport(
              expenses: <ExpenseModel>[],
              totalIncome: 0.0,
              totalExpense: 0.0,
              format: format,
            );
          }
          break;
        case 'task':
          try {
            final taskController = Get.find<TaskController>();
            final tasks = taskController.tasks.cast<TaskModel>();
            await _fileExportService.exportTaskReport(
              tasks: tasks,
              format: format,
            );
          } catch (e) {
            await _fileExportService.exportTaskReport(
              tasks: <TaskModel>[],
              format: format,
            );
          }
          break;
        case 'budget':
          try {
            final budgetController = Get.find<BudgetController>();
            final budgets = budgetController.budgets;
            final budget = budgets.isNotEmpty ? budgets.first : null;
            if (budget != null) {
              await _fileExportService.exportBudgetReport(
                budget: budget,
                format: format,
              );
            } else {
              throw Exception('Không tìm thấy ngân sách nào');
            }
          } catch (e) {
            throw Exception(
                'Không thể xuất báo cáo ngân sách: ${e.toString()}');
          }
          break;
        case 'full':
          try {
            final expenseController = Get.find<ExpenseController>();
            final taskController = Get.find<TaskController>();
            final budgetController = Get.find<BudgetController>();

            final expenses = expenseController.expenses.cast<ExpenseModel>();
            final tasks = taskController.tasks.cast<TaskModel>();
            final budgets = budgetController.budgets.cast<BudgetModel>();

            await _fileExportService.exportFullReport(
              expenses: expenses,
              tasks: tasks,
              budgets: budgets,
              format: format,
            );
          } catch (e) {
            await _fileExportService.exportFullReport(
              expenses: <ExpenseModel>[],
              tasks: <TaskModel>[],
              budgets: <BudgetModel>[],
              format: format,
            );
          }
          break;
      }

      SnackbarHelper.showSuccess(
          'Đã xuất báo cáo ${format.toUpperCase()} thành công!');
    } catch (e) {
      SnackbarHelper.showError('Không thể xuất báo cáo: ${e.toString()}');
    } finally {
      controller.isExporting.value = false;
    }
  }

  void _shareAsText(String reportType) {
    switch (reportType) {
      case 'expense':
        controller.exportExpenseReport();
        break;
      case 'task':
        controller.exportTaskReport();
        break;
      case 'budget':
        controller.exportBudgetReport();
        break;
      case 'full':
        controller.exportFullReport();
        break;
    }
  }
}
