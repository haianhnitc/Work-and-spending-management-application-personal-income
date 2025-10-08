import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../expense/data/models/expense_model.dart';
import '../../../task/data/models/task_model.dart';
import '../../../../routes/app_routes.dart';

class CalendarEventList extends StatelessWidget {
  final Map<DateTime, List<dynamic>> allEvents;
  final DateTime selectedDay;

  const CalendarEventList({
    super.key,
    required this.allEvents,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final events = allEvents[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];

    if (events.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, events.length),
        SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventItem(context, event, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int eventCount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_note,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Sự kiện ngày ${selectedDay.day}/${selectedDay.month}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$eventCount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context, 0),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event_busy_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Không có sự kiện nào',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hãy thêm task hoặc expense cho ngày này',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(BuildContext context, dynamic event, int index) {
    final isTask = event is TaskModel;
    final isExpense = event is ExpenseModel;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _onEventTap(event),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getEventColor(event).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getEventIcon(event),
                    color: _getEventColor(event),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getEventTitle(event),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getEventColor(event).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isTask ? 'Task' : 'Expense',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _getEventColor(event),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            _getEventSubtitle(event),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isExpense)
                  Text(
                    '${event.amount.toStringAsFixed(0)} VND',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                if (isTask)
                  Icon(
                    event.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: event.isCompleted ? Colors.green : Colors.grey,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.3, end: 0);
  }

  Color _getEventColor(dynamic event) {
    if (event is TaskModel) {
      return event.isCompleted ? Colors.green : Colors.blue;
    } else if (event is ExpenseModel) {
      return Colors.orange;
    }
    return Colors.grey;
  }

  IconData _getEventIcon(dynamic event) {
    if (event is TaskModel) {
      return event.isCompleted ? Icons.task_alt : Icons.task_outlined;
    } else if (event is ExpenseModel) {
      return Icons.payment;
    }
    return Icons.event;
  }

  String _getEventTitle(dynamic event) {
    if (event is TaskModel) {
      return event.title;
    } else if (event is ExpenseModel) {
      return event.title;
    }
    return 'Unknown Event';
  }

  String _getEventSubtitle(dynamic event) {
    if (event is TaskModel) {
      return event.isCompleted ? 'Hoàn thành' : 'Chưa hoàn thành';
    } else if (event is ExpenseModel) {
      return event.category;
    }
    return '';
  }

  void _onEventTap(dynamic event) {
    if (event is TaskModel) {
      Get.toNamed(AppRoutes.taskDetail, arguments: {'task': event});
    } else if (event is ExpenseModel) {
      Get.toNamed(AppRoutes.expenseDetail, arguments: {'expenseId': event.id});
    }
  }
}
