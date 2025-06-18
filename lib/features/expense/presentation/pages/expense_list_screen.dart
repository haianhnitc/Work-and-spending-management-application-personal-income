import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_enums.dart';
import '../controllers/expense_controller.dart';
import 'create_expense_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseController controller = Get.find<ExpenseController>();
  final RxString _selectedCategory = RxString('');
  final RxString _timeFilter = RxString('month'); // week, month, year

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
            Obx(() => _selectedCategory.value.isNotEmpty
                ? Chip(
                    label: Text(_categoryToString(_selectedCategory.value),
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.white24,
                    onDeleted: () => _selectedCategory.value = '',
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
    final expenses = controller.expenses.where((expense) {
      final matchesCategory = _selectedCategory.value.isEmpty ||
          expense.category == _selectedCategory.value;
      final matchesTime = _filterByTime(expense.date);
      return matchesCategory && matchesTime;
    }).toList();
    final totalExpense = expenses
        .where((e) => e.amount < 0)
        .fold(0.0, (sum, e) => sum + e.amount.abs());
    final totalIncome = expenses
        .where((e) => e.amount > 0)
        .fold(0.0, (sum, e) => sum + e.amount);

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
                value: _timeFilter.value,
                items: [
                  DropdownMenuItem(value: 'week', child: Text('Tuần này')),
                  DropdownMenuItem(value: 'month', child: Text('Tháng này')),
                  DropdownMenuItem(value: 'year', child: Text('Năm nay')),
                ],
                onChanged: (value) => _timeFilter.value = value!,
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
              'Chi: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalExpense)}',
              style: Theme.of(context).textTheme.bodyMedium),
          Text(
              'Thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(totalIncome)}',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, bool isTablet) {
    final expenses = controller.expenses.where((expense) {
      final matchesTime = _filterByTime(expense.date);
      return matchesTime && expense.amount < 0;
    }).toList();

    final categoryTotals = <String, double>{};
    for (var category in Category.values) {
      categoryTotals[category.name] = expenses
          .where((e) => e.category == category.name)
          .fold(0.0, (sum, e) => sum + e.amount.abs());
    }

    final sections = categoryTotals.entries
        .toList()
        .asMap()
        .entries
        .map((entry) => PieChartSectionData(
              color: _getCategoryColor(entry.key),
              value: entry.value.value,
              title: _categoryToString(entry.value.key),
              radius: 50,
              titleStyle:
                  TextStyle(fontSize: isTablet ? 14 : 12, color: Colors.white),
            ))
        .toList();

    return Container(
      height: isTablet ? 200 : 150,
      padding: EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: sections.isEmpty
              ? [
                  PieChartSectionData(
                    color: Colors.grey,
                    value: 1,
                    title: 'Không có dữ liệu',
                    radius: 50,
                  )
                ]
              : sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  bool _filterByTime(DateTime date) {
    final now = DateTime.now();
    if (_timeFilter.value == 'week') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return date.isAfter(startOfWeek.subtract(Duration(days: 1)));
    } else if (_timeFilter.value == 'month') {
      return date.month == now.month && date.year == now.year;
    } else {
      return date.year == now.year;
    }
  }

  Widget _buildExpenseList(BuildContext context, String filter, bool isTablet) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      final expenses = controller.expenses.where((expense) {
        final matchesCategory = _selectedCategory.value.isEmpty ||
            expense.category == _selectedCategory.value;
        final matchesTime = _filterByTime(expense.date);
        if (filter == 'all') return matchesCategory && matchesTime;
        if (filter == 'necessary')
          return matchesCategory &&
              matchesTime &&
              expense.reason == Reason.necessary;
        if (filter == 'emotional')
          return matchesCategory &&
              matchesTime &&
              expense.reason == Reason.emotional;
        if (filter == 'reward')
          return matchesCategory &&
              matchesTime &&
              expense.reason == Reason.reward;
        return matchesCategory && matchesTime;
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
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              child: ListTile(
                leading: Text(
                  _getMoodEmoji(expense.mood),
                  style: TextStyle(fontSize: isTablet ? 24 : 20),
                ),
                title: Text(expense.title,
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(expense.amount.abs())}\nDanh mục: ${_categoryToString(expense.category)}\nNgày: ${DateFormat('dd/MM/yyyy').format(expense.date)}',
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
                  value: _selectedCategory.value.isEmpty
                      ? null
                      : _selectedCategory.value,
                  hint: Text('Tất cả danh mục'),
                  isExpanded: true,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                          value: category.name,
                          child: Text(_categoryToString(category.name))))
                      .toList(),
                  onChanged: (value) {
                    _selectedCategory.value = value ?? '';
                    Get.back();
                  },
                ),
                if (_selectedCategory.value.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      _selectedCategory.value = '';
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

  String _getMoodEmoji(Mood mood) {
    switch (mood) {
      case Mood.happy:
        return '😊';
      case Mood.neutral:
        return '😐';
      case Mood.sad:
        return '😞';
      default:
        return '😐';
    }
  }

  String _categoryToString(String category) {
    switch (category) {
      case 'study':
        return 'Học tập';
      case 'lifestyle':
        return 'Phong cách sống';
      case 'skill':
        return 'Kỹ năng';
      case 'entertainment':
        return 'Giải trí';
      default:
        return category;
    }
  }

  Color _getCategoryColor(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }
}
