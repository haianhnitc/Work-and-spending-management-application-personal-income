import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_expense_manager/core/services/ai_service.dart';
import 'package:task_expense_manager/core/services/file_export_service.dart';
import 'package:task_expense_manager/features/ai/ai_controller.dart';
import 'package:task_expense_manager/features/expense/data/datasource/expense_datasource.dart';
import 'package:task_expense_manager/features/expense/data/repository/expense_repository_impl.dart';
import 'package:task_expense_manager/features/expense/domain/repository/expense_repository.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/auth_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/expense/domain/usecase/expense_usecase.dart';
import '../../features/expense/presentation/controllers/expense_controller.dart';
import '../../features/task/presentation/controllers/task_controller.dart';
import '../../features/budget/data/datasources/budget_remote_data_source.dart';
import '../../features/budget/data/repository/budget_repository_impl.dart';
import '../../features/budget/domain/repository/budget_repository.dart';
import '../../features/budget/domain/usecase/budget_usecase.dart';
import '../../features/budget/presentation/controllers/budget_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    try {
      if (Firebase.apps.isEmpty) {
        throw Exception(
            'Firebase chưa được khởi tạo. Hãy gọi Firebase.initializeApp() trước.');
      }

      print('🔥 Bắt đầu khởi tạo dependencies...');

      print('🤖 Khởi tạo AIService cơ bản');
      Get.put(AIService(), permanent: true);

      print('📁 Khởi tạo FileExportService');
      Get.put(FileExportService(), permanent: true);

      Get.lazyPut<BudgetRemoteDataSource>(() {
        print('📦 Khởi tạo BudgetRemoteDataSource');
        return BudgetRemoteDataSourceImpl();
      }, fenix: true);

      Get.lazyPut(() {
        print('📦 Khởi tạo AuthRepository');
        return AuthRepository();
      }, fenix: true);

      Get.lazyPut<ExpenseRepository>(() {
        print('📦 Khởi tạo ExpenseRepository');
        return ExpenseRepositoryImpl(ExpenseDatasourceImpl());
      }, fenix: true);

      Get.lazyPut<BudgetRepository>(() {
        print('📦 Khởi tạo BudgetRepository');
        return BudgetRepositoryImpl(Get.find<BudgetRemoteDataSource>());
      }, fenix: true);

      Get.lazyPut(() {
        print('📦 Khởi tạo AuthUseCase');
        return AuthUseCase(Get.find());
      }, fenix: true);

      Get.lazyPut(() {
        print('📦 Khởi tạo ExpenseUseCase');
        return ExpenseUseCase(Get.find<ExpenseRepository>());
      }, fenix: true);

      Get.lazyPut(() {
        print('📦 Khởi tạo BudgetUseCase');
        return BudgetUseCase(Get.find<BudgetRepository>());
      }, fenix: true);

      Get.lazyPut(() {
        print('🎮 Khởi tạo AuthController');
        return AuthController(Get.find());
      }, fenix: true);

      Get.lazyPut(() {
        print('🎮 Khởi tạo ExpenseController');
        return ExpenseController(Get.find<ExpenseUseCase>());
      }, fenix: true);

      Get.lazyPut(() {
        print('🎮 Khởi tạo TaskController');
        return TaskController(Get.find());
      }, fenix: true);

      Get.lazyPut(() {
        print('🎮 Khởi tạo BudgetController');
        return BudgetController(Get.find<BudgetUseCase>());
      }, fenix: true);

      Get.put(() {
        print('🤖 Khởi tạo AIController');
        Get.find<TaskController>();
        Get.find<ExpenseController>();
        Get.find<BudgetController>();
        return AIController();
      }, permanent: true);

      print('✅ Hoàn thành khởi tạo tất cả dependencies');
    } catch (e) {
      print('❌ Lỗi khi khởi tạo dependencies: $e');
      rethrow;
    }
  }
}
