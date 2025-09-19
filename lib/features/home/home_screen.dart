import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:task_expense_manager/features/ai/ai_suggestion_widget.dart';
import 'package:task_expense_manager/routes/main_screen.dart';
import '../../core/constants/app_enums.dart';
import '../expense/presentation/controllers/expense_controller.dart';
import '../task/presentation/controllers/task_controller.dart';
import '../budget/presentation/controllers/budget_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find<ExpenseController>();
    final TaskController taskController = Get.find<TaskController>();
    final MainController mainController = Get.find<MainController>();
    final isTablet = MediaQuery.of(context).size.width > 600;

    BudgetController? budgetController;
    try {
      budgetController = Get.find<BudgetController>();
    } catch (e) {
      budgetController = null;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào! 👋',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3, end: 0),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.notifications_none,
                    color: Colors.white, size: 24),
              ),
              onPressed: () {
                Get.snackbar('Thông báo', 'Chức năng đang phát triển!');
              },
            ),
          ).animate().scale(duration: 200.ms, delay: 300.ms),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.toNamed('/profile'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ).animate().scale(duration: 200.ms, delay: 400.ms),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE3F2FD),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            taskController.fetchTasks();
            expenseController.fetchExpenses();
          },
          child: ListView(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            children: [
              _buildTodayOverview(
                  context, taskController, expenseController, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              _buildFinancialSummary(
                  context, expenseController, budgetController, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              _buildSmartInsights(context, taskController, expenseController,
                  mainController, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              _buildQuickActions(context, mainController, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              InkWell(
                  onTap: () {
                    mainController.changeTab(5);
                  },
                  child: AISuggestionWidget()),
              SizedBox(height: isTablet ? 24 : 16),
              _buildRecentActivities(
                  context, taskController, expenseController, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              _buildUpcomingTasks(context, taskController, isTablet),
              SizedBox(height: isTablet ? 24 : 16),
              _buildMonthlyExpenseChart(context, expenseController, isTablet),
              SizedBox(height: isTablet ? 40 : 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(
      BuildContext context,
      ExpenseController controller,
      BudgetController? budgetController,
      bool isTablet) {
    return Obx(() {
      final totalIncome = controller.expenses
          .where((e) =>
              e.incomeType == IncomeType.fixed ||
              e.incomeType == IncomeType.variable)
          .fold(0.0, (sum, item) => sum + item.amount);
      final totalExpense = controller.expenses
          .where((e) => e.incomeType == IncomeType.none)
          .fold(0.0, (sum, item) => sum + item.amount);
      final balance = totalIncome - totalExpense;

      // Calculate monthly spending
      final now = DateTime.now();
      final thisMonth = controller.expenses
          .where((e) =>
              e.date.month == now.month &&
              e.date.year == now.year &&
              e.incomeType == IncomeType.none)
          .fold(0.0, (sum, item) => sum + item.amount);

      final lastMonth = controller.expenses
          .where((e) =>
              e.date.month == (now.month == 1 ? 12 : now.month - 1) &&
              e.date.year == (now.month == 1 ? now.year - 1 : now.year) &&
              e.incomeType == IncomeType.none)
          .fold(0.0, (sum, item) => sum + item.amount);

      final monthlyChange =
          lastMonth > 0 ? ((thisMonth - lastMonth) / lastMonth * 100) : 0.0;

      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF8EC5FC), Color(0xFF50C878)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
            ],
          ),
          padding: EdgeInsets.all(isTablet ? 28 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tài chính cá nhân',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                            .format(balance),
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Icon(
                      balance >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: isTablet ? 32 : 28,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 24 : 20),
              Row(
                children: [
                  Expanded(
                    child: _buildFinancialStat(
                      context,
                      Icons.arrow_downward,
                      'Chi tiêu',
                      totalExpense,
                      Colors.redAccent.shade100,
                      isTablet,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: _buildFinancialStat(
                      context,
                      Icons.arrow_upward,
                      'Thu nhập',
                      totalIncome,
                      Colors.greenAccent.shade100,
                      isTablet,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 20 : 16),
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chi tiêu tháng này',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                        Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                              .format(thisMonth),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: monthlyChange >= 0
                            ? Colors.red.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            monthlyChange >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: monthlyChange >= 0
                                ? Colors.red.shade300
                                : Colors.green.shade300,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${monthlyChange.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: monthlyChange >= 0
                                  ? Colors.red.shade300
                                  : Colors.green.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideX(
            begin: -0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildSmartInsights(
      BuildContext context,
      TaskController taskController,
      ExpenseController expenseController,
      MainController mainController,
      bool isTablet) {
    return Obx(() {
      final insights = <Map<String, dynamic>>[];
      final now = DateTime.now();

      final totalTasks = taskController.tasks.length;
      final completedTasks =
          taskController.tasks.where((t) => t.isCompleted).length;
      final completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

      if (completionRate < 0.5) {
        insights.add({
          'icon': Icons.trending_down,
          'color': Colors.orange,
          'title': 'Cải thiện hiệu suất',
          'message':
              'Bạn đã hoàn thành ${(completionRate * 100).toStringAsFixed(0)}% công việc. Hãy tập trung hoàn thành nhiều hơn!',
          'actionText': 'Xem công việc',
          'action': () => mainController.changeTab(1),
        });
      } else if (completionRate > 0.8) {
        insights.add({
          'icon': Icons.star,
          'color': Colors.green,
          'title': 'Xuất sắc!',
          'message':
              'Bạn đã hoàn thành ${(completionRate * 100).toStringAsFixed(0)}% công việc. Tiếp tục phát huy!',
          'actionText': 'Thêm công việc',
          'action': () =>
              Get.toNamed('/task-create', arguments: {'date': DateTime.now()}),
        });
      }

      final thisMonthExpenses = expenseController.expenses
          .where((e) =>
              e.date.month == now.month &&
              e.date.year == now.year &&
              e.incomeType == IncomeType.none)
          .fold(0.0, (sum, e) => sum + e.amount);

      final lastMonthExpenses = expenseController.expenses
          .where((e) =>
              e.date.month == (now.month == 1 ? 12 : now.month - 1) &&
              e.date.year == (now.month == 1 ? now.year - 1 : now.year) &&
              e.incomeType == IncomeType.none)
          .fold(0.0, (sum, e) => sum + e.amount);

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
          'action': () =>
              _showReportsDialog(context, expenseController, taskController),
        });
      }

      final overdueTasks = taskController.tasks
          .where((t) => !t.isCompleted && t.dueDate.isBefore(now))
          .length;

      if (overdueTasks > 0) {
        insights.add({
          'icon': Icons.schedule,
          'color': Colors.red,
          'title': 'Công việc quá hạn',
          'message':
              'Bạn có $overdueTasks công việc đã quá hạn. Hãy xử lý chúng sớm!',
          'actionText': 'Xem ngay',
          'action': () => mainController.changeTab(1),
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

      if (insights.isEmpty) {
        return SizedBox.shrink();
      }

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFF8E1),
                Color(0xFFFFECB3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb,
                      color: Colors.orange.shade700, size: isTablet ? 28 : 24),
                  SizedBox(width: 12),
                  Text(
                    'Thông tin thông minh',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Column(
                children: insights.take(2).map((insight) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(isTablet ? 16 : 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: (insight['color'] as Color).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (insight['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            insight['icon'] as IconData,
                            color: insight['color'] as Color,
                            size: isTablet ? 24 : 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insight['title'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: insight['color'] as Color,
                                    ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                insight['message'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (insight['action'] != null)
                          TextButton(
                            onPressed: insight['action'] as VoidCallback,
                            child: Text(
                              insight['actionText'] as String,
                              style: TextStyle(
                                color: insight['color'] as Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildFinancialStat(BuildContext context, IconData icon, String label,
      double amount, Color color, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: isTablet ? 24 : 20),
            SizedBox(width: isTablet ? 8 : 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 8 : 4),
        Text(
          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
      BuildContext context, MainController mainController, bool isTablet) {
    final actions = [
      {
        'icon': Icons.add_task_rounded,
        'label': 'Thêm công việc',
        'color': Color(0xFF6C63FF),
        'action': () =>
            Get.toNamed('/task-create', arguments: {'date': DateTime.now()}),
      },
      {
        'icon': Icons.attach_money_rounded,
        'label': 'Thêm giao dịch',
        'color': Color(0xFF00BFA5),
        'action': () =>
            Get.toNamed('/expense-create', arguments: {'date': DateTime.now()}),
      },
      {
        'icon': Icons.analytics_rounded,
        'label': 'Báo cáo',
        'color': Color(0xFFFF7043),
        'action': () => Get.snackbar('Thông báo', 'Chức năng đang phát triển!'),
      },
      {
        'icon': Icons.schedule_rounded,
        'label': 'Lịch trình',
        'color': Color(0xFF8E24AA),
        'action': () => mainController.changeTab(4),
      },
    ];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thao tác nhanh',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : 2,
                crossAxisSpacing: isTablet ? 16 : 12,
                mainAxisSpacing: isTablet ? 16 : 12,
                childAspectRatio: isTablet ? 1.2 : 1.4,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return InkWell(
                  onTap: action['action'] as VoidCallback,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (action['color'] as Color).withOpacity(0.8),
                          (action['color'] as Color).withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (action['color'] as Color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          action['icon'] as IconData,
                          size: isTablet ? 36 : 28,
                          color: Colors.white,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        Text(
                          action['label'] as String,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: (index * 100).ms).fadeIn().scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                    );
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideX(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
        );
  }

  Widget _buildTodayOverview(
      BuildContext context,
      TaskController taskController,
      ExpenseController expenseController,
      bool isTablet) {
    return Obx(() {
      final today = DateTime.now();

      final todayTasks = taskController.tasks
          .where((task) =>
              task.dueDate.day == today.day &&
              task.dueDate.month == today.month &&
              task.dueDate.year == today.year)
          .toList();

      final completedTasks =
          todayTasks.where((task) => task.isCompleted).length;
      final totalTasks = todayTasks.length;

      final todayExpenses = expenseController.expenses
          .where((expense) =>
              expense.date.day == today.day &&
              expense.date.month == today.month &&
              expense.date.year == today.year &&
              expense.incomeType == IncomeType.none)
          .toList();

      final todayTotal =
          todayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(isTablet ? 28 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.today,
                      color: Colors.white, size: isTablet ? 28 : 24),
                  SizedBox(width: 12),
                  Text(
                    'Hôm nay - ${DateFormat('dd/MM/yyyy').format(today)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 24 : 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTodayMetric(
                      context,
                      Icons.task_alt,
                      'Công việc',
                      '$completedTasks/$totalTasks',
                      totalTasks > 0 ? completedTasks / totalTasks : 0,
                      Colors.greenAccent.shade200,
                      isTablet,
                    ),
                  ),
                  SizedBox(width: isTablet ? 20 : 16),
                  Expanded(
                    child: _buildTodayMetric(
                      context,
                      Icons.payments,
                      'Chi tiêu',
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                          .format(todayTotal),
                      null,
                      Colors.orangeAccent.shade200,
                      isTablet,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms, delay: 50.ms).slideY(
            begin: -0.1,
            end: 0,
            duration: 400.ms,
          );
    });
  }

  Widget _buildTodayMetric(BuildContext context, IconData icon, String title,
      String value, double? progress, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: isTablet ? 24 : 20),
              SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (progress != null) ...[
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentActivities(
      BuildContext context,
      TaskController taskController,
      ExpenseController expenseController,
      bool isTablet) {
    return Obx(() {
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
          'subtitle': 'Hoàn thành - ${categoryToString(task.category)}',
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
          'subtitle': expense.title.isEmpty
              ? categoryToString(expense.category)
              : expense.title,
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
      final displayActivities = recentActivities.take(5).toList();

      if (displayActivities.isEmpty) {
        return _buildEmptyStateCard(
            context, 'Hoạt động gần đây', 'Chưa có hoạt động nào gần đây.');
      }

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hoạt động gần đây',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showAllActivities(
                          context, expenseController, taskController);
                    },
                    child: Text('Xem tất cả'),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayActivities.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final activity = displayActivities[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          (activity['color'] as Color).withOpacity(0.1),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: isTablet ? 24 : 20,
                      ),
                    ),
                    title: Text(
                      activity['title'] as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Text(
                      activity['subtitle'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Text(
                      DateFormat('dd/MM HH:mm')
                          .format(activity['date'] as DateTime),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 250.ms).slideX(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildUpcomingTasks(
      BuildContext context, TaskController controller, bool isTablet) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingCard(context, 'Công việc sắp tới');
      }

      final today = DateTime.now();
      final upcomingTasks = controller.tasks
          .where((task) =>
              !task.isCompleted &&
              (task.dueDate.isAfter(today.subtract(const Duration(days: 1))) &&
                  task.dueDate.isBefore(today.add(const Duration(days: 7)))))
          .toList();

      if (upcomingTasks.isEmpty) {
        return _buildEmptyStateCard(
            context, 'Công việc sắp tới', 'Không có công việc nào gần đây.');
      }

      upcomingTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Công việc sắp tới',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingTasks.length > 3 ? 3 : upcomingTasks.length,
                itemBuilder: (context, index) {
                  final task = upcomingTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: isTablet ? 20 : 16, color: Colors.grey[600]),
                        SizedBox(width: isTablet ? 12 : 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Hạn: ${DateFormat('dd/MM').format(task.dueDate)} - ${categoryToString(task.category)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: isTablet ? 18 : 14, color: Colors.grey[400]),
                      ],
                    ),
                  );
                },
              ),
              if (upcomingTasks.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () => Get.toNamed('/task-list'),
                      child: Text(
                        'Xem tất cả công việc (${upcomingTasks.length})',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 300.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildEmptyStateCard(
      BuildContext context, String title, String message) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(Icons.info_outline, size: 50, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildLoadingCard(BuildContext context, String title) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildMonthlyExpenseChart(
      BuildContext context, ExpenseController controller, bool isTablet) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingCard(context, 'Biểu đồ chi tiêu hàng tháng');
      }

      final now = DateTime.now();
      final currentMonthExpenses = controller.expenses
          .where((e) =>
              e.date.month == now.month &&
              e.date.year == now.year &&
              e.incomeType == IncomeType.none)
          .toList();

      if (currentMonthExpenses.isEmpty) {
        return _buildEmptyStateCard(context, 'Biểu đồ chi tiêu hàng tháng',
            'Chưa có chi tiêu nào trong tháng này.');
      }

      final Map<String, double> categoryAmounts = {};
      for (var expense in currentMonthExpenses) {
        categoryAmounts.update(
            expense.category, (value) => value + expense.amount,
            ifAbsent: () => expense.amount);
      }

      final totalAmount =
          categoryAmounts.values.fold(0.0, (sum, amt) => sum + amt);

      List<PieChartSectionData> sections = [];
      int colorIndex = 0;
      categoryAmounts.forEach((category, amount) {
        final percentage = (amount / totalAmount * 100).toStringAsFixed(1);
        sections.add(
          PieChartSectionData(
            color: getCategoryColor(colorIndex++),
            value: amount,
            title: '$percentage%',
            radius: isTablet ? 70 : 50,
            titleStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            showTitle: true,
          ),
        );
      });

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chi tiêu hàng tháng',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              SizedBox(
                height: isTablet ? 250 : 200,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: isTablet ? 60 : 40,
                    sectionsSpace: 4,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildChartLegend(categoryAmounts, isTablet),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideY(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
          );
    });
  }

  Widget _buildChartLegend(Map<String, double> categoryAmounts, bool isTablet) {
    int colorIndex = 0;
    return Wrap(
      spacing: isTablet ? 16 : 12,
      runSpacing: isTablet ? 12 : 8,
      children: categoryAmounts.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isTablet ? 18 : 14,
              height: isTablet ? 18 : 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getCategoryColor(colorIndex++),
              ),
            ),
            SizedBox(width: isTablet ? 8 : 6),
            Text(
              categoryToString(entry.key),
              style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Hiển thị dialog báo cáo chi tiết
  void _showReportsDialog(BuildContext context,
      ExpenseController expenseController, TaskController taskController) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
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
                    onPressed: () => Navigator.pop(context),
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
                            _buildExpenseReport(expenseController),
                            _buildTaskReport(taskController),
                            _buildBudgetReport(expenseController),
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

  Widget _buildExpenseReport(ExpenseController expenseController) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thống kê tổng quan
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thống kê chi tiêu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Obx(() {
                    final thisMonthExpenses = expenseController.expenses
                        .where((e) =>
                            e.date.month == DateTime.now().month &&
                            e.date.year == DateTime.now().year)
                        .fold<double>(0, (sum, e) => sum + e.amount);

                    final lastMonthExpenses = expenseController.expenses
                        .where((e) =>
                            e.date.month ==
                                DateTime.now()
                                    .subtract(Duration(days: 30))
                                    .month &&
                            e.date.year ==
                                DateTime.now()
                                    .subtract(Duration(days: 30))
                                    .year)
                        .fold<double>(0, (sum, e) => sum + e.amount);

                    final totalExpenses = expenseController.expenses
                        .fold<double>(0, (sum, e) => sum + e.amount);

                    return Column(
                      children: [
                        _buildStatRow('Tháng này:',
                            '${NumberFormat('#,###', 'vi').format(thisMonthExpenses)}₫'),
                        _buildStatRow('Tháng trước:',
                            '${NumberFormat('#,###', 'vi').format(lastMonthExpenses)}₫'),
                        _buildStatRow('Tổng cộng:',
                            '${NumberFormat('#,###', 'vi').format(totalExpenses)}₫'),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Biểu đồ chi tiêu theo danh mục
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chi tiêu theo danh mục',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 200,
                    child: Obx(() {
                      final categoryExpenses = <String, double>{};
                      for (final expense in expenseController.expenses) {
                        categoryExpenses[expense.category] =
                            (categoryExpenses[expense.category] ?? 0) +
                                expense.amount;
                      }

                      if (categoryExpenses.isEmpty) {
                        return Center(child: Text('Chưa có dữ liệu chi tiêu'));
                      }

                      return ListView.builder(
                        itemCount: categoryExpenses.length,
                        itemBuilder: (context, index) {
                          final entry =
                              categoryExpenses.entries.elementAt(index);
                          final total = categoryExpenses.values
                              .fold<double>(0, (sum, amount) => sum + amount);
                          final percentage = (entry.value / total * 100);

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(entry.key,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      '${NumberFormat('#,###', 'vi').format(entry.value)}₫'),
                                ),
                                Expanded(
                                  child:
                                      Text('${percentage.toStringAsFixed(1)}%'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskReport(TaskController taskController) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thống kê nhiệm vụ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Obx(() {
                    final totalTasks = taskController.tasks.length;
                    final completedTasks =
                        taskController.tasks.where((t) => t.isCompleted).length;
                    final overdueTasks = taskController.tasks
                        .where((t) =>
                            !t.isCompleted &&
                            t.dueDate.isBefore(DateTime.now()))
                        .length;

                    final completionRate = totalTasks > 0
                        ? (completedTasks / totalTasks * 100)
                        : 0.0;

                    return Column(
                      children: [
                        _buildStatRow('Tổng nhiệm vụ:', '$totalTasks'),
                        _buildStatRow('Đã hoàn thành:', '$completedTasks'),
                        _buildStatRow('Quá hạn:', '$overdueTasks'),
                        _buildStatRow('Tỷ lệ hoàn thành:',
                            '${completionRate.toStringAsFixed(1)}%'),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Nhiệm vụ sắp tới hạn
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhiệm vụ sắp tới hạn',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 200,
                    child: Obx(() {
                      final upcomingTasks = taskController.tasks
                          .where((t) =>
                              !t.isCompleted &&
                              t.dueDate.isAfter(DateTime.now()) &&
                              t.dueDate.isBefore(
                                  DateTime.now().add(Duration(days: 7))))
                          .toList()
                        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

                      if (upcomingTasks.isEmpty) {
                        return Center(
                            child: Text('Không có nhiệm vụ sắp tới hạn'));
                      }

                      return ListView.builder(
                        itemCount: upcomingTasks.length,
                        itemBuilder: (context, index) {
                          final task = upcomingTasks[index];
                          final daysUntilDue =
                              task.dueDate.difference(DateTime.now()).inDays;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Icon(
                                Icons.schedule,
                                color: daysUntilDue <= 1
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                              title: Text(task.title),
                              subtitle: Text(
                                'Còn $daysUntilDue ngày',
                                style: TextStyle(
                                  color: daysUntilDue <= 1
                                      ? Colors.red
                                      : Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                DateFormat('dd/MM').format(task.dueDate),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetReport(ExpenseController expenseController) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phân tích ngân sách',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Obx(() {
                    try {
                      final budgetController = Get.find<BudgetController>();
                      final currentBudget = budgetController.budgets.isNotEmpty
                          ? budgetController.budgets.first.amount
                          : 0.0;
                      final thisMonthExpenses = expenseController.expenses
                          .where((e) =>
                              e.date.month == DateTime.now().month &&
                              e.date.year == DateTime.now().year)
                          .fold<double>(0, (sum, e) => sum + e.amount);

                      final remainingBudget = currentBudget - thisMonthExpenses;
                      final budgetUsagePercent = currentBudget > 0
                          ? (thisMonthExpenses / currentBudget * 100)
                          : 0.0;

                      return Column(
                        children: [
                          _buildStatRow('Ngân sách tháng:',
                              '${NumberFormat('#,###', 'vi').format(currentBudget)}₫'),
                          _buildStatRow('Đã chi tiêu:',
                              '${NumberFormat('#,###', 'vi').format(thisMonthExpenses)}₫'),
                          _buildStatRow('Còn lại:',
                              '${NumberFormat('#,###', 'vi').format(remainingBudget)}₫'),
                          _buildStatRow('Tỷ lệ sử dụng:',
                              '${budgetUsagePercent.toStringAsFixed(1)}%'),
                        ],
                      );
                    } catch (e) {
                      return Text('Chưa thiết lập ngân sách');
                    }
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Cảnh báo ngân sách
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cảnh báo ngân sách',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Obx(() {
                    try {
                      final budgetController = Get.find<BudgetController>();
                      final currentBudget = budgetController.budgets.isNotEmpty
                          ? budgetController.budgets.first.amount
                          : 0.0;
                      final thisMonthExpenses = expenseController.expenses
                          .where((e) =>
                              e.date.month == DateTime.now().month &&
                              e.date.year == DateTime.now().year)
                          .fold<double>(0, (sum, e) => sum + e.amount);

                      if (currentBudget <= 0) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Hãy thiết lập ngân sách để theo dõi chi tiêu hiệu quả hơn.',
                                  style: TextStyle(color: Colors.blue.shade800),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final budgetUsagePercent =
                          thisMonthExpenses / currentBudget * 100;

                      if (budgetUsagePercent >= 100) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Cảnh báo: Bạn đã vượt quá ngân sách tháng này!',
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (budgetUsagePercent >= 80) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.orange),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Chú ý: Bạn đã sử dụng ${budgetUsagePercent.toStringAsFixed(1)}% ngân sách tháng này.',
                                  style:
                                      TextStyle(color: Colors.orange.shade800),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tốt lắm! Bạn đang quản lý ngân sách rất tốt.',
                                  style:
                                      TextStyle(color: Colors.green.shade800),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      return Text('Không thể tải thông tin ngân sách');
                    }
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal[700])),
        ],
      ),
    );
  }

  // Hiển thị tất cả hoạt động gần đây
  void _showAllActivities(BuildContext context,
      ExpenseController expenseController, TaskController taskController) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
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
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Bộ lọc
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, size: 20),
                    SizedBox(width: 8),
                    Text('Lọc theo:'),
                    SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          FilterChip(
                            label: Text('Tất cả'),
                            selected: true,
                            onSelected: (selected) {},
                          ),
                          SizedBox(width: 8),
                          FilterChip(
                            label: Text('Chi tiêu'),
                            selected: false,
                            onSelected: (selected) {},
                          ),
                          SizedBox(width: 8),
                          FilterChip(
                            label: Text('Nhiệm vụ'),
                            selected: false,
                            onSelected: (selected) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: Obx(() {
                  // Kết hợp và sắp xếp các hoạt động
                  final activities = <Map<String, dynamic>>[];

                  // Thêm chi tiêu
                  for (final expense in expenseController.expenses) {
                    activities.add({
                      'type': 'expense',
                      'date': expense.date,
                      'title': expense.title,
                      'amount': expense.amount,
                      'category': expense.category,
                      'icon': Icons.money_off,
                      'color': Colors.red,
                    });
                  }

                  // Thêm nhiệm vụ
                  for (final task in taskController.tasks) {
                    activities.add({
                      'type': 'task',
                      'date': task
                          .createdAt, // Sử dụng createdAt thay vì createdDate
                      'title': task.title,
                      'isCompleted': task.isCompleted,
                      'category': task.category,
                      'dueDate': task.dueDate,
                      'icon': task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      'color': task.isCompleted ? Colors.green : Colors.blue,
                    });
                  }

                  // Sắp xếp theo thời gian mới nhất
                  activities.sort((a, b) =>
                      (b['date'] as DateTime).compareTo(a['date'] as DateTime));

                  if (activities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Chưa có hoạt động nào',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final isExpense = activity['type'] == 'expense';

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor:
                                (activity['color'] as Color).withOpacity(0.1),
                            child: Icon(
                              activity['icon'] as IconData,
                              color: activity['color'] as Color,
                            ),
                          ),
                          title: Text(
                            activity['title'] as String,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isExpense) ...[
                                Text('Danh mục: ${activity['category']}'),
                                Text(
                                  '${NumberFormat('#,###', 'vi').format(activity['amount'])}₫',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ] else ...[
                                Text(activity['isCompleted']
                                    ? 'Đã hoàn thành'
                                    : 'Chưa hoàn thành'),
                                if (!activity['isCompleted'])
                                  Text(
                                    'Hạn: ${DateFormat('dd/MM/yyyy').format(activity['dueDate'])}',
                                    style: TextStyle(
                                      color: (activity['dueDate'] as DateTime)
                                              .isBefore(DateTime.now())
                                          ? Colors.red
                                          : Colors.orange,
                                    ),
                                  ),
                              ],
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(activity['date'] as DateTime),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: isExpense
                              ? Icon(Icons.arrow_forward_ios, size: 16)
                              : Icon(
                                  activity['isCompleted']
                                      ? Icons.check_circle
                                      : Icons.schedule,
                                  color: activity['isCompleted']
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
