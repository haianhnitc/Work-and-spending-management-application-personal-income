import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/widgets/chart_widgets.dart';
import '../controllers/expense_controller.dart';
import 'create_expense_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseController controller = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chi tiêu',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Obx(() => controller.selectedCategory.value.isNotEmpty
                ? Chip(
                    label: Text((controller.selectedCategory.value),
                        style: TextStyle(color: Colors.blueAccent)),
                    backgroundColor: Colors.white24,
                    onDeleted: () => controller.clearCategoryFilter(),
                  ).animate().fadeIn(duration: 200.ms)
                : SizedBox.shrink()),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white),
              onPressed: () => _showFilterDialog(context),
            ).animate().scale(duration: 200.ms),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Cần thiết'),
              Tab(text: 'Cảm xúc'),
              Tab(text: 'Tự thưởng'),
            ],
          ),
        ),
        body: Column(
          children: [
            Obx(() => _buildOverview(context, isTablet)),
            Obx(() => _buildPieChart(context, isTablet)),
            Expanded(
              child: TabBarView(
                children: [
                  _buildExpenseList(context, 'all', isTablet),
                  _buildExpenseList(context, 'necessary', isTablet),
                  _buildExpenseList(context, 'emotional', isTablet),
                  _buildExpenseList(context, 'reward', isTablet),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => CreateExpenseScreen()),
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Colors.white),
        ).animate().scale(duration: 200.ms),
      ),
    );
  }

  Widget _buildOverview(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 8),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng quan', style: Theme.of(context).textTheme.titleMedium),
              DropdownButton<String>(
                value: controller.timeFilter.value,
                items: [
                  DropdownMenuItem(value: 'week', child: Text('Tuần này')),
                  DropdownMenuItem(value: 'month', child: Text('Tháng này')),
                  DropdownMenuItem(value: 'year', child: Text('Năm nay')),
                ],
                onChanged: (value) => controller.setTimeFilter(value!),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
              'Chi: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(controller.totalExpense)}',
              style: Theme.of(context).textTheme.bodyMedium),
          Text(
              'Thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(controller.totalIncome)}',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, bool isTablet) {
    final categoryTotals = controller.categoryTotals;

    return Container(
      height: isTablet ? 280 : 230,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Fixed height container để layout luôn consistent
          Container(
            height: 24,
            child: Text(
              controller.selectedCategory.value.isNotEmpty 
                  ? 'Biểu đồ: ${controller.selectedCategory.value}'
                  : 'Biểu đồ chi tiêu theo danh mục',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          SizedBox(height: 8),
          // Chart Type Selector
          ChartSelector(
            selectedChartType: controller.selectedChartType.value,
            onChartTypeChanged: controller.setChartType,
            isTablet: isTablet,
          ),
          SizedBox(height: 12),
          // Chart Display
          Expanded(
            child: _buildSelectedChart(context, categoryTotals, isTablet),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildSelectedChart(BuildContext context, Map<String, double> categoryTotals, bool isTablet) {
    switch (controller.selectedChartType.value) {
      case ChartType.pie:
        return CustomPieChart(
          categoryTotals: categoryTotals,
          isTablet: isTablet,
        );
      case ChartType.bar:
        return CustomBarChart(
          categoryTotals: categoryTotals,
          isTablet: isTablet,
        );
      case ChartType.line:
        return CustomLineChart(
          categoryTotals: categoryTotals,
          isTablet: isTablet,
        );
    }
  }

  Widget _buildExpenseList(BuildContext context, String filter, bool isTablet) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      final expenses = controller.filteredExpenses.where((expense) {
        if (filter == 'all') return true;
        if (filter == 'necessary') {
          return expense.reason == Reason.necessary;
        }
        if (filter == 'emotional') {
          return expense.reason == Reason.emotional;
        }
        if (filter == 'reward') {
          return expense.reason == Reason.reward;
        }
        return true;
      }).toList();

      if (expenses.isEmpty) {
        return Center(child: Text('Không có giao dịch'));
      }

      return ListView.builder(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Dismissible(
            key: Key(expense.id),
            onDismissed: (direction) => controller.deleteExpense(expense.id),
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              child: ListTile(
                leading: Text(
                  getMoodEmoji(expense.mood, false),
                  style: TextStyle(fontSize: isTablet ? 24 : 20),
                ),
                title: Text(expense.title,
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(expense.amount.abs())}\nDanh mục: ${(expense.category)}\nNgày: ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(Icons.arrow_forward,
                    color: Theme.of(context).primaryColor),
                onTap: () => Get.toNamed('/expense-detail',
                    arguments: {'expense': expense}),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms, delay: (100 * index).ms);
        },
      );
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lọc theo danh mục'),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  hint: Text('Tất cả danh mục'),
                  isExpanded: true,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                          value: categoryToString(category.name),
                          child: Text(categoryToString(category))))
                      .toList(),
                  onChanged: (value) {
                    controller.setCategoryFilter(value ?? '');
                    Get.back();
                  },
                ),
                if (controller.selectedCategory.value.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      controller.clearCategoryFilter();
                      Get.back();
                    },
                    child:
                        Text('Xóa bộ lọc', style: TextStyle(color: Colors.red)),
                  ),
              ],
            )),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
