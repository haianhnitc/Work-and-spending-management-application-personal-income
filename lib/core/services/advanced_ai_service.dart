import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:get/get.dart';
import '../../features/task/data/models/task_model.dart';
import '../../features/expense/data/models/expense_model.dart';

class AdvancedAIService extends GetxService {
  late GenerativeModel _model;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAI();
  }

  void _initializeAI() {
    try {
      const apiKey = 'AIzaSyDsShbeCpvzODnWddy2x87ZB27teEKvFvo';
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      isInitialized.value = true;
      print('✅ AdvancedAIService initialized successfully');
    } catch (e) {
      print('❌ Error initializing AdvancedAIService: $e');
      isInitialized.value = false;
    }
  }

  Future<Map<String, dynamic>> predictFutureExpenses(
      List<ExpenseModel> expenses, int monthsAhead) async {
    try {
      if (!isInitialized.value) throw Exception('AI Service not initialized');

      final expenseData = _formatExpenseDataForPrediction(expenses);

      final prompt = '''
      Dựa trên dữ liệu chi tiêu sau, hãy dự đoán chi tiêu cho $monthsAhead tháng tới:
      
      $expenseData
      
      Hãy trả về kết quả theo format JSON:
      {
        "predictions": [
          {
            "month": "Tháng 1/2024",
            "predictedAmount": 5000000,
            "confidence": 85,
            "factors": ["Tết Nguyên đán", "Mua sắm cuối năm"]
          }
        ],
        "trends": "tăng/giảm/ổn định",
        "recommendations": ["gợi ý 1", "gợi ý 2"]
      }
      
      Trả lời bằng tiếng Việt, ngắn gọn và thực tế.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      final responseText = response.text ?? '{}';
      return _parseAIResponse(responseText);
    } catch (e) {
      return {
        'error': 'Lỗi khi dự đoán: $e',
        'predictions': [],
        'trends': 'không xác định',
        'recommendations': ['Vui lòng thử lại sau']
      };
    }
  }

  Future<Map<String, dynamic>> analyzeBehavioralPatterns(
      List<ExpenseModel> expenses, List<TaskModel> tasks) async {
    try {
      if (!isInitialized.value) throw Exception('AI Service not initialized');

      final expenseData = _formatExpenseDataForBehavior(expenses);
      final taskData = _formatTaskDataForBehavior(tasks);

      final prompt = '''
      Phân tích hành vi người dùng dựa trên dữ liệu sau:
      
      Chi tiêu: $expenseData
      Công việc: $taskData
      
      Hãy phân tích:
      1. Thói quen chi tiêu
      2. Mô hình làm việc
      3. Mối quan hệ giữa chi tiêu và năng suất
      4. Điểm mạnh và điểm yếu
      
      Trả lời theo format JSON:
      {
        "spendingHabits": "thói quen chi tiêu",
        "workPatterns": "mô hình làm việc",
        "productivityCorrelation": "mối quan hệ năng suất",
        "strengths": ["điểm mạnh 1", "điểm mạnh 2"],
        "weaknesses": ["điểm yếu 1", "điểm yếu 2"],
        "improvementSuggestions": ["gợi ý 1", "gợi ý 2"]
      }
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return _parseAIResponse(response.text ?? '{}');
    } catch (e) {
      return {
        'error': 'Lỗi khi phân tích hành vi: $e',
        'spendingHabits': 'không xác định',
        'workPatterns': 'không xác định',
        'productivityCorrelation': 'không xác định',
        'strengths': [],
        'weaknesses': [],
        'improvementSuggestions': ['Vui lòng thử lại sau']
      };
    }
  }

  Future<List<Map<String, dynamic>>> detectAnomalies(
      List<ExpenseModel> expenses) async {
    try {
      if (!isInitialized.value) throw Exception('AI Service not initialized');

      final expenseData = _formatExpenseDataForAnomaly(expenses);

      final prompt = '''
      Phát hiện các giao dịch bất thường trong dữ liệu chi tiêu sau:
      
      $expenseData
      
      Hãy xác định:
      1. Giao dịch có số tiền bất thường
      2. Giao dịch vào thời gian bất thường
      3. Giao dịch không phù hợp với thói quen
      
      Trả lời theo format JSON:
      {
        "anomalies": [
          {
            "type": "số tiền bất thường",
            "description": "Mô tả bất thường",
            "severity": "cao/trung bình/thấp",
            "recommendation": "Khuyến nghị xử lý"
          }
        ]
      }
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      final result = _parseAIResponse(response.text ?? '{}');
      return List<Map<String, dynamic>>.from(result['anomalies'] ?? []);
    } catch (e) {
      return [
        {
          'type': 'Lỗi hệ thống',
          'description': 'Không thể phát hiện bất thường: $e',
          'severity': 'thấp',
          'recommendation': 'Vui lòng thử lại sau'
        }
      ];
    }
  }

  Future<Map<String, dynamic>> forecastTrends(
      List<ExpenseModel> expenses, List<TaskModel> tasks) async {
    try {
      if (!isInitialized.value) throw Exception('AI Service not initialized');

      final expenseData = _formatExpenseDataForTrends(expenses);
      final taskData = _formatTaskDataForTrends(tasks);

      final prompt = '''
      Dự báo xu hướng tài chính và năng suất dựa trên dữ liệu:
      
      Chi tiêu: $expenseData
      Công việc: $taskData
      
      Hãy dự báo:
      1. Xu hướng chi tiêu 6 tháng tới
      2. Xu hướng năng suất làm việc
      3. Cơ hội tiết kiệm
      4. Rủi ro tài chính
      
      Trả lời theo format JSON:
      {
        "expenseTrends": "tăng/giảm/ổn định",
        "productivityTrends": "tăng/giảm/ổn định",
        "savingsOpportunities": ["cơ hội 1", "cơ hội 2"],
        "financialRisks": ["rủi ro 1", "rủi ro 2"],
        "confidence": 85
      }
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return _parseAIResponse(response.text ?? '{}');
    } catch (e) {
      return {
        'error': 'Lỗi khi dự báo xu hướng: $e',
        'expenseTrends': 'không xác định',
        'productivityTrends': 'không xác định',
        'savingsOpportunities': [],
        'financialRisks': [],
        'confidence': 0
      };
    }
  }

  String _formatExpenseDataForPrediction(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return 'Chưa có dữ liệu chi tiêu';

    final monthlyData = <String, double>{};
    for (var expense in expenses) {
      final monthKey =
          '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + expense.amount;
    }

    return monthlyData.entries
        .map((e) => '${e.key}: ${e.value.toStringAsFixed(0)} VND')
        .join('\n');
  }

  String _formatExpenseDataForBehavior(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return 'Chưa có dữ liệu chi tiêu';

    final categories = <String, double>{};
    final timePatterns = <int, int>{};

    for (var expense in expenses) {
      categories[expense.category] =
          (categories[expense.category] ?? 0) + expense.amount;
      timePatterns[expense.date.hour] =
          (timePatterns[expense.date.hour] ?? 0) + 1;
    }

    return '''
    Tổng chi tiêu: ${expenses.fold(0.0, (sum, e) => sum + e.amount).toStringAsFixed(0)} VND
    Số giao dịch: ${expenses.length}
    Phân bố theo danh mục: ${categories.entries.map((e) => '${e.key}: ${e.value.toStringAsFixed(0)} VND').join(', ')}
    Thời gian giao dịch: ${timePatterns.entries.map((e) => '${e.key}h: ${e.value} giao dịch').join(', ')}
    ''';
  }

  String _formatTaskDataForBehavior(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 'Chưa có công việc nào';

    final completed = tasks.where((t) => t.isCompleted).length;
    final categories = <String, int>{};

    for (var task in tasks) {
      categories[task.category] = (categories[task.category] ?? 0) + 1;
    }

    return '''
    Tổng công việc: ${tasks.length}
    Đã hoàn thành: $completed
    Tỷ lệ hoàn thành: ${tasks.isNotEmpty ? (completed / tasks.length * 100).toStringAsFixed(1) : 0}%
    Phân bố theo danh mục: ${categories.entries.map((e) => '${e.key}: ${e.value}').join(', ')}
    ''';
  }

  String _formatExpenseDataForAnomaly(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return 'Chưa có dữ liệu chi tiêu';

    final amounts = expenses.map((e) => e.amount).toList();
    final avgAmount = amounts.reduce((a, b) => a + b) / amounts.length;
    final maxAmount = amounts.reduce((a, b) => a > b ? a : b);

    return '''
    Số giao dịch: ${expenses.length}
    Số tiền trung bình: ${avgAmount.toStringAsFixed(0)} VND
    Số tiền cao nhất: ${maxAmount.toStringAsFixed(0)} VND
    Chi tiết giao dịch: ${expenses.map((e) => '${e.date.toString().substring(0, 10)} - ${e.amount.toStringAsFixed(0)} VND - ${e.category} - ${e.title}').join('\n')}
    ''';
  }

  String _formatExpenseDataForTrends(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return 'Chưa có dữ liệu chi tiêu';

    final monthlyData = <String, double>{};
    for (var expense in expenses) {
      final monthKey =
          '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + expense.amount;
    }

    return monthlyData.entries
        .map((e) => '${e.key}: ${e.value.toStringAsFixed(0)} VND')
        .join('\n');
  }

  String _formatTaskDataForTrends(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 'Chưa có công việc nào';

    final monthlyData = <String, Map<String, int>>{};
    for (var task in tasks) {
      final monthKey =
          '${task.createdAt.year}-${task.createdAt.month.toString().padLeft(2, '0')}';
      if (!monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = {'total': 0, 'completed': 0};
      }
      monthlyData[monthKey]!['total'] =
          (monthlyData[monthKey]!['total'] ?? 0) + 1;
      if (task.isCompleted) {
        monthlyData[monthKey]!['completed'] =
            (monthlyData[monthKey]!['completed'] ?? 0) + 1;
      }
    }

    return monthlyData.entries
        .map((e) =>
            '${e.key}: ${e.value['total']} công việc, ${e.value['completed']} hoàn thành')
        .join('\n');
  }

  Map<String, dynamic> _parseAIResponse(String response) {
    try {
      String cleanResponse =
          response.replaceAll('```json', '').replaceAll('```', '').trim();
      return Map<String, dynamic>.from(json.decode(cleanResponse));
    } catch (e) {
      print('Error parsing AI response: $e');
      return {'error': 'Không thể xử lý phản hồi từ AI'};
    }
  }
}
