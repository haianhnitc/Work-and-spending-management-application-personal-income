import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/features/expense/presentation/controllers/expense_controller.dart';
import 'package:task_expense_manager/features/task/presentation/controllers/task_controller.dart';
import '../../core/services/ai_service.dart';

class AIController extends GetxController {
  late final AIService _aiService;
  late final TaskController _taskController;
  late final ExpenseController _expenseController;

  final RxString expenseAnalysis = ''.obs;
  final RxString taskAnalysis = ''.obs;
  final RxString smartSuggestions = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isExpenseLoading = false.obs;
  final RxBool isTaskLoading = false.obs;
  final RxBool isPredictiveLoading = false.obs;

  final RxBool isInitialized = false.obs;
  final RxMap<String, dynamic> predictiveData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      _initializeServices();
    });
  }

  void _initializeServices() {
    try {
      _aiService = Get.find<AIService>();
      _taskController = Get.find<TaskController>();
      _expenseController = Get.find<ExpenseController>();

      isInitialized.value = true;
      print('✅ AIController initialized successfully');

      _generateDailySuggestions();
    } catch (e) {
      print('❌ Lỗi khởi tạo AIController: $e');
      isInitialized.value = false;

      Future.delayed(Duration(milliseconds: 500), () {
        if (Get.context != null) {
          Get.snackbar('Thông báo', 'AI Service đang được khởi tạo...');
        }
      });
    }
  }

  Future<void> analyzeExpenses() async {
    if (!isInitialized.value) {
      _showInitializationError();
      return;
    }

    isExpenseLoading.value = true;
    try {
      final analysis =
          await _aiService.analyzeExpenses(_expenseController.expenses);
      expenseAnalysis.value = analysis;

      Get.snackbar(
        'Thành công',
        'Đã hoàn thành phân tích chi tiêu',
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      _showError('Không thể phân tích chi tiêu: $e');
    } finally {
      isExpenseLoading.value = false;
    }
  }

  Future<void> analyzeTasks() async {
    if (!isInitialized.value) {
      _showInitializationError();
      return;
    }

    isTaskLoading.value = true;
    try {
      final analysis = await _aiService.analyzeTasks(_taskController.tasks);
      taskAnalysis.value = analysis;

      Get.snackbar(
        'Thành công',
        'Đã hoàn thành phân tích công việc',
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      _showError('Không thể phân tích công việc: $e');
    } finally {
      isTaskLoading.value = false;
    }
  }

  Future<void> generateSmartSuggestions() async {
    if (!isInitialized.value) {
      _showInitializationError();
      return;
    }

    isLoading.value = true;
    try {
      final suggestions = await _aiService.getSmartSuggestions(
        _taskController.tasks,
        _expenseController.expenses,
      );
      smartSuggestions.value = suggestions;

      Get.snackbar(
        'Cập nhật',
        'Đã tạo gợi ý mới từ AI',
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      _showError('Không thể tạo gợi ý: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPredictiveAnalysis() async {
    if (!isInitialized.value) {
      _showInitializationError();
      return;
    }

    isPredictiveLoading.value = true;
    try {
      final analysis = await _aiService.getPredictiveAnalysis(
        _taskController.tasks,
        _expenseController.expenses,
      );
      predictiveData.value = analysis;

      Get.snackbar(
        'Hoàn thành',
        'Đã phân tích xu hướng và dự đoán',
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      _showError('Không thể phân tích dự đoán: $e');
    } finally {
      isPredictiveLoading.value = false;
    }
  }

  void _generateDailySuggestions() {
    if (!isInitialized.value) return;

    Future.delayed(Duration(seconds: 2), () {
      if (isInitialized.value) {
        generateSmartSuggestions();
      }
    });
  }

  String getContextualSuggestion() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 9) {
      return "🌅 Buổi sáng tốt lành! Đây là thời điểm lý tưởng để lập kế hoạch và bắt đầu các công việc quan trọng. Hãy kiểm tra danh sách task hôm nay và ưu tiên 2-3 việc quan trọng nhất.";
    } else if (hour >= 9 && hour < 12) {
      return "☕ Thời gian vàng cho công việc! Năng suất cao nhất trong ngày. Tập trung hoàn thành deep work, tắt thông báo để không bị phân tâm. Nhớ ghi lại chi tiêu nếu có.";
    } else if (hour >= 12 && hour < 14) {
      return "🍽️ Giờ nghỉ trưa! Thời gian thư giãn và nạp năng lượng. Đây cũng là lúc tốt để review công việc buổi sáng và lên kế hoạch cho buổi chiều. Nhớ ghi chi tiêu ăn trưa nhé!";
    } else if (hour >= 14 && hour < 18) {
      return "🚀 Buổi chiều năng động! Thời gian xử lý email, meeting và hoàn thành các task còn lại. Có thể brainstorm và làm việc nhóm hiệu quả. Kiểm tra tiến độ công việc.";
    } else if (hour >= 18 && hour < 21) {
      return "🏠 Thời gian cân bằng! Kết thúc công việc, dành thời gian cho bản thân và gia đình. Đây là lúc tốt để tổng kết chi tiêu trong ngày và chuẩn bị cho ngày mai.";
    } else {
      return "🌙 Buổi tối yên bình! Thời gian thư giãn, đọc sách hoặc học kỹ năng mới. Review toàn bộ ngày hôm nay - công việc đã hoàn thành và chi tiêu. Lập kế hoạch cụ thể cho ngày mai.";
    }
  }

  void _showError(String message) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (Get.context != null) {
        Get.snackbar(
          'Lỗi',
          message,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    });
  }

  void _showInitializationError() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (Get.context != null) {
        Get.snackbar(
          'Thông báo',
          'AI Service đang được khởi tạo, vui lòng đợi...',
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    });
  }
}
