import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarToggleButtons extends StatelessWidget {
  final CalendarController calendarController;

  const CalendarToggleButtons({
    super.key,
    required this.calendarController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ToggleButtons(
            isSelected: [
              calendarController.showTasks.value,
              calendarController.showExpenses.value
            ],
            onPressed: (index) {
              if (index == 0) {
                calendarController.showTasks.toggle();
              } else {
                calendarController.showExpenses.toggle();
              }
            },
            constraints: BoxConstraints(
              minHeight: 36,
              minWidth: 50,
            ),
            borderRadius: BorderRadius.circular(10),
            selectedColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.onSurface
                : Colors.white,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.2)
                : Colors.white.withOpacity(0.3),
            borderColor: Colors.transparent,
            selectedBorderColor: Colors.transparent,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.task_alt_rounded,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.payments_rounded,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
