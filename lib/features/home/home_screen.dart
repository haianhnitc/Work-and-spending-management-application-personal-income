// lib/app/modules/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // Giữ lại cho biểu đồ nhỏ
import 'package:intl/intl.dart'; // Để định dạng tiền tệ
import '../../../../core/constants/app_enums.dart';
import '../expense/presentation/controllers/expense_controller.dart';
import '../task/presentation/controllers/task_controller.dart'; // Đảm bảo có enum Category

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find<ExpenseController>();
    final TaskController taskController = Get.find<TaskController>();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xin chào, User 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Theme.of(context).primaryColor, // Màu chủ đạo
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // TODO: Điều hướng đến màn hình thông báo
              Get.snackbar('Thông báo', 'Chức năng đang phát triển!');
            },
          ).animate().scale(duration: 200.ms),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Get.toNamed('/profile'),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF9B59B6), // Màu tím nhẹ
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ).animate().scale(duration: 200.ms, delay: 100.ms),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          taskController.fetchTasks();
          expenseController.fetchExpenses();
        },
        child: ListView(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          children: [
            _buildFinancialSummary(context, expenseController, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildQuickActions(context, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildUpcomingTasks(context, taskController, isTablet),
            SizedBox(height: isTablet ? 24 : 16),
            _buildMonthlyExpenseChart(context, expenseController, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(
      BuildContext context, ExpenseController controller, bool isTablet) {
    return Obx(() {
      final totalIncome = controller.expenses
          .where((e) => e.incomeType == IncomeType.all)
          .fold(0.0, (sum, item) => sum + item.amount);
      final totalExpense = controller.expenses
          .where((e) => e.incomeType == IncomeType.none)
          .fold(0.0, (sum, item) => sum + item.amount);
      final balance = totalIncome - totalExpense;

      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF8EC5FC)], // Gradient xanh
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
            ],
          ),
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Số dư hiện tại',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                    .format(balance),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              SizedBox(height: isTablet ? 20 : 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFinancialStat(
                    context,
                    Icons.arrow_downward,
                    'Chi tiêu',
                    totalExpense,
                    Colors.redAccent.shade100,
                    isTablet,
                  ),
                  _buildFinancialStat(
                    context,
                    Icons.arrow_upward,
                    'Thu nhập',
                    totalIncome,
                    Colors.greenAccent.shade100,
                    isTablet,
                  ),
                ],
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

  Widget _buildQuickActions(BuildContext context, bool isTablet) {
    return Row(
      children: [
        _buildActionButton(
          context,
          Icons.add_task,
          'Thêm công việc',
          () =>
              Get.toNamed('/task-create', arguments: {'date': DateTime.now()}),
          isTablet,
        ),
        SizedBox(width: isTablet ? 20 : 16),
        _buildActionButton(
          context,
          Icons.attach_money,
          'Thêm giao dịch',
          () => Get.toNamed(
            '/expense-create',
            arguments: {'date': DateTime.now()},
          ),
          isTablet,
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideX(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
        );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onTap, bool isTablet) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: isTablet ? 24 : 16, horizontal: isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: isTablet ? 36 : 28,
                  color: Theme.of(context).primaryColor),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
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

      // Sắp xếp công việc theo ngày hạn
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
                itemCount: upcomingTasks.length > 3
                    ? 3
                    : upcomingTasks
                        .length, // Chỉ hiển thị tối đa 3 công việc để giữ gọn
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
                                'Hạn: ${DateFormat('dd/MM').format(task.dueDate)} - ${_categoryToString(task.category)}',
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
              e.incomeType == IncomeType.none) // Chỉ tính chi tiêu
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
            color: _getCategoryColor(colorIndex++),
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
                    sectionsSpace: 4, // Khoảng cách giữa các phần
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
                color: _getCategoryColor(colorIndex++),
              ),
            ),
            SizedBox(width: isTablet ? 8 : 6),
            Text(
              _categoryToString(entry.key),
              style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      }).toList(),
    );
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
      case 'work':
        return 'Công việc';
      case 'personal':
        return 'Cá nhân';
      case 'food':
        return 'Ăn uống';
      case 'transport':
        return 'Đi lại';
      case 'shopping':
        return 'Mua sắm';
      case 'health':
        return 'Sức khỏe';
      case 'education':
        return 'Giáo dục';
      case 'utilities':
        return 'Tiện ích';
      case 'salary':
        return 'Lương';
      case 'investment':
        return 'Đầu tư';
      case 'gift':
        return 'Quà tặng';
      default:
        return category;
    }
  }

  // Helper để lấy màu theo index cho biểu đồ
  Color _getCategoryColor(int index) {
    const colors = [
      Color(0xFF4A90E2), // Xanh dương
      Color(0xFF50C878), // Xanh lá đậm
      Color(0xFFF39C12), // Cam
      Color(0xFF9B59B6), // Tím
      Color(0xFFE74C3C), // Đỏ
      Color(0xFF1ABC9C), // Xanh ngọc
      Color(0xFFF1C40F), // Vàng
      Color(0xFF34495E), // Xám xanh
      Color(0xFFD35400), // Cam cháy
      Color(0xFFC0392B), // Đỏ đô
      Color(0xFF2ECC71), // Xanh ngọc bích
      Color(0xFF7F8C8D), // Xám
    ];
    return colors[index % colors.length];
  }
}

