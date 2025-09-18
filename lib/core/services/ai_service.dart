import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import '../../features/task/data/models/task_model.dart';
import '../../features/expense/data/models/expense_model.dart';

class AIService extends GetxService {
  late GenerativeModel _model;

  @override
  void onInit() {
    super.onInit();
    _initializeAI();
  }

  void _initializeAI() {
    const apiKey = 'AIzaSyDsShbeCpvzODnWddy2x87ZB27teEKvFvo';
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> analyzeExpenses(List<ExpenseModel> expenses) async {
    try {
      final expenseData = _formatExpenseData(expenses);

      final prompt = '''
      Phân tích dữ liệu chi tiêu sau và đưa ra gợi ý tiết kiệm:
      
      $expenseData
      
      Hãy đưa ra:
      1. Nhận xét về thói quen chi tiêu (2-3 câu)
      2. Các khoản chi tiêu có thể cắt giảm (2-3 gợi ý)
      3. Gợi ý tiết kiệm cụ thể (2-3 gợi ý)
      4. Dự đoán chi tiêu tháng tới
      
      Trả lời bằng tiếng Việt, ngắn gọn và dễ hiểu. Không quá 200 từ.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Không thể phân tích được dữ liệu';
    } catch (e) {
      print('Lỗi ở đây: ${e.toString()}');
      return 'Lỗi khi phân tích: Vui lòng kiểm tra kết nối mạng';
    }
  }

  Future<String> analyzeTasks(List<TaskModel> tasks) async {
    try {
      final taskData = _formatTaskData(tasks);

      final prompt = '''
      Phân tích dữ liệu công việc sau và đưa ra gợi ý quản lý thời gian:
      
      $taskData
      
      Hãy đưa ra:
      1. Đánh giá hiệu suất làm việc (2-3 câu)
      2. Công việc ưu tiên cần làm (2-3 gợi ý)
      3. Gợi ý phân bổ thời gian (2-3 gợi ý)
      4. Cải thiện năng suất
      
      Trả lời bằng tiếng Việt, ngắn gọn và thực tế. Không quá 200 từ.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Không thể phân tích được dữ liệu';
    } catch (e) {
      print('${e.toString()}');
      return 'Lỗi khi phân tích: Vui lòng kiểm tra kết nối mạng';
    }
  }

  Future<String> getSmartSuggestions(
      List<TaskModel> tasks, List<ExpenseModel> expenses) async {
    try {
      final currentHour = DateTime.now().hour;
      final dayOfWeek = DateTime.now().weekday;

      final prompt = '''
      Hiện tại là ${_getTimeContext(currentHour, dayOfWeek)}.
      
      Dữ liệu người dùng:
      - Công việc: ${_formatTaskData(tasks)}
      - Chi tiêu: ${_formatExpenseData(expenses)}
      
      Dựa vào thời gian hiện tại và dữ liệu, hãy đưa ra 3-5 gợi ý cụ thể:
      1. Công việc nên làm ngay
      2. Lời nhắc về chi tiêu
      3. Hoạt động phù hợp với thời gian
      
      Trả lời ngắn gọn, thực tế bằng tiếng Việt. Không quá 150 từ.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Không có gợi ý phù hợp';
    } catch (e) {
      return 'Lỗi khi tạo gợi ý: Vui lòng thử lại sau';
    }
  }

  Future<Map<String, dynamic>> getPredictiveAnalysis(
      List<TaskModel> tasks, List<ExpenseModel> expenses) async {
    try {
      final prompt = '''
      Phân tích xu hướng và dự đoán dựa trên dữ liệu sau:
      
      Công việc: ${_formatTaskData(tasks)}
      Chi tiêu: ${_formatExpenseData(expenses)}
      
      Hãy trả về phân tích bằng tiếng Việt theo format sau:
      - Xu hướng năng suất: (tăng/giảm/ổn định)
      - Xu hướng chi tiêu: (tăng/giảm/ổn định)
      - Dự đoán chi tiêu tháng tới: (số tiền ước tính)
      - Tỷ lệ hoàn thành công việc: (%)
      - 3 khuyến nghị quan trọng
      
      Trả lời ngắn gọn, không quá 150 từ.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return {
        'analysis': response.text ?? 'Không thể phân tích',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {'error': 'Lỗi phân tích: Vui lòng thử lại sau'};
    }
  }

  String _formatExpenseData(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return 'Chưa có dữ liệu chi tiêu';

    final lastMonth = expenses
        .where(
            (e) => e.date.isAfter(DateTime.now().subtract(Duration(days: 30))))
        .toList();

    final totalAmount = lastMonth.fold(0.0, (sum, e) => sum + e.amount);
    final categories = <String, double>{};

    for (var expense in lastMonth) {
      categories[expense.category] =
          (categories[expense.category] ?? 0) + expense.amount;
    }

    return '''
    Tổng chi tiêu 30 ngày qua: ${totalAmount.toStringAsFixed(0)} VND
    Số giao dịch: ${lastMonth.length}
    Phân bố theo danh mục:
    ${categories.entries.map((e) => '- ${_stringCategoryToDisplayName(e.key)}: ${e.value.toStringAsFixed(0)} VND').join('\n')}
    ''';
  }

  String _formatTaskData(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 'Chưa có công việc nào';

    final lastMonth = tasks
        .where((t) =>
            t.createdAt.isAfter(DateTime.now().subtract(Duration(days: 30))))
        .toList();

    final completed = lastMonth.where((t) => t.isCompleted).length;
    final pending = lastMonth.length - completed;

    final categories = <String, int>{};
    for (var task in lastMonth) {
      categories[task.category] = (categories[task.category] ?? 0) + 1;
    }

    return '''
    Tổng công việc 30 ngày qua: ${lastMonth.length}
    Đã hoàn thành: $completed
    Chưa hoàn thành: $pending
    Tỷ lệ hoàn thành: ${lastMonth.isNotEmpty ? (completed / lastMonth.length * 100).toStringAsFixed(1) : 0}%
    Phân bố theo danh mục:
    ${categories.entries.map((e) => '- ${_stringCategoryToDisplayName(e.key)}: ${e.value} công việc').join('\n')}
    ''';
  }

  String _getTimeContext(int hour, int dayOfWeek) {
    final weekdays = [
      '',
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ nhật'
    ];
    final timeOfDay = hour < 12
        ? 'sáng'
        : hour < 18
            ? 'chiều'
            : 'tối';

    return '${weekdays[dayOfWeek]} $timeOfDay (${hour}h)';
  }

  String _stringCategoryToDisplayName(String categoryString) {
    try {
      final category = Category.values.firstWhere(
        (c) => c.name == categoryString,
        orElse: () => Category.other,
      );
      return categoryToString(category);
    } catch (e) {
      return categoryString.isEmpty ? 'Khác' : categoryString;
    }
  }
}
