import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_enums.dart';
import '../../data/models/expense_model.dart';
import '../controllers/expense_controller.dart';
import '../../../task/presentation/controllers/task_controller.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final ExpenseModel expense;

  ExpenseDetailScreen({required this.expense});

  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.find<ExpenseController>();
    final TaskController taskController = Get.find<TaskController>();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết chi tiêu',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () => _shareExpense(context),
          ).animate().scale(duration: 200.ms),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () =>
                Get.toNamed('/expense-create', arguments: {'expense': expense}),
          ).animate().scale(duration: 200.ms),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, controller),
          ).animate().scale(duration: 200.ms),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expense.title,
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              Text(
                'Số tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(expense.amount.abs())} ${expense.amount > 0 ? '(Thu nhập)' : '(Chi tiêu)'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 8),
              Text('Danh mục: ${categoryToString(expense.category)}',
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 8),
              Text('Ngày: ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 8),
              Text('Tâm trạng: ${getMoodEmoji(expense.mood, true)}',
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 8),
              Text('Lý do: ${reasonToString(expense.reason)}',
                  style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 16),
              Text('Công việc liên kết:',
                  style: Theme.of(context).textTheme.titleMedium),
              Obx(() {
                final linkedTask = taskController.tasks.firstWhereOrNull(
                    (task) => task.id == expense.linkedTaskId);
                if (linkedTask == null) {
                  return Text('Không có công việc liên kết',
                      style: Theme.of(context).textTheme.bodyMedium);
                }
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(linkedTask.title,
                        style: Theme.of(context).textTheme.bodyLarge),
                    subtitle: Text(
                        'Hạn: ${DateFormat('dd/MM/yyyy').format(linkedTask.dueDate)}',
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () => Get.toNamed('/task-detail',
                        arguments: {'task': linkedTask}),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _shareExpense(BuildContext context) {
    final text =
        'Chi tiêu: ${expense.title}\nSố tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(expense.amount.abs())}\nDanh mục: ${categoryToString(expense.category)}\nNgày: ${DateFormat('dd/MM/yyyy').format(expense.date)}\nTâm trạng: ${getMoodEmoji(expense.mood, true)}\nLý do: ${reasonToString(expense.reason)}';
    Share.share(text);
  }

  void _showDeleteDialog(BuildContext context, ExpenseController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa chi tiêu'),
        content: Text('Bạn có chắc muốn xóa chi tiêu này?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              await controller.deleteExpense(expense.id);
              Get.back();
              Get.back();
            },
            child: Text('Xác nhận', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
