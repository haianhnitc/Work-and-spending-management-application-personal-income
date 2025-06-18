import 'package:get/get.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/auth_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/expense/data/repository/expense_repository.dart';
import '../../features/expense/domain/usecase/expense_usecase.dart';
import '../../features/expense/presentation/controllers/expense_controller.dart';
import '../../features/task/presentation/controllers/task_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FirebaseService(), fenix: true);
    Get.lazyPut(() => AuthRepository(), fenix: true);
    Get.lazyPut(() => AuthUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => AuthController(Get.find()), fenix: true);

    // Get.lazyPut(() => TaskRepository(), fenix: true);
    // Get.lazyPut(() => TaskUseCase(Get.find()), fenix: true);
    // Get.lazyPut(() => TaskController(Get.find()), fenix: true);
    Get.lazyPut(() => TaskController(AuthController(Get.find())), fenix: true);

    Get.lazyPut(() => ExpenseRepository(), fenix: true);
    Get.lazyPut(() => ExpenseUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => ExpenseController(Get.find()), fenix: true);
  }
}
