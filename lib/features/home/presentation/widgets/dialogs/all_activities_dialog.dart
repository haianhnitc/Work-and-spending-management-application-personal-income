import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../expense/presentation/controllers/expense_controller.dart';
import '../../../../task/presentation/controllers/task_controller.dart';

class AllActivitiesDialog extends StatelessWidget {
  final ExpenseController expenseController;
  final TaskController taskController;

  const AllActivitiesDialog({
    Key? key,
    required this.expenseController,
    required this.taskController,
  }) : super(key: key);

  static void show(BuildContext context) {
    final expenseController = Get.find<ExpenseController>();
    final taskController = Get.find<TaskController>();

    showDialog(
      context: context,
      builder: (context) => AllActivitiesDialog(
        expenseController: expenseController,
        taskController: taskController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                final activities = _getAllActivities();

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
                    return _buildActivityCard(activity);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAllActivities() {
    final activities = <Map<String, dynamic>>[];

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

    for (final task in taskController.tasks) {
      activities.add({
        'type': 'task',
        'date': task.createdAt,
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

    activities.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return activities;
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
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
          backgroundColor: (activity['color'] as Color).withOpacity(0.1),
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
                  'Háº¡n: ${DateFormat('dd/MM/yyyy').format(activity['dueDate'])}',
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
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: isExpense
            ? Icon(Icons.arrow_forward_ios, size: 16)
            : Icon(
                activity['isCompleted'] ? Icons.check_circle : Icons.schedule,
                color: activity['isCompleted'] ? Colors.green : Colors.orange,
              ),
      ),
    );
  }
}
