import 'package:get/get.dart';
import 'package:task_expense_manager/dependency_injection/main_config.dart';
import '../../../../core/constants/app_enums.dart';
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

  // Computed properties for filtered data
  List<TaskModel> get filteredTasks {
    return tasks.where((task) {
      final matchesCategory = selectedCategory.value.isEmpty ||
          task.category == displayNameToCategory(selectedCategory.value);
      final matchesSearch = searchQuery.value.isEmpty ||
          task.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Map<String, int> get categoryTotals {
    final categoryTotals = <String, int>{};
    
    if (selectedCategory.value.isNotEmpty) {
      // Convert display name to category key for comparison
      final categoryKey = displayNameToCategory(selectedCategory.value);
      
      // Có filter category: chỉ hiển thị category đó với data đã filter theo search
      final categoryTasks = tasks.where((task) {
        final matchesCategory = task.category == categoryKey;
        final matchesSearch = searchQuery.value.isEmpty ||
            task.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        return matchesCategory && matchesSearch;
      });
      
      if (categoryTasks.isNotEmpty) {
        categoryTotals[categoryKey] = categoryTasks.length;
      }
    } else {
      // Không có filter category: hiển thị tất cả categories với data đã filter theo search
      for (var category in Category.values) {
        final categoryTasks = tasks.where((task) {
          final matchesCategory = task.category == category.name;
          final matchesSearch = searchQuery.value.isEmpty ||
              task.title.toLowerCase().contains(searchQuery.value.toLowerCase());
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
