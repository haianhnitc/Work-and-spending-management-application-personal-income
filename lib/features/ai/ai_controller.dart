import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/features/expense/presentation/controllers/expense_controller.dart';
import 'package:task_expense_manager/features/task/presentation/controllers/task_controller.dart';
import 'package:task_expense_manager/features/budget/presentation/controllers/budget_controller.dart';
import '../../core/services/ai_service.dart';
import '../../core/utils/snackbar_helper.dart';
import 'models/chat_message.dart';

class AIController extends GetxController {
  late final AIService _aiService;
  late final TaskController _taskController;
  late final ExpenseController _expenseController;
  late final BudgetController _budgetController;

  final RxString expenseAnalysis = ''.obs;
  final RxString taskAnalysis = ''.obs;
  final RxString smartSuggestions = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isExpenseLoading = false.obs;
  final RxBool isTaskLoading = false.obs;
  final RxBool isPredictiveLoading = false.obs;

  final RxBool isInitialized = false.obs;
  final RxMap<String, dynamic> predictiveData = <String, dynamic>{}.obs;

  final RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  final RxBool isChatLoading = false.obs;
  final TextEditingController chatTextController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

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
      _budgetController = Get.find<BudgetController>();

      // Set controllers for AI service to access user data
      _aiService.setControllers(
        taskController: _taskController,
        expenseController: _expenseController,
        budgetController: _budgetController,
      );

      isInitialized.value = true;

      _generateDailySuggestions();
      _initializeChat();
    } catch (e) {
      print('❌ Lỗi khởi tạo AIController: $e');
      isInitialized.value = false;

      Future.delayed(Duration(milliseconds: 500), () {
        if (Get.context != null) {
          SnackbarHelper.showInfo('AI Service đang được khởi tạo...');
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

      SnackbarHelper.showSuccess('Đã hoàn thành phân tích chi tiêu');
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

      SnackbarHelper.showSuccess('Đã hoàn thành phân tích công việc');
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

      SnackbarHelper.showInfo('Đã tạo gợi ý mới từ AI');
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

      SnackbarHelper.showSuccess('Đã phân tích xu hướng và dự đoán');
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
    SnackbarHelper.showError(message);
  }

  void _showInitializationError() {
    SnackbarHelper.showInfo('AI Service đang được khởi tạo, vui lòng đợi...');
  }

  void _initializeChat() {
    chatMessages.add(ChatMessage.ai(
      "🤖 Xin chào! Tôi là AI Assistant thông minh của bạn!\n\n"
      "Tôi có thể giúp bạn:\n"
      "💰 Phân tích chi tiêu dựa trên dữ liệu thực của bạn\n"
      "⚡ Quản lý công việc hiệu quả theo lịch trình\n"
      "🎯 Theo dõi ngân sách và đưa ra gợi ý tiết kiệm\n"
      "📊 Dự đoán xu hướng tài chính cá nhân\n"
      "💬 Trả lời câu hỏi dựa trên ngữ cảnh của bạn\n\n"
      "Tôi đã truy cập được dữ liệu task, chi tiêu và ngân sách của bạn để đưa ra lời khuyên chính xác. Bạn muốn tôi hỗ trợ gì hôm nay?",
    ));
  }

  Future<void> sendChatMessage(String message) async {
    if (message.trim().isEmpty) return;

    chatMessages.add(ChatMessage.user(message.trim()));

    chatTextController.clear();
    _scrollToBottom();

    isChatLoading.value = true;
    final typingMessage = ChatMessage.typing();
    chatMessages.add(typingMessage);
    _scrollToBottom();

    try {
      final response = await _aiService.getChatResponse(message.trim());

      chatMessages.removeWhere((msg) => msg.type == MessageType.typing);

      final aiMessage =
          response.isNotEmpty ? response : _getDefaultResponse(message);
      chatMessages.add(ChatMessage.ai(aiMessage));
    } catch (e) {
      print('❌ Lỗi chat: $e');
      chatMessages.removeWhere((msg) => msg.type == MessageType.typing);

      chatMessages.add(ChatMessage.ai(_getDefaultResponse(message)));
    }

    isChatLoading.value = false;
    _scrollToBottom();
  }

  String _getDefaultResponse(String message) {
    final lowercaseMessage = message.toLowerCase();

    if (lowercaseMessage.contains('xin chào') ||
        lowercaseMessage.contains('hello') ||
        lowercaseMessage.contains('hi')) {
      return "🤖 Xin chào! Tôi là AI Assistant của bạn!\n\n"
          "Tôi có thể giúp bạn quản lý tài chính và công việc thông minh.\n"
          "Hôm nay tôi có thể hỗ trợ gì cho bạn?";
    }

    return "🤔 Xin lỗi, tôi đang gặp sự cố kỹ thuật tạm thời!\n\n"
        "Vui lòng thử lại sau hoặc mô tả chi tiết hơn về những gì bạn cần hỗ trợ.\n\n"
        "💡 Tôi có thể giúp bạn:\n"
        "• Phân tích chi tiêu và đưa ra gợi ý tiết kiệm\n"
        "• Quản lý công việc hiệu quả\n"
        "• Dự đoán xu hướng tài chính";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clearChat() {
    chatMessages.clear();
    _initializeChat();
  }

  @override
  void onClose() {
    chatTextController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }
}
