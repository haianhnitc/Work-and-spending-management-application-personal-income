import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/budget_controller.dart';
import '../../data/models/budget_model.dart';

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
    final usagePercentage = budget.amount > 0 ? (budget.spentAmount / budget.amount) * 100 : 0;
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

  Widget _buildOverviewItem(BuildContext context, String title, String value, IconData icon, Color color) {
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
    final usagePercentage = budget.amount > 0 ? (budget.spentAmount / budget.amount) * 100 : 0;
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
                Icon(Icons.pie_chart, size: 20, color: Theme.of(context).primaryColor),
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
                      title: 'Còn lại\n${remainingPercentage.toStringAsFixed(1)}%',
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
                Icon(Icons.info, size: 20, color: Theme.of(context).primaryColor),
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
            _buildDetailItem('Danh mục', _getCategoryDisplayName(budget.category)),
            _buildDetailItem('Chu kỳ', _getPeriodDisplayName(budget.period)),
            _buildDetailItem('Ngày bắt đầu', '${budget.startDate.day}/${budget.startDate.month}/${budget.startDate.year}'),
            _buildDetailItem('Ngày kết thúc', '${budget.endDate.day}/${budget.endDate.month}/${budget.endDate.year}'),
            _buildDetailItem('Trạng thái', budget.isActive ? 'Hoạt động' : 'Không hoạt động'),
            if (budget.tags.isNotEmpty)
              _buildDetailItem('Nhãn', budget.tags.join(', ')),
            _buildDetailItem('Tạo lúc', '${budget.createdAt.day}/${budget.createdAt.month}/${budget.createdAt.year}'),
            _buildDetailItem('Cập nhật', '${budget.updatedAt.day}/${budget.updatedAt.month}/${budget.updatedAt.year}'),
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
                Icon(Icons.settings, size: 20, color: Theme.of(context).primaryColor),
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
                    onPressed: () => _budgetController.autoAdjustBudget(budget.id),
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
                    onPressed: () => _budgetController.syncBudgetWithExpenses(budget.id),
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
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _exportReport(context),
                    icon: Icon(Icons.download),
                    label: Text('Xuất Báo Cáo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
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
                Icon(Icons.notifications, size: 20, color: Theme.of(context).primaryColor),
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
    // TODO: Implement edit budget
    Get.snackbar('Thông báo', 'Tính năng đang phát triển!');
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

  void _exportReport(BuildContext context) async {
    final format = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn định dạng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('PDF'),
              onTap: () => Get.back(result: 'pdf'),
            ),
            ListTile(
              title: Text('Excel'),
              onTap: () => Get.back(result: 'xlsx'),
            ),
            ListTile(
              title: Text('CSV'),
              onTap: () => Get.back(result: 'csv'),
            ),
          ],
        ),
      ),
    );

    if (format != null) {
      final reportPath = await _budgetController.exportBudgetReport(budget.id, format);
      if (reportPath != null) {
        Get.snackbar('Thành công', 'Đã xuất báo cáo: $reportPath');
      }
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

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'general':
        return 'Tổng quát';
      case 'food':
        return 'Thực phẩm';
      case 'transport':
        return 'Giao thông';
      case 'shopping':
        return 'Mua sắm';
      case 'entertainment':
        return 'Giải trí';
      case 'utilities':
        return 'Tiện ích';
      case 'health':
        return 'Sức khỏe';
      case 'education':
        return 'Giáo dục';
      case 'travel':
        return 'Du lịch';
      case 'other':
        return 'Khác';
      default:
        return category;
    }
  }

  String _getPeriodDisplayName(String period) {
    switch (period) {
      case 'daily':
        return 'Hàng ngày';
      case 'weekly':
        return 'Hàng tuần';
      case 'monthly':
        return 'Hàng tháng';
      case 'yearly':
        return 'Hàng năm';
      case 'custom':
        return 'Tùy chỉnh';
      default:
        return period;
    }
  }
}