// // lib/app/modules/home/views/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart'; // Giữ lại cho biểu đồ nhỏ
// import 'package:intl/intl.dart'; // Để định dạng tiền tệ
// import '../../../../core/constants/app_enums.dart';
// import '../expense/presentation/controllers/expense_controller.dart';
// import '../task/presentation/controllers/task_controller.dart'; // Đảm bảo có enum Category

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ExpenseController expenseController = Get.find<ExpenseController>();
//     final TaskController taskController = Get.find<TaskController>();
//     final isTablet = MediaQuery.of(context).size.width > 600;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Xin chào, User 👋',
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         backgroundColor: Theme.of(context).primaryColor, // Màu chủ đạo
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none, color: Colors.white),
//             onPressed: () {
//               // TODO: Điều hướng đến màn hình thông báo
//               Get.snackbar('Thông báo', 'Chức năng đang phát triển!');
//             },
//           ).animate().scale(duration: 200.ms),
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: GestureDetector(
//               onTap: () => Get.toNamed('/profile'),
//               child: const CircleAvatar(
//                 backgroundColor: Color(0xFF9B59B6), // Màu tím nhẹ
//                 child: Icon(Icons.person, color: Colors.white),
//               ),
//             ),
//           ).animate().scale(duration: 200.ms, delay: 100.ms),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           taskController.fetchTasks();
//           expenseController.fetchExpenses();
//         },
//         child: ListView(
//           padding: EdgeInsets.all(isTablet ? 24 : 16),
//           children: [
//             _buildFinancialSummary(context, expenseController, isTablet),
//             SizedBox(height: isTablet ? 24 : 16),
//             _buildQuickActions(context, isTablet),
//             SizedBox(height: isTablet ? 24 : 16),
//             _buildUpcomingTasks(context, taskController, isTablet),
//             SizedBox(height: isTablet ? 24 : 16),
//             _buildMonthlyExpenseChart(context, expenseController, isTablet),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFinancialSummary(
//       BuildContext context, ExpenseController controller, bool isTablet) {
//     return Obx(() {
//       final totalIncome = controller.expenses
//           .where((e) =>
//               e.incomeType == IncomeType.fixed ||
//               e.incomeType == IncomeType.variable)
//           .fold(0.0, (sum, item) => sum + item.amount);
//       final totalExpense = controller.expenses
//           .where((e) => e.incomeType == IncomeType.none)
//           .fold(0.0, (sum, item) => sum + item.amount);
//       final balance = totalIncome - totalExpense;

//       return Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF4A90E2), Color(0xFF8EC5FC)], // Gradient xanh
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.blue.withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5)),
//             ],
//           ),
//           padding: EdgeInsets.all(isTablet ? 24 : 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Số dư hiện tại',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       color: Colors.white70,
//                       fontWeight: FontWeight.w600,
//                     ),
//               ),
//               SizedBox(height: isTablet ? 12 : 8),
//               Text(
//                 NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
//                     .format(balance),
//                 style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.2,
//                     ),
//               ),
//               SizedBox(height: isTablet ? 20 : 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildFinancialStat(
//                     context,
//                     Icons.arrow_downward,
//                     'Chi tiêu',
//                     totalExpense,
//                     Colors.redAccent.shade100,
//                     isTablet,
//                   ),
//                   _buildFinancialStat(
//                     context,
//                     Icons.arrow_upward,
//                     'Thu nhập',
//                     totalIncome,
//                     Colors.greenAccent.shade100,
//                     isTablet,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideX(
//             begin: -0.1,
//             end: 0,
//             duration: 300.ms,
//           );
//     });
//   }

