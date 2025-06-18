import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import '../expense/data/models/expense_model.dart';
import '../expense/presentation/controllers/expense_controller.dart';
import '../task/data/models/task_model.dart';
import '../task/presentation/controllers/task_controller.dart';
import '../../routes/app_routes.dart'; // Import AppRoutes

class CalendarScreen extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final Rx<DateTime> _focusedDay = DateTime.now().obs;
  final Rx<DateTime?> _selectedDay = Rx<DateTime?>(null);
  final Rx<CalendarFormat> _calendarFormat = CalendarFormat.month.obs;
  final RxBool _showTasks = true.obs; // Toggle for showing tasks
  final RxBool _showExpenses = true.obs; // Toggle for showing expenses

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Lịch', style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 8),
            child: ToggleButtons(
              isSelected: [_showTasks.value, _showExpenses.value],
              onPressed: (index) {
                if (index == 0) {
                  _showTasks.toggle();
                } else {
                  _showExpenses.toggle();
                }
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Theme.of(context).colorScheme.primary,
              fillColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
              selectedBorderColor: Theme.of(context).colorScheme.primary,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                  child: Row(
                    children: [
                      Icon(Icons.task_alt_rounded, size: isTablet ? 24 : 20),
                      SizedBox(width: isTablet ? 8 : 4),
                      Text('Công việc',
                          style: TextStyle(fontSize: isTablet ? 16 : 14)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                  child: Row(
                    children: [
                      Icon(Icons.payments_rounded, size: isTablet ? 24 : 20),
                      SizedBox(width: isTablet ? 8 : 4),
                      Text('Chi tiêu',
                          style: TextStyle(fontSize: isTablet ? 16 : 14)),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
          ),
        ],
      ),
      body: Obx(() {
        final allEvents =
            _buildEvents(taskController.tasks, expenseController.expenses);
        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(isTablet ? 20 : 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay.value,
                calendarFormat: _calendarFormat.value,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay.value, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  _selectedDay.value = selectedDay;
                  _focusedDay.value = focusedDay;
                },
                onPageChanged: (focusedDay) {
                  _focusedDay.value = focusedDay;
                },
                eventLoader: (day) {
                  List<dynamic> events =
                      allEvents[DateTime(day.year, day.month, day.day)] ?? [];
                  if (!_showTasks.value) {
                    events = events.where((e) => e is! TaskModel).toList();
                  }
                  if (!_showExpenses.value) {
                    events = events.where((e) => e is! ExpenseModel).toList();
                  }
                  return events;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child:
                            _buildEventsMarker(date, events, isTablet, context),
                      );
                    }
                    return null;
                  },
                  selectedBuilder: (context, date, focusedDay) {
                    return Container(
                      margin: EdgeInsets.all(isTablet ? 6 : 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 20 : 16),
                      ),
                    );
                  },
                  todayBuilder: (context, date, focusedDay) {
                    return Container(
                      margin: EdgeInsets.all(isTablet ? 6 : 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5),
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 20 : 16),
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
                                ? Colors.redAccent
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 15 : 13),
                      ),
                    );
                  },
                  // Add more custom builders for header, week numbers if needed
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: isTablet ? 30 : 24),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: isTablet ? 30 : 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .cardTheme
                        .color, // Consistent with card background
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  headerPadding:
                      EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
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
                          fontSize: isTablet ? 16 : 14),
                  weekendStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                          color: Colors.red.shade400,
                          fontSize: isTablet ? 16 : 14),
                ),
                rowHeight: isTablet ? 60 : 45, // Adjust row height
                // Other calendar settings
                availableGestures: AvailableGestures.horizontalSwipe,
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Expanded(
              child: _buildEventList(
                  context, allEvents, _selectedDay.value, isTablet),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
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
                      Get.back(); // Close bottom sheet
                      Get.toNamed(AppRoutes.createTask, arguments: {
                        'date': _selectedDay.value ?? DateTime.now()
                      });
                    },
                    icon: Icon(Icons.add_task_rounded,
                        color: Colors.white, size: isTablet ? 30 : 24),
                    label: Text('Thêm công việc',
                        style: TextStyle(
                            color: Colors.white, fontSize: isTablet ? 20 : 17)),
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              minimumSize: MaterialStateProperty.all(Size(
                                  double.infinity,
                                  isTablet ? 60 : 50)), // Full width
                            ),
                  ).animate().scale(duration: 200.ms, delay: 100.ms),
                  SizedBox(height: isTablet ? 20 : 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back(); // Close bottom sheet
                      Get.toNamed(AppRoutes.createExpense, arguments: {
                        'date': _selectedDay.value ?? DateTime.now()
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
                              minimumSize: MaterialStateProperty.all(Size(
                                  double.infinity,
                                  isTablet ? 60 : 50)), // Full width
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

    final filteredEvents = events.where((event) {
      if (event is TaskModel) {
        return _showTasks.value;
      } else if (event is ExpenseModel) {
        return _showExpenses.value;
      }
      return false;
    }).toList();

    if (filteredEvents.isEmpty) return const SizedBox.shrink();

    // Show different markers for tasks and expenses, or a combined count
    return Container(
      width: isTablet ? 32 : 24,
      height: isTablet ? 32 : 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${filteredEvents.length}',
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
        // No button needed here
      );
    }

    final eventsForSelectedDay = allEvents[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];

    final filteredEventsForSelectedDay = eventsForSelectedDay.where((event) {
      if (event is TaskModel) {
        return _showTasks.value;
      } else if (event is ExpenseModel) {
        return _showExpenses.value;
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
                      Get.back(); // Close bottom sheet
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
                              minimumSize: MaterialStateProperty.all(Size(
                                  double.infinity,
                                  isTablet ? 60 : 50)), // Full width
                            ),
                  ).animate().scale(duration: 200.ms, delay: 100.ms),
                  SizedBox(height: isTablet ? 20 : 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back(); // Close bottom sheet
                      Get.toNamed(AppRoutes.createExpense,
                          arguments: {'date': selectedDay});
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
                              minimumSize: MaterialStateProperty.all(Size(
                                  double.infinity,
                                  isTablet ? 60 : 50)), // Full width
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
                  color: _getCategoryColorByName(task.category),
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
                      '${_categoryToString(task.category)} - ${task.isCompleted ? 'Hoàn thành' : (task.dueDate.isBefore(DateTime.now()) ? 'Quá hạn' : 'Đang chờ')}',
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
            arguments: {'expense': expense}),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 18 : 14),
          child: Row(
            children: [
              Icon(Icons.payments_rounded,
                  color: _getCategoryColorByName(expense.category),
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
                      '${NumberFormat.currency(locale: 'vi', symbol: '₫').format(expense.amount)} - ${_categoryToString(expense.category)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                            fontSize: isTablet ? 14 : 12,
                          ),
                    ),
                    Text(
                      'Tâm trạng: ${_getMoodEmoji(expense.mood)}',
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

  String _getMoodEmoji(Mood mood) {
    switch (mood) {
      case Mood.happy:
        return 'Vui 😊';
      case Mood.neutral:
        return 'Bình thường 😐';
      case Mood.sad:
        return 'Buồn 😞';
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
      case 'work':
        return 'Công việc';
      case 'personal':
        return 'Cá nhân';
      default:
        return category;
    }
  }

  Color _getCategoryColorByName(String categoryName) {
    switch (categoryName) {
      case 'study':
        return const Color(0xFF4A90E2); // Blue
      case 'lifestyle':
        return const Color(0xFF50C878); // Emerald Green
      case 'skill':
        return const Color(0xFFF39C12); // Orange
      case 'entertainment':
        return const Color(0xFFE74C3C); // Red
      case 'work':
        return const Color(0xFF8E44AD); // Amethyst
      case 'personal':
        return const Color(0xFF3498DB); // Peter River Blue
      default:
        return Colors.grey.shade600;
    }
  }
}

// Assume CustomEmptyState is defined elsewhere, e.g., in core/widgets
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
