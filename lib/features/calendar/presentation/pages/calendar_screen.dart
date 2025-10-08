import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import 'package:task_expense_manager/core/widgets/common_app_bar.dart';
import 'package:task_expense_manager/features/calendar/presentation/controllers/calendar_controller.dart';
import '../../../expense/data/models/expense_model.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';
import '../../../task/data/models/task_model.dart';
import '../../../task/presentation/controllers/task_controller.dart';
import '../../../../routes/app_routes.dart';

class CalendarScreen extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final calendarController = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Lịch',
        type: AppBarType.primary,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  Icons.task_alt_rounded,
                  color: calendarController.showTasks.value
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
                onPressed: () => calendarController.showTasks.toggle(),
                tooltip: calendarController.showTasks.value
                    ? 'Ẩn công việc'
                    : 'Hiển thị công việc',
              )),
          Obx(() => IconButton(
                icon: Icon(
                  Icons.payments_rounded,
                  color: calendarController.showExpenses.value
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
                onPressed: () => calendarController.showExpenses.toggle(),
                tooltip: calendarController.showExpenses.value
                    ? 'Ẩn chi tiêu'
                    : 'Hiển thị chi tiêu',
              )),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.surface,
                  ]
                : [
                    Color(0xFFF8F9FA),
                    Colors.white,
                  ],
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() => TableCalendar(
                    key: ValueKey(
                        '${calendarController.showTasks.value}_${calendarController.showExpenses.value}'),
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: calendarController.focusedDay.value,
                    calendarFormat: calendarController.calendarFormat.value,
                    selectedDayPredicate: (day) {
                      return isSameDay(
                          calendarController.selectedDay.value, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      calendarController.selectedDay.value = selectedDay;
                      calendarController.focusedDay.value = focusedDay;
                    },
                    onPageChanged: (focusedDay) {
                      calendarController.focusedDay.value = focusedDay;
                    },
                    eventLoader: (day) {
                      final allEvents = _buildEvents(
                          taskController.tasks, expenseController.expenses);
                      List<dynamic> events =
                          allEvents[DateTime(day.year, day.month, day.day)] ??
                              [];

                      if (!calendarController.showTasks.value) {
                        events = events.where((e) => e is! TaskModel).toList();
                      }
                      if (!calendarController.showExpenses.value) {
                        events =
                            events.where((e) => e is! ExpenseModel).toList();
                      }
                      return events;
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return Positioned(
                            right: 1,
                            bottom: 1,
                            child: _buildEventsMarker(
                                date, events, isTablet, context),
                          );
                        }
                        return null;
                      },
                      selectedBuilder: (context, date, focusedDay) {
                        return Container(
                          margin: EdgeInsets.all(6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                      todayBuilder: (context, date, focusedDay) {
                        return Container(
                          margin: EdgeInsets.all(6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2),
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        );
                      },
                      dowBuilder: (context, day) {
                        final text = DateFormat.E('vi_VN').format(day);
                        return Center(
                          child: Text(
                            text,
                            style: TextStyle(
                                color: day.weekday == DateTime.sunday
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        );
                      },
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface),
                      leftChevronIcon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.chevron_left_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                      ),
                      rightChevronIcon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.chevron_right_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                      ),
                      headerPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                      weekendStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                    ),
                    rowHeight: 50,
                    availableGestures: AvailableGestures.horizontalSwipe,
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms)),
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Expanded(
              child: Obx(() {
                final allEvents = _buildEvents(
                    taskController.tasks, expenseController.expenses);
                return _buildEventList(context, allEvents,
                    calendarController.selectedDay.value, isTablet);
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "calendar_fab",
        onPressed: () {
          Get.bottomSheet(
            Container(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Thêm mới',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: isTablet ? 28 : 22,
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                  SizedBox(height: isTablet ? 30 : 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoutes.createTask, arguments: {
                        'date': calendarController.selectedDay.value ??
                            DateTime.now()
                      });
                    },
                    icon: Icon(Icons.add_task_rounded,
                        color: Colors.white, size: isTablet ? 30 : 24),
                    label: Text('Thêm công việc',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 20 : 17)),
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, isTablet ? 60 : 50)),
                            ),
                  ).animate().scale(duration: 200.ms, delay: 100.ms),
                  SizedBox(height: isTablet ? 20 : 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoutes.createExpense, arguments: {
                        'date': calendarController.selectedDay.value ??
                            DateTime.now()
                      });
                    },
                    icon: Icon(Icons.add_card_rounded,
                        color: Colors.white, size: isTablet ? 30 : 24),
                    label: Text('Thêm chi tiêu',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 20 : 17)),
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.secondary),
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, isTablet ? 60 : 50)),
                            ),
                  ).animate().scale(duration: 200.ms, delay: 200.ms),
                ],
              ),
            ),
            isScrollControlled: true,
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white, size: isTablet ? 32 : 28),
        tooltip: 'Thêm mới sự kiện',
      ).animate().scale(duration: 200.ms, delay: 500.ms),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<dynamic> events, bool isTablet,
      BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return Container(
      width: isTablet ? 32 : 24,
      height: isTablet ? 32 : 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${events.length}',
        style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 14 : 10,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEventList(
      BuildContext context,
      Map<DateTime, List<dynamic>> allEvents,
      DateTime? selectedDay,
      bool isTablet) {
    if (selectedDay == null) {
      return CustomEmptyState(
        icon: Icons.touch_app_rounded,
        message: 'Chọn một ngày để xem sự kiện.',
      );
    }

    final eventsForSelectedDay = allEvents[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];

    final filteredEventsForSelectedDay = eventsForSelectedDay.where((event) {
      if (event is TaskModel) {
        return calendarController.showTasks.value;
      } else if (event is ExpenseModel) {
        return calendarController.showExpenses.value;
      }
      return false;
    }).toList();

    if (filteredEventsForSelectedDay.isEmpty) {
      return CustomEmptyState(
        icon: Icons.event_note_rounded,
        message: 'Không có sự kiện nào cho ngày này.',
        buttonText: 'Thêm ngay',
        onButtonPressed: () {
          Get.bottomSheet(
            Container(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Thêm mới',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: isTablet ? 28 : 22,
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                  SizedBox(height: isTablet ? 30 : 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoutes.createTask,
                          arguments: {'date': selectedDay ?? DateTime.now()});
                    },
                    icon: Icon(Icons.add_task_rounded,
                        color: Colors.white, size: isTablet ? 30 : 24),
                    label: Text('Thêm công việc',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 20 : 17)),
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, isTablet ? 60 : 50)),
                            ),
                  ).animate().scale(duration: 200.ms, delay: 100.ms),
                  SizedBox(height: isTablet ? 20 : 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoutes.createExpense, arguments: {
                        'date': calendarController.selectedDay.value
                      });
                    },
                    icon: Icon(Icons.add_card_rounded,
                        color: Colors.white, size: isTablet ? 30 : 24),
                    label: Text('Thêm chi tiêu',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 20 : 17)),
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.secondary),
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, isTablet ? 60 : 50)),
                            ),
                  ).animate().scale(duration: 200.ms, delay: 200.ms),
                ],
              ),
            ),
            isScrollControlled: true,
          );
        },
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 16, vertical: isTablet ? 12 : 8),
      itemCount: filteredEventsForSelectedDay.length,
      itemBuilder: (context, index) {
        final event = filteredEventsForSelectedDay[index];
        if (event is TaskModel) {
          return _buildTaskEventCard(context, event, isTablet)
              .animate()
              .fadeIn(duration: 300.ms, delay: (50 * index).ms)
              .slideY(begin: 0.1, end: 0, duration: 300.ms);
        } else if (event is ExpenseModel) {
          return _buildExpenseEventCard(context, event, isTablet)
              .animate()
              .fadeIn(duration: 300.ms, delay: (50 * index).ms)
              .slideY(begin: 0.1, end: 0, duration: 300.ms);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTaskEventCard(
      BuildContext context, TaskModel task, bool isTablet) {
    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).cardTheme.color,
      child: InkWell(
        onTap: () =>
            Get.toNamed(AppRoutes.taskDetail, arguments: {'task': task}),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 18 : 14),
          child: Row(
            children: [
              Icon(Icons.task_alt_rounded,
                  color: getCategoryColorByName(task.category),
                  size: isTablet ? 30 : 26),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isTablet ? 19 : 16,
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6)
                                : Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isTablet ? 4 : 2),
                    Text(
                      '${categoryToString(task.category)} - ${task.isCompleted ? 'Hoàn thành' : (task.dueDate.isBefore(DateTime.now()) ? 'Quá hạn' : 'Đang chờ')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                            fontSize: isTablet ? 14 : 12,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseEventCard(
      BuildContext context, ExpenseModel expense, bool isTablet) {
    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).cardTheme.color,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.expenseDetail,
            arguments: {'expenseId': expense.id}),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 18 : 14),
          child: Row(
            children: [
              Icon(Icons.payments_rounded,
                  color: getCategoryColorByName(expense.category),
                  size: isTablet ? 30 : 26),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isTablet ? 19 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isTablet ? 4 : 2),
                    Text(
                      '${NumberFormat.currency(locale: 'vi', symbol: '₫').format(expense.amount)} - ${categoryToString(expense.category)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                            fontSize: isTablet ? 14 : 12,
                          ),
                    ),
                    Text(
                      'Tâm trạng: ${getMoodEmoji(expense.mood, true)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                            fontSize: isTablet ? 14 : 12,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<DateTime, List<dynamic>> _buildEvents(
      List<TaskModel> tasks, List<ExpenseModel> expenses) {
    final events = <DateTime, List<dynamic>>{};
    for (var task in tasks) {
      final date =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      events[date] = events[date] ?? [];
      events[date]!.add(task);
    }
    for (var expense in expenses) {
      final date =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      events[date] = events[date] ?? [];
      events[date]!.add(expense);
    }
    return events;
  }
}

class CustomEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const CustomEmptyState({
    Key? key,
    required this.icon,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isTablet ? 120 : 80, color: Colors.grey.shade400)
                .animate()
                .scale(duration: 500.ms, curve: Curves.easeOutBack),
            SizedBox(height: isTablet ? 30 : 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: isTablet ? 24 : 18,
                  ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: isTablet ? 30 : 20),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: isTablet ? 30 : 20,
                          vertical: isTablet ? 15 : 10)),
                    ),
                child: Text(
                  buttonText!,
                  style: TextStyle(
                      fontSize: isTablet ? 18 : 16, color: Colors.white),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            ],
          ],
        ),
      ),
    );
  }
}