//   Widget _buildFinancialStat(BuildContext context, IconData icon, String label,
//       double amount, Color color, bool isTablet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: color, size: isTablet ? 24 : 20),
//             SizedBox(width: isTablet ? 8 : 4),
//             Text(
//               label,
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                   ),
//             ),
//           ],
//         ),
//         SizedBox(height: isTablet ? 8 : 4),
//         Text(
//           NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(amount),
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActions(BuildContext context, bool isTablet) {
//     return Row(
//       children: [
//         _buildActionButton(
//           context,
//           Icons.add_task,
//           'Thêm công việc',
//           () =>
//               Get.toNamed('/task-create', arguments: {'date': DateTime.now()}),
//           isTablet,
//         ),
//         SizedBox(width: isTablet ? 20 : 16),
//         _buildActionButton(
//           context,
//           Icons.attach_money,
//           'Thêm giao dịch',
//           () => Get.toNamed(
//             '/expense-create',
//             arguments: {'date': DateTime.now()},
//           ),
//           isTablet,
//         ),
//       ],
//     ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideX(
//           begin: 0.1,
//           end: 0,
//           duration: 300.ms,
//         );
//   }

//   Widget _buildActionButton(BuildContext context, IconData icon, String label,
//       VoidCallback onTap, bool isTablet) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(
//               vertical: isTablet ? 24 : 16, horizontal: isTablet ? 16 : 12),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4)),
//             ],
//           ),
//           child: Column(
//             children: [
//               Icon(icon,
//                   size: isTablet ? 36 : 28,
//                   color: Theme.of(context).primaryColor),
//               SizedBox(height: isTablet ? 12 : 8),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUpcomingTasks(
//       BuildContext context, TaskController controller, bool isTablet) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return _buildLoadingCard(context, 'Công việc sắp tới');
//       }

//       final today = DateTime.now();
//       final upcomingTasks = controller.tasks
//           .where((task) =>
//               !task.isCompleted &&
//               (task.dueDate.isAfter(today.subtract(const Duration(days: 1))) &&
//                   task.dueDate.isBefore(today.add(const Duration(days: 7)))))
//           .toList();

//       if (upcomingTasks.isEmpty) {
//         return _buildEmptyStateCard(
//             context, 'Công việc sắp tới', 'Không có công việc nào gần đây.');
//       }

//       // Sắp xếp công việc theo ngày hạn
//       upcomingTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

//       return Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: EdgeInsets.all(isTablet ? 20 : 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Công việc sắp tới',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//               ),
//               SizedBox(height: isTablet ? 16 : 12),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: upcomingTasks.length > 3
//                     ? 3
//                     : upcomingTasks
//                         .length, // Chỉ hiển thị tối đa 3 công việc để giữ gọn
//                 itemBuilder: (context, index) {
//                   final task = upcomingTasks[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 6.0),
//                     child: Row(
//                       children: [
//                         Icon(Icons.calendar_today,
//                             size: isTablet ? 20 : 16, color: Colors.grey[600]),
//                         SizedBox(width: isTablet ? 12 : 8),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 task.title,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium
//                                     ?.copyWith(fontWeight: FontWeight.w500),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 'Hạn: ${DateFormat('dd/MM').format(task.dueDate)} - ${_categoryToString(task.category)}',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall
//                                     ?.copyWith(color: Colors.grey[600]),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Icon(Icons.arrow_forward_ios,
//                             size: isTablet ? 18 : 14, color: Colors.grey[400]),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               if (upcomingTasks.length > 3)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Center(
//                     child: TextButton(
//                       onPressed: () => Get.toNamed('/task-list'),
//                       child: Text(
//                         'Xem tất cả công việc (${upcomingTasks.length})',
//                         style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                               color: Theme.of(context).primaryColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ).animate().fadeIn(duration: 300.ms, delay: 300.ms).slideY(
//             begin: 0.1,
//             end: 0,
//             duration: 300.ms,
//           );
//     });
//   }

//   Widget _buildEmptyStateCard(
//       BuildContext context, String title, String message) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).primaryColor,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             Center(
//               child: Column(
//                 children: [
//                   Icon(Icons.info_outline, size: 50, color: Colors.grey[400]),
//                   const SizedBox(height: 8),
//                   Text(
//                     message,
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ).animate().fadeIn(duration: 300.ms);
//   }

//   Widget _buildLoadingCard(BuildContext context, String title) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).primaryColor,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//           ],
//         ),
//       ),
//     ).animate().fadeIn(duration: 300.ms);
//   }

//   Widget _buildMonthlyExpenseChart(
//       BuildContext context, ExpenseController controller, bool isTablet) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return _buildLoadingCard(context, 'Biểu đồ chi tiêu hàng tháng');
//       }

