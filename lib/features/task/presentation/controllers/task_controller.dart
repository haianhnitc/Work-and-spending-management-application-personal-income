import 'package:get/get.dart';
import 'package:task_expense_manager/dependency_injection/main_config.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/task_model.dart';
import '../../domain/usecase/task_usecase.dart';

class TaskController extends GetxController {
  final _taskUseCase = getIt<TaskUseCase>();
  final AuthController _authController;
  final tasks = <TaskModel>[].obs;
  final isLoading = true.obs;
  final selectedCategory = RxString('');
  final searchQuery = RxString('');
  final Rx<ChartType> selectedChartType = ChartType.pie.obs;
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
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
      isLoading.value = false;
      return;
    }
    _taskUseCase.getTasks(userId!).listen(
      (either) {
        isLoading.value = false;
        either.fold(
          (failure) =>
              SnackbarHelper.showError('Lỗi tải công việc: ${failure.message}'),
          (taskList) => tasks.assignAll(taskList),
        );
      },
      onError: (e) {
        isLoading.value = false;
        SnackbarHelper.showError('Không thể tải danh sách công việc');
      },
    );
  }

  Future<void> addTask(TaskModel task) async {
    if (userId == null) {
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
      return;
    }
    final result = await _taskUseCase.addTask(userId!, task);
    result.fold(
      (failure) =>
          SnackbarHelper.showError('Lỗi thêm công việc: ${failure.message}'),
      (_) {
        Get.back();
        Future.delayed(Duration(milliseconds: 300), () {
          SnackbarHelper.showSuccess('Đã thêm công việc "${task.title}"');
        });
      },
    );
  }

  Future<void> updateTask(TaskModel task) async {
    if (userId == null) {
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
      return;
    }
    final result = await _taskUseCase.updateTask(userId!, task);
    result.fold(
      (failure) => SnackbarHelper.showError(
          'Lỗi cập nhật công việc: ${failure.message}'),
      (_) {
        final index = tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          tasks[index] = task;
        }
        Get.back();
        Future.delayed(Duration(milliseconds: 300), () {
          SnackbarHelper.showSuccess('Đã cập nhật công việc "${task.title}"');
        });
      },
    );
  }

  Future<void> deleteTask(String taskId) async {
    if (userId == null) {
      SnackbarHelper.showError('Người dùng chưa đăng nhập');
      return;
    }
    final result = await _taskUseCase.deleteTask(userId!, taskId);
    result.fold(
      (failure) =>
          SnackbarHelper.showError('Lỗi xóa công việc: ${failure.message}'),
      (_) => SnackbarHelper.showSuccess('Đã xóa công việc thành công'),
    );
  }

  List<TaskModel> get filteredTasks {
    return tasks.where((task) {
      final matchesCategory = selectedCategory.value.isEmpty ||
          categoryToString(task.category) == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          task.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Map<String, int> get categoryTotals {
    final categoryTotals = <String, int>{};

    if (selectedCategory.value.isNotEmpty) {
      final categoryTasks = tasks.where((task) {
        final matchesCategory =
            categoryToString(task.category) == selectedCategory.value;
        final matchesSearch = searchQuery.value.isEmpty ||
            task.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        return matchesCategory && matchesSearch;
      });

      if (categoryTasks.isNotEmpty) {
        categoryTotals[selectedCategory.value] = categoryTasks.length;
      }
    } else {
      for (var category in Category.values) {
        final categoryTasks = tasks.where((task) {
          final matchesCategory = task.category == category.name;
          final matchesSearch = searchQuery.value.isEmpty ||
              task.title
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase());
          return matchesCategory && matchesSearch;
        });

        if (categoryTasks.isNotEmpty) {
          categoryTotals[category.name] = categoryTasks.length;
        }
      }
    }

    return categoryTotals;
  }

  int get completedCount {
    return filteredTasks.where((task) => task.isCompleted).length;
  }

  int get totalCount {
    return filteredTasks.length;
  }

  double get completionProgress {
    return totalCount > 0 ? completedCount / totalCount : 0.0;
  }

  void setCategoryFilter(String category) {
    selectedCategory.value = category;
  }

  void clearCategoryFilter() {
    selectedCategory.value = '';
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void setChartType(ChartType chartType) {
    selectedChartType.value = chartType;
  }
}
