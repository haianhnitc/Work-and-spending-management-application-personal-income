import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/calendar_controller.dart';
import '../../../expense/data/models/expense_model.dart';
import '../../../task/data/models/task_model.dart';

class CalendarWidget extends StatefulWidget {
  final CalendarController calendarController;
  final Map<DateTime, List<dynamic>> allEvents;

  const CalendarWidget({
    super.key,
    required this.calendarController,
    required this.allEvents,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_slideAnimation, _scaleAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Color(0xFF2D3748).withValues(alpha: 0.95)
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  if (!isDark)
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.05),
                      spreadRadius: 0,
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    _buildCalendarHeader(context, isDark),
                    _buildCalendarContent(context, isDark),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildCalendarHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color(0xFF4A5568),
                  Color(0xFF2D3748),
                ]
              : [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
        ),
      ),
      child: Obx(() => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMonthYearText(
                          widget.calendarController.focusedDay.value),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.8,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getWeekdayText(
                          widget.calendarController.selectedDay.value ??
                              widget.calendarController.focusedDay.value),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: (isDark
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface)
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildFormatToggle(context, isDark),
                  SizedBox(width: 12),
                  _buildTodayButton(context, isDark),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildFormatToggle(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Theme.of(context).primaryColor)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? Colors.white : Theme.of(context).primaryColor)
              .withValues(alpha: 0.2),
        ),
      ),
      child: Obx(() => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFormatButton(
                context,
                isDark,
                'Tháng',
                CalendarFormat.month,
                Icons.calendar_view_month_rounded,
              ),
              _buildFormatButton(
                context,
                isDark,
                '2 Tuần',
                CalendarFormat.twoWeeks,
                Icons.calendar_view_week_rounded,
              ),
            ],
          )),
    );
  }

  Widget _buildFormatButton(
    BuildContext context,
    bool isDark,
    String text,
    CalendarFormat format,
    IconData icon,
  ) {
    final isSelected = widget.calendarController.calendarFormat.value == format;

    return GestureDetector(
      onTap: () {
        widget.calendarController.calendarFormat.value = format;
        HapticFeedback.lightImpact();
        _scaleController.reverse().then((_) {
          _scaleController.forward();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? (isDark ? Colors.white : Theme.of(context).primaryColor)
                  : (isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface)
                      .withValues(alpha: 0.6),
            ),
            SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : Theme.of(context).primaryColor)
                    : (isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface)
                        .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayButton(BuildContext context, bool isDark) {
    final isToday =
        isSameDay(widget.calendarController.focusedDay.value, DateTime.now());

    return GestureDetector(
      onTap: () {
        if (!isToday) {
          widget.calendarController.focusedDay.value = DateTime.now();
          widget.calendarController.selectedDay.value = DateTime.now();
          HapticFeedback.mediumImpact();
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isToday
              ? null
              : LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                ),
          color: isToday
              ? (isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1))
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isToday
              ? null
              : [
                  BoxShadow(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Icon(
          Icons.today_rounded,
          size: 20,
          color: isToday
              ? (isDark
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface)
                  .withValues(alpha: 0.6)
              : Colors.white,
        ),
      ),
    );
  }

  Widget _buildCalendarContent(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(() => TableCalendar<dynamic>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: widget.calendarController.focusedDay.value,
            selectedDayPredicate: (day) =>
                isSameDay(widget.calendarController.selectedDay.value, day),
            calendarFormat: widget.calendarController.calendarFormat.value,
            eventLoader: (day) => _getEventsForDay(day),
            onDaySelected: (selectedDay, focusedDay) {
              widget.calendarController.selectedDay.value = selectedDay;
              widget.calendarController.focusedDay.value = focusedDay;
              HapticFeedback.lightImpact();
            },
            onPageChanged: (focusedDay) {
              widget.calendarController.focusedDay.value = focusedDay;
              _slideController.reset();
              _slideController.forward();
            },
            headerVisible: false,
            daysOfWeekVisible: true,
            daysOfWeekHeight: 40,
            rowHeight: 52,
            calendarStyle: _buildCalendarStyle(context, isDark),
            daysOfWeekStyle: _buildDaysOfWeekStyle(context, isDark),
            calendarBuilders: _buildCalendarBuilders(context, isDark),
            pageJumpingEnabled: true,
            pageAnimationDuration: Duration(milliseconds: 300),
            pageAnimationCurve: Curves.easeInOutCubic,
            availableGestures: AvailableGestures.all,
          )),
    );
  }

  CalendarStyle _buildCalendarStyle(BuildContext context, bool isDark) {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      todayTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      selectedDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      selectedTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
      defaultDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      defaultTextStyle: TextStyle(
        color: isDark ? Colors.white : Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      weekendDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      weekendTextStyle: TextStyle(
        color: isDark
            ? Colors.orange.withValues(alpha: 0.8)
            : Colors.orange.shade700,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      outsideDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      outsideTextStyle: TextStyle(
        color: (isDark ? Colors.white : Theme.of(context).colorScheme.onSurface)
            .withValues(alpha: 0.3),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      disabledTextStyle: TextStyle(
        color: (isDark ? Colors.white : Theme.of(context).colorScheme.onSurface)
            .withValues(alpha: 0.2),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      markersMaxCount: 3,
      markerDecoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      markersAnchor: 0.9,
      markersOffset: PositionedOffset(bottom: 4),
      cellPadding: EdgeInsets.all(4),
      cellMargin: EdgeInsets.all(2),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle(BuildContext context, bool isDark) {
    return DaysOfWeekStyle(
      weekdayStyle: TextStyle(
        color: (isDark ? Colors.white : Theme.of(context).colorScheme.onSurface)
            .withValues(alpha: 0.7),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      weekendStyle: TextStyle(
        color: isDark
            ? Colors.orange.withValues(alpha: 0.7)
            : Colors.orange.shade600,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  CalendarBuilders<dynamic> _buildCalendarBuilders(
      BuildContext context, bool isDark) {
    return CalendarBuilders<dynamic>(
      markerBuilder: (context, date, events) {
        if (events.isEmpty) return null;

        return Positioned(
          bottom: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: events.take(3).map((event) {
              Color markerColor = _getEventColor(event, context);

              return Container(
                width: 6,
                height: 6,
                margin: EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      markerColor,
                      markerColor.withValues(alpha: 0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: markerColor.withValues(alpha: 0.5),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ).animate().scale(
                    delay: (events.indexOf(event) * 100).ms,
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  );
            }).toList(),
          ),
        );
      },
    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    List<dynamic> events =
        widget.allEvents[DateTime(day.year, day.month, day.day)] ?? [];

    if (!widget.calendarController.showTasks.value) {
      events = events.where((e) => e is! TaskModel).toList();
    }
    if (!widget.calendarController.showExpenses.value) {
      events = events.where((e) => e is! ExpenseModel).toList();
    }

    return events;
  }

  Color _getEventColor(dynamic event, BuildContext context) {
    if (event is TaskModel) {
      return Colors.blue;
    } else if (event is ExpenseModel) {
      return Colors.green;
    }
    return Theme.of(context).primaryColor;
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getWeekdayText(DateTime date) {
    const weekdays = [
      'Chủ Nhật',
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy'
    ];
    return '${weekdays[date.weekday % 7]}, ${date.day}/${date.month}';
  }
}
