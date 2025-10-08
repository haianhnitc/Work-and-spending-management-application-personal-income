import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/widgets/chart_widgets.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../controllers/expense_controller.dart';
import 'create_expense_screen.dart';
import '../../../../core/utils/snackbar_helper.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseController controller = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: CommonAppBar(
          title: 'Tài chính',
          type: AppBarType.primary,
          actions: [
            Obx(() => controller.selectedCategory.value.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(
                        controller.selectedCategory.value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      deleteIconColor: Colors.white,
                      onDeleted: () => controller.clearCategoryFilter(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                : SizedBox.shrink()),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 150,
                    kToolbarHeight,
                    0,
                    0,
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'filter',
                      child: Row(
                        children: [
                          Icon(Icons.tune, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Lọc danh mục'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.file_download, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Xuất báo cáo'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Chia sẻ tổng hợp'),
                        ],
                      ),
                    ),
                  ],
                ).then((value) {
                  if (value != null) {
                    switch (value) {
                      case 'filter':
                        _showFilterDialog(context);
                        break;
                      case 'export':
                        Get.toNamed('/reports');
                        break;
                      case 'share':
                        _shareExpensesSummary();
                        break;
                    }
                  }
                });
              },
            ),
          ],
          bottom: TabBar(
            padding: EdgeInsets.zero,
            labelColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.onSurface
                : Colors.white,
            unselectedLabelColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                    : Colors.white70,
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.onSurface
                : Colors.white,
            indicatorWeight: 3,
            isScrollable: true,
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Chi tiêu'),
              Tab(text: 'Thu nhập'),
              Tab(text: 'Cần thiết'),
              Tab(text: 'Cảm xúc '),
              Tab(text: 'Tự thưởng'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildOverview(context, isTablet),
            _buildPieChart(context, isTablet),
            Expanded(
              child: TabBarView(
                children: [
                  _buildExpenseList(context, 'all', isTablet),
                  _buildExpenseList(context, 'expense', isTablet),
                  _buildExpenseList(context, 'income', isTablet),
                  _buildExpenseList(context, 'necessary', isTablet),
                  _buildExpenseList(context, 'emotional', isTablet),
                  _buildExpenseList(context, 'reward', isTablet),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "expense_fab",
          onPressed: () => _showCreateOptionsBottomSheet(context),
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Colors.white),
        ).animate().scale(duration: 200.ms),
      ),
    );
  }

  Widget _buildOverview(BuildContext context, bool isTablet) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(isTablet ? 16 : 8),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => controller.toggleOverview(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Tổng quan',
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(width: 8),
                      Icon(
                        controller.isOverviewExpanded.value
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ],
                  ),
                  if (controller.isOverviewExpanded.value)
                    DropdownButton<String>(
                      value: controller.timeFilter.value,
                      items: [
                        DropdownMenuItem(
                            value: 'week', child: Text('Tuần này')),
                        DropdownMenuItem(
                            value: 'month', child: Text('Tháng này')),
                        DropdownMenuItem(value: 'year', child: Text('Năm nay')),
                      ],
                      onChanged: (value) => controller.setTimeFilter(value!),
                    ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: controller.isOverviewExpanded.value ? null : 0,
              child: controller.isOverviewExpanded.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.red.withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.trending_down,
                                            color: Colors.red, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'Chi tiêu',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'VNĐ')
                                          .format(controller.totalExpense),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.trending_up,
                                            color: Colors.green, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'Thu nhập',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'VNĐ')
                                          .format(controller.totalIncome),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Số dư:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: 'vi_VN', symbol: 'VNĐ')
                                    .format(controller.totalIncome -
                                        controller.totalExpense),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: (controller.totalIncome -
                                                  controller.totalExpense) >=
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPieChart(BuildContext context, bool isTablet) {
    return Obx(() {
      final categoryTotals = controller.categoryTotals;

      return Container(
        height: isTablet ? 280 : 230,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
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
            ChartSelector(
              selectedChartType: controller.selectedChartType.value,
              onChartTypeChanged: controller.setChartType,
              isTablet: isTablet,
            ),
            SizedBox(height: 12),
            Expanded(
              child: _buildSelectedChart(context, categoryTotals, isTablet),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms);
    });
  }

  Widget _buildSelectedChart(
      BuildContext context, Map<String, double> categoryTotals, bool isTablet) {
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
        if (filter == 'expense') {
          return expense.incomeType == IncomeType.none;
        }
        if (filter == 'income') {
          return expense.incomeType != IncomeType.none;
        }
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                filter == 'income'
                    ? Icons.add_circle_outline
                    : filter == 'expense'
                        ? Icons.remove_circle_outline
                        : Icons.list,
                size: 64,
                color: Colors.grey[400],
              ).animate().scale(duration: 500.ms),
              SizedBox(height: 16),
              Text(
                filter == 'income'
                    ? 'Chưa có thủ nhập nào'
                    : filter == 'expense'
                        ? 'Chưa có khi tiêu nào'
                        : 'Không có giao dịch',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
              SizedBox(height: 8),
              Text(
                filter == 'income'
                    ? 'Thêm nguồn thu nhập đầu tiên của bạn!'
                    : filter == 'expense'
                        ? 'Thêm khoản chi tiêu đầu tiên của bạn!'
                        : 'Bắt đầu ghi chép tài chính của bạn!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        itemCount: expenses.length,
        reverse: true,
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
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: expense.incomeType != IncomeType.none
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    expense.incomeType != IncomeType.none
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: expense.incomeType != IncomeType.none
                        ? Colors.green
                        : Colors.red,
                    size: 20,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        expense.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Text(
                      getMoodEmoji(expense.mood, false),
                      style: TextStyle(fontSize: isTablet ? 20 : 16),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          expense.incomeType != IncomeType.none ? '+' : '-',
                          style: TextStyle(
                            color: expense.incomeType != IncomeType.none
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                              .format(expense.amount.abs()),
                          style: TextStyle(
                            color: expense.incomeType != IncomeType.none
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (expense.incomeType != IncomeType.none) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: Colors.green, width: 0.5),
                            ),
                            child: Text(
                              expense.incomeType == IncomeType.fixed
                                  ? 'Cố đinh'
                                  : 'Biến động',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${expense.category} • ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  size: 16,
                ),
                onTap: () => Get.toNamed('/expense-detail',
                    arguments: {'expenseId': expense.id}),
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

  void _showCreateOptionsBottomSheet(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thêm giao dịch mới',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isTablet ? 28 : 22,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: isTablet ? 30 : 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.to(() => CreateExpenseScreen(),
                          arguments: {'incomeType': IncomeType.none});
                    },
                    icon: Icon(Icons.remove_circle_outline,
                        color: Colors.white, size: isTablet ? 30 : 24),
                    label: Text('Thêm chi tiêu',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 18 : 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, isTablet ? 60 : 50),
                    ),
                  ).animate().scale(duration: 200.ms, delay: 100.ms),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.to(() => CreateExpenseScreen(),
                          arguments: {'incomeType': IncomeType.fixed});
                    },
                    icon: Icon(Icons.add_circle_outline,
                        color: Colors.white, size: isTablet ? 30 : 24),
                    label: Text('Thêm thu nhập',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 18 : 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, isTablet ? 60 : 50),
                    ),
                  ).animate().scale(duration: 200.ms, delay: 200.ms),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _shareExpensesSummary() async {
    try {
      final filteredExpenses = controller.filteredExpenses;

      // Safe type conversion for financial calculations
      final totalExpense = controller.totalExpense.toDouble();
      final totalIncome = controller.totalIncome.toDouble();
      final balance = totalIncome - totalExpense;

      // Safe currency formatting with explicit double values
      final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
      final formattedIncome = formatter.format(totalIncome);
      final formattedExpense = formatter.format(totalExpense);
      final formattedBalance = formatter.format(balance);

      final summary = '''
📊 TỔNG HỢP TÀI CHÍNH

💰 Thu nhập: $formattedIncome
💸 Chi tiêu: $formattedExpense
💵 Số dư: $formattedBalance

📈 Số giao dịch: ${filteredExpenses.length}
📅 Khoảng thời gian: ${controller.timeFilter.value}

${balance >= 0 ? '✅ Tài chính ổn định' : '⚠️ Cần tiết kiệm'}

Được tạo bởi Task & Expense Manager
''';

      await Share.share(summary);
    } catch (e) {
      // Provide more detailed error information
      print('Error sharing expense summary: $e');
      SnackbarHelper.showError('Không thể chia sẻ: $e');

      // Try fallback simple share
      try {
        const fallbackSummary = '''
📊 TỔNG HỢP TÀI CHÍNH

❌ Có lỗi khi tạo báo cáo chi tiết.
Vui lòng thử lại sau.

Được tạo bởi Task & Expense Manager
''';
        await Share.share(fallbackSummary);
      } catch (fallbackError) {
        SnackbarHelper.showError('Không thể chia sẻ báo cáo');
      }
    }
  }
}
