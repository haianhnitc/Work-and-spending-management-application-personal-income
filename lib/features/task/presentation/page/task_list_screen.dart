import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/widgets/chart_widgets.dart';
import '../controllers/task_controller.dart';

class TaskListScreen extends StatelessWidget {
  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Công việc',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Obx(() => controller.selectedCategory.value.isNotEmpty
                ? Chip(
                    label: Text(categoryToString(controller.selectedCategory.value),
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.white24,
                    onDeleted: () => controller.clearCategoryFilter(),
                  ).animate().fadeIn(duration: 200.ms)
                : SizedBox.shrink()),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white),
              onPressed: () => _showFilterDialog(context),
            ).animate().scale(duration: 200.ms),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchBar(context),
            ).animate().scale(duration: 200.ms),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Hôm nay'),
              Tab(text: 'Tuần này'),
              Tab(text: 'Quá hạn'),
              Tab(text: 'Đã hoàn thành'),
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
                  _buildTaskList(context, 'all', isTablet),
                  _buildTaskList(context, 'today', isTablet),
                  _buildTaskList(context, 'this_week', isTablet),
                  _buildTaskList(context, 'overdue', isTablet),
                  _buildTaskList(context, 'completed', isTablet),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed('/task-create'),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tổng quan',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 4),
                Text('Hoàn thành: ${controller.completedCount}/${controller.totalCount}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: controller.completionProgress,
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey[300],
            ),
          ),
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
              controller.selectedCategory.value.isNotEmpty || controller.searchQuery.value.isNotEmpty
                  ? 'Biểu đồ: ${controller.selectedCategory.value.isNotEmpty ? controller.selectedCategory.value : 'Kết quả tìm kiếm'}'
                  : 'Biểu đồ công việc theo danh mục',
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

  Widget _buildSelectedChart(BuildContext context, Map<String, int> categoryTotals, bool isTablet) {
    switch (controller.selectedChartType.value) {
      case ChartType.pie:
        return CustomTaskPieChart(
          categoryTotals: categoryTotals,
          isTablet: isTablet,
        );
      case ChartType.bar:
        return CustomTaskBarChart(
          categoryTotals: categoryTotals,
          isTablet: isTablet,
        );
      case ChartType.line:
        return CustomTaskLineChart(
          categoryTotals: categoryTotals,
          isTablet: isTablet,
        );
    }
  }

  Widget _buildTaskList(BuildContext context, String filter, bool isTablet) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      final today = DateTime.now();
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 7));

      final tasks = controller.filteredTasks.where((task) {
        switch (filter) {
          case 'all':
            return true;
          case 'today':
            return task.dueDate.day == today.day &&
                task.dueDate.month == today.month &&
                task.dueDate.year == today.year;
          case 'this_week':
            return task.dueDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                task.dueDate.isBefore(endOfWeek.add(Duration(days: 1)));
          case 'overdue':
            return task.dueDate.isBefore(today) && !task.isCompleted;
          case 'completed':
            return task.isCompleted;
          default:
            return true;
        }
      }).toList();

      if (tasks.isEmpty) {
        return Center(child: Text('Không có công việc'));
      }

      return ListView.builder(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task.id),
            onDismissed: (direction) => controller.deleteTask(task.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    controller
                        .updateTask(task.copyWith(isCompleted: value ?? false));
                  },
                ).animate().scale(duration: 200.ms),
                title: Text(task.title,
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  'Hạn: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}\nDanh mục: ${categoryToString(task.category)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(Icons.arrow_forward,
                    color: Theme.of(context).primaryColor),
                onTap: () =>
                    Get.toNamed('/task-detail', arguments: {'task': task}),
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
                          child: Text(categoryToString(category.name))))
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

  void _showSearchBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tìm kiếm công việc'),
        content: TextField(
          onChanged: (value) => controller.setSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Nhập tiêu đề công việc...',
            border: OutlineInputBorder(),
            prefixIcon:
                Icon(Icons.search, color: Theme.of(context).primaryColor),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearSearch();
              Get.back();
            },
            child: Text('Xóa'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Đóng'),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
