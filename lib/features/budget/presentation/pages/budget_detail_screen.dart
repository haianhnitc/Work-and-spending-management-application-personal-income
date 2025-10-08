import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_enums.dart';
import '../controllers/budget_controller.dart';
import '../../data/models/budget_model.dart';
import '../../../../core/utils/snackbar_helper.dart';

class BudgetDetailScreen extends StatelessWidget {
  final BudgetModel budget;
  final BudgetController _budgetController = Get.find<BudgetController>();

  BudgetDetailScreen({required this.budget});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          budget.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () => _editBudget(context),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deleteBudget(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _budgetController.loadBudgets(),
        child: ListView(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          children: [
            _buildBudgetOverview(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildProgressChart(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildBudgetDetails(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildActions(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildAlerts(context, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOverview(BuildContext context, bool isTablet) {
    final usagePercentage =
        budget.amount > 0 ? (budget.spentAmount / budget.amount) * 100 : 0;
    final isOverBudget = budget.spentAmount > budget.amount;
    final isNearLimit = usagePercentage >= 80;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isOverBudget) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Vượt ngân sách';
    } else if (isNearLimit) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      statusText = 'Gần hết';
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Bình thường';
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, size: 24, color: statusColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Ngân Sách',
                    '${budget.amount.toStringAsFixed(0)} VND',
                    Icons.account_balance_wallet,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Đã Chi',
                    '${budget.spentAmount.toStringAsFixed(0)} VND',
                    Icons.payment,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Còn Lại',
                    '${(budget.amount - budget.spentAmount).toStringAsFixed(0)} VND',
                    Icons.savings,
                    statusColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: usagePercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 8,
            ),
            SizedBox(height: 8),
            Text(
              'Sử dụng: ${usagePercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildOverviewItem(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressChart(BuildContext context, bool isTablet) {
    final usagePercentage =
        budget.amount > 0 ? (budget.spentAmount / budget.amount) * 100 : 0;
    final remainingPercentage = 100 - usagePercentage;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Biểu Đồ Sử Dụng',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: budget.spentAmount,
                      title: 'Đã chi\n${usagePercentage.toStringAsFixed(1)}%',
                      color: Colors.orange,
                      radius: 60,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: budget.amount - budget.spentAmount,
                      title:
                          'Còn lại\n${remainingPercentage.toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: 60,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildBudgetDetails(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Chi Tiết Ngân Sách',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailItem('Tên', budget.name),
            _buildDetailItem('Danh mục', categoryToString(budget.category)),
            _buildDetailItem('Chu kỳ', getPeriodDisplayName(budget.period)),
            _buildDetailItem('Ngày bắt đầu',
                '${budget.startDate.day}/${budget.startDate.month}/${budget.startDate.year}'),
            _buildDetailItem('Ngày kết thúc',
                '${budget.endDate.day}/${budget.endDate.month}/${budget.endDate.year}'),
            _buildDetailItem('Trạng thái',
                budget.isActive ? 'Hoạt động' : 'Không hoạt động'),
            if (budget.tags.isNotEmpty)
              _buildDetailItem('Nhãn', budget.tags.join(', ')),
            _buildDetailItem('Tạo lúc',
                '${budget.createdAt.day}/${budget.createdAt.month}/${budget.createdAt.year}'),
            _buildDetailItem('Cập nhật',
                '${budget.updatedAt.day}/${budget.updatedAt.month}/${budget.updatedAt.year}'),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Hành Động',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _budgetController.autoAdjustBudget(budget.id),
                    icon: Icon(Icons.auto_fix_high),
                    label: Text('Tự Động Điều Chỉnh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _budgetController.syncBudgetWithExpenses(budget.id),
                    icon: Icon(Icons.sync),
                    label: Text('Đồng Bộ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareReport(context),
                    icon: Icon(Icons.share),
                    label: Text('Chia sẻ Text'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _exportFileReport(context),
                    icon: Icon(Icons.download),
                    label: Text('Xuất File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _duplicateBudget(context),
                    icon: Icon(Icons.copy),
                    label: Text('Sao Chép'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildAlerts(BuildContext context, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications,
                    size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Cảnh Báo',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Obx(() {
              if (_budgetController.alerts.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, size: 48, color: Colors.green),
                      SizedBox(height: 8),
                      Text(
                        'Không có cảnh báo nào',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: _budgetController.alerts.map((alert) {
                  Color alertColor;
                  IconData alertIcon;

                  switch (alert.type) {
                    case 'critical':
                      alertColor = Colors.red;
                      alertIcon = Icons.error;
                      break;
                    case 'warning':
                      alertColor = Colors.orange;
                      alertIcon = Icons.warning;
                      break;
                    default:
                      alertColor = Colors.blue;
                      alertIcon = Icons.info;
                  }

                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    color: alertColor.withOpacity(0.1),
                    child: ListTile(
                      leading: Icon(alertIcon, color: alertColor),
                      title: Text(
                        alert.message,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: alertColor,
                        ),
                      ),
                      subtitle: Text(
                        '${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: alert.isRead
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.circle, color: alertColor),
                    ),
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _budgetController.checkBudgetAlerts(budget.id),
                icon: Icon(Icons.refresh),
                label: Text('Kiểm Tra Cảnh Báo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  void _editBudget(BuildContext context) {
    Get.toNamed('/budget-create',
        arguments: {'budget': budget, 'isEdit': true});
  }

  void _deleteBudget(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa ngân sách "${budget.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _budgetController.deleteBudget(budget.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _shareReport(BuildContext context) async {
    try {
      final report = _generateBudgetReport(budget);
      await Share.share(report);
      SnackbarHelper.showSuccess('Đã chia sẻ báo cáo ngân sách');
    } catch (e) {
      SnackbarHelper.showError('Không thể chia sẻ báo cáo: $e');
    }
  }

  void _exportFileReport(BuildContext context) async {
    try {
      await _budgetController.exportBudgetReport(budget.id);
    } catch (e) {
      _showExportFailureDialog(context, e.toString());
    }
  }

  void _showExportFailureDialog(BuildContext context, String error) {
    Get.dialog(
      AlertDialog(
        title: const Text('Export file thất bại'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lỗi: $error'),
            const SizedBox(height: 16),
            const Text('Bạn có muốn chia sẻ báo cáo dưới dạng text không?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _shareReport(context);
            },
            child: const Text('Chia sẻ Text'),
          ),
        ],
      ),
    );
  }

  String _generateBudgetReport(BudgetModel budget) {
    try {
      final now = DateTime.now();

      // Ensure safe type conversion to double for calculations
      final budgetAmount = budget.amount.toDouble();
      final spentAmount = budget.spentAmount.toDouble();

      final progress =
          budgetAmount > 0 ? (spentAmount / budgetAmount * 100) : 0.0;
      final remaining = budgetAmount - spentAmount;

      // Safe currency formatting with explicit double conversion
      final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
      final formattedBudgetAmount = formatter.format(budgetAmount);
      final formattedSpentAmount = formatter.format(spentAmount);
      final formattedRemaining = formatter.format(remaining);

      return '''
💰 BÁO CÁO NGÂN SÁCH CHI TIẾT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📅 Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}

📋 THÔNG TIN NGÂN SÁCH:
• Tên: ${budget.name}
• Danh mục: ${budget.category}
• Khoảng thời gian: ${budget.period}

💰 TÀI CHÍNH:
• Số tiền dự kiến: $formattedBudgetAmount
• Đã chi tiêu: $formattedSpentAmount
• Còn lại: $formattedRemaining

📊 TIẾN ĐỘ:
• Tỷ lệ sử dụng: ${progress.toStringAsFixed(1)}%
• Trạng thái: ${budget.isActive ? '🟢 Đang hoạt động' : '🔴 Không hoạt động'}

📅 THỜI GIAN:
• Bắt đầu: ${DateFormat('dd/MM/yyyy').format(budget.startDate)}
• Kết thúc: ${DateFormat('dd/MM/yyyy').format(budget.endDate)}

🎯 ĐÁNH GIÁ:
${_getBudgetAssessment(progress, remaining)}

──────────────────────────────────
Được tạo bởi Task & Expense Manager
''';
    } catch (e) {
      // Fallback report if formatting fails
      return '''
💰 BÁO CÁO NGÂN SÁCH CHI TIẾT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ Có lỗi khi tạo báo cáo chi tiết: $e

📋 THÔNG TIN CƠ BẢN:
• Tên: ${budget.name}
• Danh mục: ${budget.category}
• Trạng thái: ${budget.isActive ? 'Đang hoạt động' : 'Không hoạt động'}

──────────────────────────────────
Được tạo bởi Task & Expense Manager
''';
    }
  }

  String _getBudgetAssessment(double progress, double remaining) {
    if (progress <= 50) {
      return '✅ Tuyệt vời! Bạn đang kiểm soát tốt ngân sách.';
    } else if (progress <= 80) {
      return '⚠️ Cần chú ý! Đã sử dụng hơn 50% ngân sách.';
    } else if (progress <= 100) {
      return '🚨 Cảnh báo! Sắp vượt ngân sách dự kiến.';
    } else {
      return '❌ Đã vượt ngân sách ${(progress - 100).toStringAsFixed(1)}%!';
    }
  }

  void _duplicateBudget(BuildContext context) async {
    final newStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (newStartDate != null) {
      await _budgetController.duplicateBudget(budget.id, newStartDate);
    }
  }
}
