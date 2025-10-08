import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';
import '../../../task/presentation/controllers/task_controller.dart';
import '../../../budget/presentation/controllers/budget_controller.dart';
import '../../../../routes/main_screen.dart';
import '../../../../core/constants/app_enums.dart';

class HomeController extends GetxController {
  late ExpenseController expenseController;
  late TaskController taskController;
  late MainController mainController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    try {
      expenseController = Get.find<ExpenseController>();
      taskController = Get.find<TaskController>();
      mainController = Get.find<MainController>();
    } catch (e) {
      print('Error initializing controllers: $e');
    }
  }

  List<Map<String, dynamic>> getSmartInsights() {
    final insights = <Map<String, dynamic>>[];
    final now = DateTime.now();

    try {
      final totalTasks = taskController.tasks.length;
      final completedTasks =
          taskController.tasks.where((t) => t.isCompleted).length;

      if (totalTasks > 0) {
        final completionRate = (completedTasks / totalTasks * 100);
        if (completionRate < 50) {
          insights.add({
            'icon': Icons.trending_down,
            'color': Colors.orange,
            'title': 'Tỷ lệ hoàn thành thấp',
            'message':
                'Chỉ ${completionRate.toStringAsFixed(0)}% nhiệm vụ được hoàn thành. Hãy tập trung hơn!',
            'actionText': 'Xem nhiệm vụ',
            'action': () => mainController.changeTab(1),
          });
        } else if (completionRate > 80) {
          insights.add({
            'icon': Icons.trending_up,
            'color': Colors.green,
            'title': 'Hiệu suất tuyệt vời',
            'message':
                '${completionRate.toStringAsFixed(0)}% nhiệm vụ đã hoàn thành. Bạn đang làm rất tốt!',
            'actionText': 'Tiếp tục',
            'action': () {},
          });
        }
      }

      final overdueTasks = taskController.tasks
          .where((t) => !t.isCompleted && t.dueDate.isBefore(now))
          .length;

      if (overdueTasks > 0) {
        insights.add({
          'icon': Icons.warning,
          'color': Colors.red,
          'title': 'Nhiệm vụ quá hạn',
          'message': 'Bạn có $overdueTasks nhiệm vụ đã quá hạn cần xử lý.',
          'actionText': 'Xem ngay',
          'action': () => mainController.changeTab(1),
        });
      }

      final thisMonthExpenses = expenseController.expenses
          .where((e) =>
              e.date.month == now.month &&
              e.date.year == now.year &&
              e.incomeType == IncomeType.none)
          .fold<double>(0, (sum, e) => sum + e.amount);

      final lastMonth = DateTime(now.year, now.month - 1, now.day);
      final lastMonthExpenses = expenseController.expenses
          .where((e) =>
              e.date.month == lastMonth.month &&
              e.date.year == lastMonth.year &&
              e.incomeType == IncomeType.none)
          .fold<double>(0, (sum, e) => sum + e.amount);

      if (thisMonthExpenses > lastMonthExpenses * 1.2 &&
          lastMonthExpenses > 0) {
        final increasePercent =
            ((thisMonthExpenses - lastMonthExpenses) / lastMonthExpenses * 100);
        insights.add({
          'icon': Icons.warning,
          'color': Colors.red,
          'title': 'Chi tiêu tăng cao',
          'message':
              'Chi tiêu tháng này tăng ${increasePercent.toStringAsFixed(0)}% so với tháng trước.',
          'actionText': 'Xem chi tiêu',
          'action': () => mainController.changeTab(2),
        });
      } else if (thisMonthExpenses < lastMonthExpenses * 0.8 &&
          lastMonthExpenses > 0) {
        final decreasePercent =
            ((lastMonthExpenses - thisMonthExpenses) / lastMonthExpenses * 100);
        insights.add({
          'icon': Icons.trending_down,
          'color': Colors.green,
          'title': 'Chi tiêu giảm',
          'message':
              'Tuyệt vời! Chi tiêu tháng này giảm ${decreasePercent.toStringAsFixed(0)}% so với tháng trước.',
          'actionText': 'Xem báo cáo',
          'action': () => _showReportsDialog(),
        });
      }

      final todayExpenses = expenseController.expenses
          .where((e) =>
              e.date.day == now.day &&
              e.date.month == now.month &&
              e.date.year == now.year &&
              e.incomeType == IncomeType.none)
          .toList();

      if (todayExpenses.isEmpty && insights.length < 2) {
        insights.add({
          'icon': Icons.savings,
          'color': Colors.green,
          'title': 'Ngày không chi tiêu',
          'message': 'Tuyệt vời! Hôm nay bạn chưa có khoản chi tiêu nào.',
          'actionText': 'Tiếp tục',
          'action': () {},
        });
      }
    } catch (e) {
      print('Error generating insights: $e');
    }

    return insights;
  }

  Map<String, dynamic> getTodayOverview() {
    final now = DateTime.now();

    final todayExpenses = expenseController.expenses
        .where((e) =>
            e.date.day == now.day &&
            e.date.month == now.month &&
            e.date.year == now.year &&
            e.incomeType == IncomeType.none)
        .fold<double>(0, (sum, e) => sum + e.amount);

    final todayIncome = expenseController.expenses
        .where((e) =>
            e.date.day == now.day &&
            e.date.month == now.month &&
            e.date.year == now.year &&
            e.incomeType != IncomeType.none)
        .fold<double>(0, (sum, e) => sum + e.amount);

    final todayTasks = taskController.tasks
        .where((t) =>
            t.dueDate.day == now.day &&
            t.dueDate.month == now.month &&
            t.dueDate.year == now.year)
        .length;

    final completedTodayTasks = taskController.tasks
        .where((t) =>
            t.dueDate.day == now.day &&
            t.dueDate.month == now.month &&
            t.dueDate.year == now.year &&
            t.isCompleted)
        .length;

    return {
      'todayExpenses': todayExpenses,
      'todayIncome': todayIncome,
      'todayTasks': todayTasks,
      'completedTodayTasks': completedTodayTasks,
    };
  }

  Map<String, dynamic> getFinancialSummary() {
    final now = DateTime.now();

    final thisMonthExpenses = expenseController.expenses
        .where((e) =>
            e.date.month == now.month &&
            e.date.year == now.year &&
            e.incomeType == IncomeType.none)
        .fold<double>(0, (sum, e) => sum + e.amount);

    final thisMonthIncome = expenseController.expenses
        .where((e) =>
            e.date.month == now.month &&
            e.date.year == now.year &&
            e.incomeType != IncomeType.none)
        .fold<double>(0, (sum, e) => sum + e.amount);

    double currentBudget = 0.0;
    double totalSpentFromBudget = 0.0;
    try {
      final budgetController = Get.find<BudgetController>();
      if (budgetController.budgets.isNotEmpty) {
        final recentBudgets = budgetController.budgets
            .where((budget) =>
                budget.startDate.month == now.month &&
                budget.startDate.year == now.year &&
                budget.isActive)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        final top3RecentBudgets = recentBudgets.take(3).toList();

        currentBudget =
            top3RecentBudgets.fold(0.0, (sum, budget) => sum + budget.amount);
        totalSpentFromBudget = top3RecentBudgets.fold(
            0.0, (sum, budget) => sum + budget.spentAmount);
      }
    } catch (e) {
      print('Budget controller not found: $e');
    }

    final remainingBudget = currentBudget - totalSpentFromBudget;

    return {
      'thisMonthExpenses': thisMonthExpenses,
      'thisMonthIncome': thisMonthIncome,
      'currentBudget': currentBudget,
      'remainingBudget': remainingBudget,
      'budgetSpentAmount': totalSpentFromBudget,
    };
  }

  List<Map<String, dynamic>> getRecentActivities() {
    final recentTasks = taskController.tasks
        .where((task) => task.isCompleted)
        .toList()
      ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

    final recentExpenses = List.from(expenseController.expenses)
      ..sort((a, b) => b.date.compareTo(a.date));

    final recentActivities = <Map<String, dynamic>>[];

    for (var task in recentTasks.take(3)) {
      recentActivities.add({
        'type': 'task',
        'title': task.title,
        'subtitle': 'Hoàn thành - ${task.category}',
        'date': task.dueDate,
        'icon': Icons.check_circle,
        'color': Colors.green,
      });
    }

    for (var expense in recentExpenses.take(3)) {
      recentActivities.add({
        'type': 'expense',
        'title': NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
            .format(expense.amount),
        'subtitle': expense.title.isEmpty ? expense.category : expense.title,
        'date': expense.date,
        'icon': expense.incomeType == IncomeType.none
            ? Icons.trending_down
            : Icons.trending_up,
        'color':
            expense.incomeType == IncomeType.none ? Colors.red : Colors.green,
      });
    }

    recentActivities.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return recentActivities.take(5).toList();
  }

  Map<String, double> getMonthlyExpensesByCategory() {
    final now = DateTime.now();
    final categoryAmounts = <String, double>{};

    final monthlyExpenses = expenseController.expenses.where((expense) =>
        expense.date.month == now.month &&
        expense.date.year == now.year &&
        expense.incomeType == IncomeType.none);

    for (final expense in monthlyExpenses) {
      categoryAmounts[expense.category] =
          (categoryAmounts[expense.category] ?? 0) + expense.amount;
    }

    return categoryAmounts;
  }

  void navigateToExpenses() => mainController.changeTab(2);
  void navigateToTasks() => mainController.changeTab(1);
  void navigateToBudget() => mainController.changeTab(3);

  void navigateToCreateTask() {
    Get.toNamed('/task-create');
  }

  void navigateToCreateExpense() {
    Get.toNamed('/expense-create', arguments: {'incomeType': IncomeType.none});
  }

  void navigateToCreateIncome() {
    Get.toNamed('/expense-create', arguments: {'incomeType': IncomeType.fixed});
  }

  void navigateToCreateBudget() {
    Get.toNamed('/budget-create');
  }

  void _showReportsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          height: Get.height * 0.8,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Báo cáo chi tiết',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: Colors.teal,
                        labelColor: Colors.teal[800],
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: 'Chi tiêu'),
                          Tab(text: 'Nhiệm vụ'),
                          Tab(text: 'Ngân sách'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Center(child: Text('Báo cáo chi tiêu')),
                            Center(child: Text('Báo cáo nhiệm vụ')),
                            Center(child: Text('Báo cáo ngân sách')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAllActivities() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          height: Get.height * 0.8,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tất cả hoạt động',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: _buildAllActivitiesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllActivitiesList() {
    final activities = getRecentActivities();

    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có hoạt động nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tạo nhiệm vụ hoặc chi tiêu để xem hoạt động',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isTask = activity['type'] == 'task';

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isTask ? Colors.blue : Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isTask ? Icons.task_alt : Icons.payment,
                color: isTask ? Colors.blue : Colors.red,
                size: 24,
              ),
            ),
            title: Text(
              activity['title'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                if (activity['description'] != null &&
                    activity['description'].isNotEmpty)
                  Text(
                    activity['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Text(
                      activity['time'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (activity['amount'] != null) ...[
                      Spacer(),
                      Text(
                        activity['amount'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: isTask
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: activity['completed'] == true
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity['completed'] == true
                          ? 'Hoàn thành'
                          : 'Chưa xong',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: activity['completed'] == true
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
