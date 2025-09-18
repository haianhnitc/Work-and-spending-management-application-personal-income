import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/budget_controller.dart';
import '../../data/models/budget_model.dart';
import 'create_budget_screen.dart';
import 'budget_detail_screen.dart';

class BudgetListScreen extends StatelessWidget {
  final BudgetController _budgetController = Get.find<BudgetController>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Ngân Sách',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => Get.to(() => CreateBudgetScreen()),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _budgetController.loadBudgets(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _budgetController.loadBudgets(),
        child: Obx(() {
          if (_budgetController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (_budgetController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Lỗi: ${_budgetController.errorMessage.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _budgetController.loadBudgets(),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            children: [
              _buildOverviewCard(context, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              _buildBudgetStats(context, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              _buildBudgetList(context, isTablet),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateBudgetScreen()),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, bool isTablet) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assessment,
                    size: 24, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Tổng Quan Ngân Sách',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
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
                    'Tổng Ngân Sách',
                    '${_budgetController.totalBudgetAmount.toStringAsFixed(0)} VND',
                    Icons.account_balance_wallet,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Đã Chi',
                    '${_budgetController.totalSpentAmount.toStringAsFixed(0)} VND',
                    Icons.payment,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Còn Lại',
                    '${_budgetController.totalRemainingAmount.toStringAsFixed(0)} VND',
                    Icons.savings,
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: _budgetController.overallUsagePercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _budgetController.overallUsagePercentage >= 90
                    ? Colors.red
                    : _budgetController.overallUsagePercentage >= 80
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sử dụng: ${_budgetController.overallUsagePercentage.toStringAsFixed(1)}%',
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

  Widget _buildBudgetStats(BuildContext context, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Hoạt Động',
            '${_budgetController.activeBudgets.length}',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Gần Hết',
            '${_budgetController.budgetsNearLimit.length}',
            Icons.warning,
            Colors.orange,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Vượt Ngân Sách',
            '${_budgetController.overBudgetBudgets.length}',
            Icons.error,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildBudgetList(BuildContext context, bool isTablet) {
    if (_budgetController.budgets.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Chưa có ngân sách nào',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tạo ngân sách đầu tiên để bắt đầu quản lý chi tiêu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => CreateBudgetScreen()),
                icon: Icon(Icons.add),
                label: Text('Tạo Ngân Sách'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list, size: 20, color: Theme.of(context).primaryColor),
            SizedBox(width: 8),
            Text(
              'Danh Sách Ngân Sách',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ..._budgetController.budgets
            .map((budget) => _buildBudgetCard(context, budget, isTablet)),
      ],
    );
  }

  Widget _buildBudgetCard(
      BuildContext context, BudgetModel budget, bool isTablet) {
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
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => Get.to(() => BudgetDetailScreen(budget: budget)),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.name,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          budget.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 20),
                      SizedBox(height: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngân sách: ${budget.amount.toStringAsFixed(0)} VND',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Đã chi: ${budget.spentAmount.toStringAsFixed(0)} VND',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Còn lại: ${(budget.amount - budget.spentAmount).toStringAsFixed(0)} VND',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${usagePercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sử dụng',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              LinearProgressIndicator(
                value: usagePercentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${budget.startDate.day}/${budget.startDate.month} - ${budget.endDate.day}/${budget.endDate.month}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  if (budget.tags.isNotEmpty)
                    Text(
                      budget.tags.first,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3, end: 0);
  }
}
