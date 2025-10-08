import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:task_expense_manager/features/expense/presentation/pages/create_expense_screen.dart';
import 'package:task_expense_manager/features/expense/presentation/pages/expense_detail_screen.dart';
import 'package:task_expense_manager/features/expense/presentation/pages/expense_list_screen.dart';
import 'package:task_expense_manager/features/budget/presentation/pages/create_budget_screen.dart';
import 'package:task_expense_manager/features/profile/profile_screen.dart';
import 'package:task_expense_manager/features/task/presentation/page/create_task_screen.dart';
import 'package:task_expense_manager/features/task/presentation/page/task_detail_screen.dart';
import 'package:task_expense_manager/features/task/presentation/page/task_list_screen.dart';
import 'package:task_expense_manager/features/reports/presentation/pages/reports_screen.dart';
import 'package:task_expense_manager/routes/main_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/auth/presentation/pages/forgot_password_screen.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../core/utils/snackbar_helper.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String task = '/task';
  static const String taskDetail = '/task-detail';
  static const String createTask = '/task-create';
  static const String expense = '/expense';
  static const String expenseDetail = '/expense-detail';
  static const String createExpense = '/expense-create';
  static const String createBudget = '/budget-create';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String reports = '/reports';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: main, page: () => MainScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: task, page: () => TaskListScreen()),
    GetPage(
        name: taskDetail,
        page: () {
          final task = Get.arguments?['task'];
          if (task == null) {
            Get.back();
            SnackbarHelper.showError('Không tìm thấy thông tin công việc');
            return Container();
          }
          return TaskDetailScreen(task: task);
        }),
    GetPage(name: createTask, page: () => CreateTaskScreen()),
    GetPage(name: expense, page: () => ExpenseListScreen()),
    GetPage(
        name: expenseDetail,
        page: () {
          final expenseId = Get.arguments?['expenseId'] as String?;
          if (expenseId == null) {
            Get.back();
            SnackbarHelper.showError('Không tìm thấy thông tin chi tiêu');
            return Container();
          }
          return ExpenseDetailScreen(expenseId: expenseId);
        }),
    GetPage(name: createExpense, page: () => CreateExpenseScreen()),
    GetPage(name: createBudget, page: () => CreateBudgetScreen()),
    GetPage(name: settings, page: () => ProfileScreen()),
    GetPage(name: reports, page: () => ReportsScreen()),
  ];
}
