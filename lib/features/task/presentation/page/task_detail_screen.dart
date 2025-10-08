import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import '../../data/models/task_model.dart';
import '../controllers/task_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/utils/snackbar_helper.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  TaskDetailScreen({required this.task});

  bool get isTablet => MediaQuery.of(Get.context!).size.width > 600;

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết công việc',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
                size: isTablet ? 30 : 26),
            onPressed: () => _shareTask(context, task),
            tooltip: 'Chia sẻ công việc',
          ).animate().scale(duration: 200.ms, delay: 100.ms),
          IconButton(
            icon: Icon(Icons.edit_rounded,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
                size: isTablet ? 30 : 26),
            onPressed: () {
              Get.toNamed(AppRoutes.createTask, arguments: {'task': task});
            },
            tooltip: 'Chỉnh sửa công việc',
          ).animate().scale(duration: 200.ms, delay: 200.ms),
          IconButton(
            icon: Icon(Icons.delete_rounded,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
                size: isTablet ? 30 : 26),
            onPressed: () => _confirmDelete(context, controller, task),
            tooltip: 'Xóa công việc',
          ).animate().scale(duration: 200.ms, delay: 300.ms),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleAndStatus(
                    context, task.title, task.isCompleted, isTablet)
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms),
            SizedBox(height: isTablet ? 24 : 20),
            _buildInfoCard(
              context,
              icon: Icons.description_rounded,
              label: 'Mô tả',
              value: task.description.isNotEmpty
                  ? task.description
                  : 'Không có mô tả',
              isTablet: isTablet,
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
            SizedBox(height: isTablet ? 16 : 12),
            _buildInfoCard(
              context,
              icon: Icons.category_rounded,
              label: 'Danh mục',
              value: categoryToString(task.category),
              color: getCategoryColorByName(task.category),
              isTablet: isTablet,
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            SizedBox(height: isTablet ? 16 : 12),
            _buildInfoCard(
              context,
              icon: Icons.calendar_today_rounded,
              label: 'Ngày hạn chót',
              value: DateFormat('dd/MM/yyyy').format(task.dueDate),
              color: task.dueDate.isBefore(DateTime.now()) && !task.isCompleted
                  ? Colors.redAccent
                  : null,
              isTablet: isTablet,
            ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
            SizedBox(height: isTablet ? 16 : 12),
            _buildInfoCard(
              context,
              icon: Icons.attach_money_rounded,
              label: 'Chi phí ước tính',
              value: task.estimatedCost != null && task.estimatedCost! > 0
                  ? NumberFormat.currency(locale: 'vi', symbol: '₫')
                      .format(task.estimatedCost)
                  : 'Không có',
              isTablet: isTablet,
            ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
            SizedBox(height: isTablet ? 24 : 20),
            _buildStatusToggle(context, controller, task, isTablet)
                .animate()
                .fadeIn(duration: 300.ms, delay: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndStatus(
      BuildContext context, String title, bool isCompleted, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: isTablet ? 34 : 28,
                color: Theme.of(context).colorScheme.onSurface,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                decorationColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                decorationThickness: 2,
              ),
        ),
        SizedBox(height: isTablet ? 10 : 6),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 14 : 10, vertical: isTablet ? 7 : 5),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.2)
                : (task.dueDate.isBefore(DateTime.now()) && !task.isCompleted
                    ? Colors.red.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            isCompleted
                ? 'Đã hoàn thành ✅'
                : (task.dueDate.isBefore(DateTime.now())
                    ? 'Quá hạn ⚠️'
                    : 'Đang chờ ⏳'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isCompleted
                      ? Colors.green.shade700
                      : (task.dueDate.isBefore(DateTime.now()) &&
                              !task.isCompleted
                          ? Colors.red.shade700
                          : Colors.orange.shade700),
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 15 : 13,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      Color? color,
      required bool isTablet}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                color: color ?? Theme.of(context).colorScheme.primary,
                size: isTablet ? 32 : 28),
            SizedBox(width: isTablet ? 20 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet ? 17 : 15,
                        ),
                  ),
                  SizedBox(height: isTablet ? 6 : 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: isTablet ? 20 : 17,
                          fontWeight: FontWeight.w600,
                          color: color ??
                              Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: label == 'Mô tả' ? 5 : 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusToggle(BuildContext context, TaskController controller,
      TaskModel task, bool isTablet) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 18),
        child: Obx(() {
          final currentTask =
              controller.tasks.firstWhereOrNull((t) => t.id == task.id) ?? task;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh dấu hoàn thành',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: isTablet ? 19 : 17,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              Switch.adaptive(
                value: currentTask.isCompleted,
                onChanged: (newValue) {
                  final updatedTask = task.copyWith(isCompleted: newValue);
                  controller.updateTask(updatedTask);
                  if (newValue) {
                    SnackbarHelper.showSuccess(
                        'Công việc "${task.title}" đã được hoàn thành.');
                  } else {
                    SnackbarHelper.showInfo(
                        'Công việc "${task.title}" đang chờ xử lý.');
                  }
                },
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade300,
              ).animate().flip(duration: 500.ms, delay: 100.ms),
            ],
          );
        }),
      ),
    );
  }

  void _shareTask(BuildContext context, TaskModel task) {
    final String shareText = "📝 Công việc: ${task.title}\n"
        "📖 Mô tả: ${task.description.isNotEmpty ? task.description : 'Không có mô tả'}\n"
        "🏷️ Danh mục: ${categoryToString(task.category)}\n"
        "📅 Hạn chót: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}\n"
        "💰 Chi phí ước tính: ${task.estimatedCost != null && task.estimatedCost! > 0 ? NumberFormat.currency(locale: 'vi', symbol: '₫').format(task.estimatedCost) : 'Không có'}\n"
        "✅ Trạng thái: ${task.isCompleted ? 'Đã hoàn thành' : 'Đang chờ'}\n\n"
        "Quản lý công việc hiệu quả hơn với ứng dụng của bạn!";
    Share.share(shareText, subject: 'Chi tiết công việc: ${task.title}');
  }

  void _confirmDelete(
      BuildContext context, TaskController controller, TaskModel task) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Xác nhận xóa',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
                size: isTablet ? 50 : 40),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
                'Bạn có chắc muốn xóa công việc "${task.title}" không?\nThao tác này không thể hoàn tác.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isTablet ? 17 : 15,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8),
                    )),
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20 : 16, vertical: isTablet ? 10 : 8),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Hủy',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                    fontSize: isTablet ? 17 : 15)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteTask(task.id);
              Get.back();
              Get.back();
              SnackbarHelper.showSuccess(
                  'Công việc "${task.title}" đã được xóa thành công.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16, vertical: isTablet ? 10 : 8),
            ),
            child: Text('Xác nhận xóa',
                style: TextStyle(fontSize: isTablet ? 17 : 15)),
          ),
        ],
      ),
    );
  }
}
