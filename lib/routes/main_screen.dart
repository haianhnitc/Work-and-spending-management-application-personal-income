import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/features/ai/ai_insight_screen.dart';

import '../features/calendar/presentation/pages/calendar_screen.dart';
import '../features/expense/presentation/pages/expense_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/task/presentation/page/task_list_screen.dart';
import '../features/home/home_screen.dart';
import '../features/budget/presentation/pages/budget_list_screen.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class MainScreen extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  final List<Widget> screens = [
    HomeScreen(),
    TaskListScreen(),
    ExpenseListScreen(),
    BudgetListScreen(),
    CalendarScreen(),
    AIInsightsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: BottomNavigationBar(
            items: [
              _buildBottomNavigationBarItem(
                  context, Icons.home_rounded, 'Home', 0),
              _buildBottomNavigationBarItem(
                  context, Icons.task_alt_rounded, 'Task', 1),
              _buildBottomNavigationBarItem(
                  context, Icons.payments_rounded, 'Expense', 2),
              _buildBottomNavigationBarItem(
                  context, Icons.account_balance_wallet_rounded, 'Budget', 3),
              _buildBottomNavigationBarItem(
                  context, Icons.calendar_today_rounded, 'Calendar', 4),
              _buildBottomNavigationBarItem(context, Icons.psychology, 'AI', 5),
              _buildBottomNavigationBarItem(
                  context, Icons.person_rounded, 'Cá nhân', 6),
            ],
            currentIndex: controller.currentIndex.value,
            selectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => controller.changeTab(index),
            selectedLabelStyle:
                Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
            unselectedLabelStyle:
                Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      BuildContext context, IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon,
          size: controller.currentIndex.value == index ? 28 : 24,
          color: controller.currentIndex.value == index
              ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
              : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
      label: label,
    );
  }
}
