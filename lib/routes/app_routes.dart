import 'package:get/get.dart';
import 'package:task_expense_manager/features/expense/presentation/pages/create_expense_screen.dart';
import 'package:task_expense_manager/features/expense/presentation/pages/expense_detail_screen.dart';
import 'package:task_expense_manager/features/expense/presentation/pages/expense_list_screen.dart';
import 'package:task_expense_manager/features/profile/profile_screen.dart';
import 'package:task_expense_manager/features/task/presentation/page/create_task_screen.dart';
import 'package:task_expense_manager/features/task/presentation/page/task_detail_screen.dart';
import 'package:task_expense_manager/features/task/presentation/page/task_list_screen.dart';
import 'package:task_expense_manager/routes/main_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/home/home_screen.dart';

class AppRoutes {
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String task = '/task';
  static const String taskDetail = '/task-detail';
  static const String createTask = '/task-create';
  static const String expense = '/expense';
  static const String expenseDetail = '/expense-detail';
  static const String createExpense = '/expense-create';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static List<GetPage> routes = [
    GetPage(name: main, page: () => MainScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: task, page: () => TaskListScreen()),
    GetPage(
        name: taskDetail,
        page: () => TaskDetailScreen(task: Get.arguments['task'])),
    GetPage(name: createTask, page: () => CreateTaskScreen()),
    GetPage(name: expense, page: () => ExpenseListScreen()),
    GetPage(
        name: expenseDetail,
        page: () => ExpenseDetailScreen(expense: Get.arguments['expense'])),
    GetPage(name: createExpense, page: () => CreateExpenseScreen()),
    GetPage(name: settings, page: () => ProfileScreen()),
  ];
}
