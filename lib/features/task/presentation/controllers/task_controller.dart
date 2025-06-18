import 'package:get/get.dart';
import 'package:task_expense_manager/dependency_injection/main_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/task_model.dart';
import '../../domain/usecase/task_usecase.dart';

class TaskController extends GetxController {
  final _taskUseCase = getIt<TaskUseCase>();
  final AuthController _authController;
  final tasks = <TaskModel>[].obs;
  final isLoading = true.obs;
  String? userId;

  TaskController(this._authController);

  @override
  void onInit() {
    super.onInit();
    userId = _authController.authUseCase.getCurrentUserId();
    if (userId != null) {
      fetchTasks();
    }
  }

  void fetchTasks() {
    if (userId == null) {
      Get.snackbar('error'.tr, 'noUserLoggedIn'.tr);
      isLoading.value = false;
      return;
    }
    _taskUseCase.getTasks(userId!).listen(
      (either) {
        isLoading.value = false;
        either.fold(
          (failure) => Get.snackbar('error'.tr, failure.message),
          (taskList) => tasks.assignAll(taskList),
        );
      },
      onError: (e) {
        isLoading.value = false;
        Get.snackbar('error'.tr, 'failedToFetchTasks'.tr);
      },
    );
  }

  Future<void> addTask(TaskModel task) async {
    if (userId == null) {
      Get.snackbar('error'.tr, 'noUserLoggedIn'.tr);
      return;
    }
    final result = await _taskUseCase.addTask(userId!, task);
    result.fold(
      (failure) => Get.snackbar('error'.tr, failure.message),
      (_) => Get.snackbar('success'.tr, 'taskCreated'.tr),
    );
  }

  Future<void> updateTask(TaskModel task) async {
    if (userId == null) {
      Get.snackbar('error'.tr, 'noUserLoggedIn'.tr);
      return;
    }
    final result = await _taskUseCase.updateTask(userId!, task);
    result.fold(
      (failure) => Get.snackbar('error'.tr, failure.message),
      (_) => Get.snackbar('success'.tr, 'taskUpdated'.tr),
    );
  }

  Future<void> deleteTask(String taskId) async {
    if (userId == null) {
      Get.snackbar('error'.tr, 'noUserLoggedIn'.tr);
      return;
    }
    final result = await _taskUseCase.deleteTask(userId!, taskId);
    result.fold(
      (failure) => Get.snackbar('error'.tr, failure.message),
      (_) => Get.snackbar('success'.tr, 'taskDeleted'.tr),
    );
  }
}
