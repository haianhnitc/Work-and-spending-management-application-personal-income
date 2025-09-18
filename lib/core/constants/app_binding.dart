import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_expense_manager/core/services/ai_service.dart';
import 'package:task_expense_manager/core/services/advanced_ai_service.dart';
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

      print('🧠 Khởi tạo AdvancedAIService');
      Get.put(AdvancedAIService(), permanent: true);

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

      print('🧠 Khởi tạo AdvancedAIService');
      Get.find<AdvancedAIService>();

      print('✅ Hoàn thành khởi tạo tất cả dependencies');
    } catch (e) {
      print('❌ Lỗi khi khởi tạo dependencies: $e');
      rethrow;
    }
  }

  static void checkServicesStatus() {
    try {
      print('🔍 Kiểm tra trạng thái services...');

      if (Get.isRegistered<AIService>()) {
        print('   - AIService: ✅ Đã đăng ký');
      } else {
        print('   - AIService: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<AdvancedAIService>()) {
        print('   - AdvancedAIService: ✅ Đã đăng ký');
      } else {
        print('   - AdvancedAIService: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<AuthController>()) {
        print('   - AuthController: ✅ Đã đăng ký');
      } else {
        print('   - AuthController: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<ExpenseController>()) {
        print('   - ExpenseController: ✅ Đã đăng ký');
      } else {
        print('   - ExpenseController: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<TaskController>()) {
        print('   - TaskController: ✅ Đã đăng ký');
      } else {
        print('   - TaskController: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<BudgetController>()) {
        print('   - BudgetController: ✅ Đã đăng ký');
      } else {
        print('   - BudgetController: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<AIController>()) {
        print('   - AIController: ✅ Đã đăng ký');
      } else {
        print('   - AIController: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<BudgetRepository>()) {
        print('   - BudgetRepository: ✅ Đã đăng ký');
      } else {
        print('   - BudgetRepository: ❌ Chưa đăng ký');
      }

      if (Get.isRegistered<ExpenseRepository>()) {
        print('   - ExpenseRepository: ✅ Đã đăng ký');
      } else {
        print('   - ExpenseRepository: ❌ Chưa đăng ký');
      }

      print('✅ Kiểm tra hoàn tất');
    } catch (e) {
      print('❌ Lỗi khi kiểm tra services: $e');
    }
  }
}