//       final now = DateTime.now();
//       final currentMonthExpenses = controller.expenses
//           .where((e) =>
//               e.date.month == now.month &&
//               e.date.year == now.year &&
//               e.incomeType == IncomeType.none) // Chỉ tính chi tiêu
//           .toList();

//       if (currentMonthExpenses.isEmpty) {
//         return _buildEmptyStateCard(context, 'Biểu đồ chi tiêu hàng tháng',
//             'Chưa có chi tiêu nào trong tháng này.');
//       }

//       final Map<String, double> categoryAmounts = {};
//       for (var expense in currentMonthExpenses) {
//         categoryAmounts.update(
//             expense.category, (value) => value + expense.amount,
//             ifAbsent: () => expense.amount);
//       }

//       final totalAmount =
//           categoryAmounts.values.fold(0.0, (sum, amt) => sum + amt);

//       List<PieChartSectionData> sections = [];
//       int colorIndex = 0;
//       categoryAmounts.forEach((category, amount) {
//         final percentage = (amount / totalAmount * 100).toStringAsFixed(1);
//         sections.add(
//           PieChartSectionData(
//             color: _getCategoryColor(colorIndex++),
//             value: amount,
//             title: '$percentage%',
//             radius: isTablet ? 70 : 50,
//             titleStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//             showTitle: true,
//           ),
//         );
//       });

//       return Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: EdgeInsets.all(isTablet ? 20 : 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Chi tiêu hàng tháng',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//               ),
//               SizedBox(height: isTablet ? 16 : 12),
//               SizedBox(
//                 height: isTablet ? 250 : 200,
//                 child: PieChart(
//                   PieChartData(
//                     sections: sections,
//                     centerSpaceRadius: isTablet ? 60 : 40,
//                     sectionsSpace: 4, // Khoảng cách giữa các phần
//                     borderData: FlBorderData(show: false),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               _buildChartLegend(categoryAmounts, isTablet),
//             ],
//           ),
//         ),
//       ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideY(
//             begin: 0.1,
//             end: 0,
//             duration: 300.ms,
//           );
//     });
//   }

//   Widget _buildChartLegend(Map<String, double> categoryAmounts, bool isTablet) {
//     int colorIndex = 0;
//     return Wrap(
//       spacing: isTablet ? 16 : 12,
//       runSpacing: isTablet ? 12 : 8,
//       children: categoryAmounts.entries.map((entry) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: isTablet ? 18 : 14,
//               height: isTablet ? 18 : 14,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _getCategoryColor(colorIndex++),
//               ),
//             ),
//             SizedBox(width: isTablet ? 8 : 6),
//             Text(
//               _categoryToString(entry.key),
//               style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
//                     fontWeight: FontWeight.w500,
//                   ),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   String _categoryToString(String category) {
//     switch (category) {
//       case 'study':
//         return 'Học tập';
//       case 'lifestyle':
//         return 'Phong cách sống';
//       case 'skill':
//         return 'Kỹ năng';
//       case 'entertainment':
//         return 'Giải trí';
//       case 'work':
//         return 'Công việc';
//       case 'personal':
//         return 'Cá nhân';
//       case 'food':
//         return 'Ăn uống';
//       case 'transport':
//         return 'Đi lại';
//       case 'shopping':
//         return 'Mua sắm';
//       case 'health':
//         return 'Sức khỏe';
//       case 'education':
//         return 'Giáo dục';
//       case 'utilities':
//         return 'Tiện ích';
//       case 'salary':
//         return 'Lương';
//       case 'investment':
//         return 'Đầu tư';
//       case 'gift':
//         return 'Quà tặng';
//       default:
//         return category;
//     }
//   }

//   // Helper để lấy màu theo index cho biểu đồ
//   Color _getCategoryColor(int index) {
//     const colors = [
//       Color(0xFF4A90E2), // Xanh dương
//       Color(0xFF50C878), // Xanh lá đậm
//       Color(0xFFF39C12), // Cam
//       Color(0xFF9B59B6), // Tím
//       Color(0xFFE74C3C), // Đỏ
//       Color(0xFF1ABC9C), // Xanh ngọc
//       Color(0xFFF1C40F), // Vàng
//       Color(0xFF34495E), // Xám xanh
//       Color(0xFFD35400), // Cam cháy
//       Color(0xFFC0392B), // Đỏ đô
//       Color(0xFF2ECC71), // Xanh ngọc bích
//       Color(0xFF7F8C8D), // Xám
//     ];
//     return colors[index % colors.length];
//   }
// }
