import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';
import '../utils/env_config.dart';
import '../../features/task/data/models/task_model.dart';
import '../../features/expense/data/models/expense_model.dart';
import '../../features/budget/data/models/budget_model.dart';
import '../../features/task/presentation/controllers/task_controller.dart';
import '../../features/expense/presentation/controllers/expense_controller.dart';
import '../../features/budget/presentation/controllers/budget_controller.dart';

class AIService extends GetxService {
  late GenerativeModel _model;

  TaskController? _taskController;
  ExpenseController? _expenseController;
  BudgetController? _budgetController;

  @override
  void onInit() {
    super.onInit();
  }

  static Future<void> initialize() async {
    final instance = Get.find<AIService>();
    instance._initializeAI();
  }

  void setControllers({
    TaskController? taskController,
    ExpenseController? expenseController,
    BudgetController? budgetController,
  }) {
    _taskController = taskController;
    _expenseController = expenseController;
    _budgetController = budgetController;
  }

  void _initializeAI() {
    final apiKey = EnvConfig.get('GEMINI_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in environment variables');
    }

    final modelName = EnvConfig.geminiModel;
    print('🔧 Using model: $modelName');

    _model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
    );
  }

  Future<String> analyzeExpenses(List<ExpenseModel> expenses) async {
    return _executeWithRetry(() async {
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
    }, 'phân tích chi tiêu');
  }

  Future<String> analyzeTasks(List<TaskModel> tasks) async {
    return _executeWithRetry(() async {
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
    }, 'phân tích công việc');
  }

  Future<String> getSmartSuggestions(
      List<TaskModel> tasks, List<ExpenseModel> expenses) async {
    return _executeWithRetry(() async {
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
    }, 'tạo gợi ý thông minh');
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
      print("Lỗi nè: ${e}");
      return {'error': 'Lỗi phân tích: Vui lòng thử lại sau'};
    }
  }

  String _formatExpenseData(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return 'Chưa có dữ liệu chi tiêu';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);

    final todayExpenses = expenses.where((e) {
      final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
      return expenseDate.isAtSameMomentAs(today);
    }).toList();

    final yesterdayExpenses = expenses.where((e) {
      final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
      return expenseDate.isAtSameMomentAs(yesterday);
    }).toList();

    final thisWeekExpenses = expenses
        .where((e) => e.date.isAfter(thisWeekStart.subtract(Duration(days: 1))))
        .toList();

    final thisMonthExpenses = expenses
        .where(
            (e) => e.date.isAfter(thisMonthStart.subtract(Duration(days: 1))))
        .toList();

    final lastMonthExpenses = expenses
        .where((e) =>
            e.date.isAfter(lastMonthStart.subtract(Duration(days: 1))) &&
            e.date.isBefore(thisMonthStart))
        .toList();

    final todayAmount = todayExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final yesterdayAmount =
        yesterdayExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final thisWeekAmount =
        thisWeekExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final thisMonthAmount =
        thisMonthExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final lastMonthAmount =
        lastMonthExpenses.fold(0.0, (sum, e) => sum + e.amount);

    final todayExpenseOnly = todayExpenses
        .where((e) => e.incomeType == IncomeType.none)
        .fold(0.0, (sum, e) => sum + e.amount);
    final todayIncomeOnly = todayExpenses
        .where((e) => e.incomeType != IncomeType.none)
        .fold(0.0, (sum, e) => sum + e.amount);

    final thisMonthExpenseOnly = thisMonthExpenses
        .where((e) => e.incomeType == IncomeType.none)
        .fold(0.0, (sum, e) => sum + e.amount);
    final thisMonthIncomeOnly = thisMonthExpenses
        .where((e) => e.incomeType != IncomeType.none)
        .fold(0.0, (sum, e) => sum + e.amount);

    final recentTransactions = expenses.take(5).toList();

    final buffer = StringBuffer();

    buffer.writeln('📊 TỔNG QUAN THEO THỜI GIAN:');
    buffer.writeln(
        '• Hôm nay (${now.day}/${now.month}): ${_formatMoney(todayAmount)} (${todayExpenses.length} giao dịch)');
    if (todayExpenses.isNotEmpty) {
      buffer.writeln('  - Chi tiêu: ${_formatMoney(todayExpenseOnly)}');
      buffer.writeln('  - Thu nhập: ${_formatMoney(todayIncomeOnly)}');
    }

    buffer.writeln(
        '• Hôm qua: ${_formatMoney(yesterdayAmount)} (${yesterdayExpenses.length} giao dịch)');
    buffer.writeln(
        '• Tuần này: ${_formatMoney(thisWeekAmount)} (${thisWeekExpenses.length} giao dịch)');
    buffer.writeln(
        '• Tháng này: ${_formatMoney(thisMonthAmount)} (${thisMonthExpenses.length} giao dịch)');
    if (thisMonthExpenses.isNotEmpty) {
      buffer.writeln('  - Chi tiêu: ${_formatMoney(thisMonthExpenseOnly)}');
      buffer.writeln('  - Thu nhập: ${_formatMoney(thisMonthIncomeOnly)}');
      buffer.writeln(
          '  - Còn lại: ${_formatMoney(thisMonthIncomeOnly - thisMonthExpenseOnly)}');
    }
    buffer.writeln(
        '• Tháng trước: ${_formatMoney(lastMonthAmount)} (${lastMonthExpenses.length} giao dịch)');

    final monthlyCategories = <String, double>{};
    for (var expense
        in thisMonthExpenses.where((e) => e.incomeType == IncomeType.none)) {
      monthlyCategories[expense.category] =
          (monthlyCategories[expense.category] ?? 0) + expense.amount;
    }

    if (monthlyCategories.isNotEmpty) {
      buffer.writeln('\n📋 CHI TIÊU THEO DANH MỤC (Tháng này):');
      final sortedCategories = monthlyCategories.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final entry in sortedCategories.take(5)) {
        buffer.writeln(
            '• ${_stringCategoryToDisplayName(entry.key)}: ${_formatMoney(entry.value)}');
      }
    }

    if (recentTransactions.isNotEmpty) {
      buffer.writeln('\n🕐 GIAO DỊCH GẦN ĐÂY:');
      for (final transaction in recentTransactions) {
        final daysDiff = now.difference(transaction.date).inDays;
        String timeDesc;
        if (daysDiff == 0)
          timeDesc = 'Hôm nay';
        else if (daysDiff == 1)
          timeDesc = 'Hôm qua';
        else
          timeDesc = '${daysDiff} ngày trước';

        final type = transaction.incomeType == IncomeType.none ? 'Chi' : 'Thu';
        buffer.writeln(
            '• $timeDesc: $type ${_formatMoney(transaction.amount)} - ${transaction.title}');
      }
    }

    return buffer.toString();
  }

  String _formatMoney(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return '${amount.toStringAsFixed(0)}đ';
    }
  }

  String _formatTaskData(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 'Chưa có công việc nào';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));
    final thisWeekEnd = thisWeekStart.add(Duration(days: 6));

    final todayTasks = tasks.where((t) {
      final dueDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return dueDate.isAtSameMomentAs(today);
    }).toList();

    final tomorrowTasks = tasks.where((t) {
      final dueDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return dueDate.isAtSameMomentAs(tomorrow);
    }).toList();

    final thisWeekTasks = tasks.where((t) {
      final dueDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return dueDate.isAfter(thisWeekStart.subtract(Duration(days: 1))) &&
          dueDate.isBefore(thisWeekEnd.add(Duration(days: 1)));
    }).toList();

    final overdueTasks = tasks.where((t) {
      final dueDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return dueDate.isBefore(today) && !t.isCompleted;
    }).toList();

    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    final pendingTasks = tasks.where((t) => !t.isCompleted).toList();

    final thisMonthCreated = tasks
        .where((t) =>
            t.createdAt.month == now.month && t.createdAt.year == now.year)
        .toList();

    final buffer = StringBuffer();

    buffer.writeln('📊 TỔNG QUAN CÔNG VIỆC:');
    buffer.writeln(
        '• Tổng số: ${tasks.length} (Hoàn thành: ${completedTasks.length}, Còn lại: ${pendingTasks.length})');
    buffer.writeln(
        '• Tỷ lệ hoàn thành: ${tasks.isNotEmpty ? (completedTasks.length / tasks.length * 100).toStringAsFixed(1) : 0}%');

    buffer.writeln('\n📅 THEO THỜI GIAN:');

    if (overdueTasks.isNotEmpty) {
      buffer.writeln('⚠️ Quá hạn: ${overdueTasks.length} task');
      for (final task in overdueTasks.take(3)) {
        final daysDiff = today
            .difference(DateTime(
                task.dueDate.year, task.dueDate.month, task.dueDate.day))
            .inDays;
        buffer.writeln('  - ${task.title} (Trễ ${daysDiff} ngày)');
      }
      if (overdueTasks.length > 3) {
        buffer.writeln('  ... và ${overdueTasks.length - 3} task khác');
      }
    }

    if (todayTasks.isNotEmpty) {
      buffer.writeln(
          '📌 Hôm nay (${now.day}/${now.month}): ${todayTasks.length} task');
      final todayCompleted = todayTasks.where((t) => t.isCompleted).length;
      buffer.writeln('  - Hoàn thành: $todayCompleted/${todayTasks.length}');
      for (final task in todayTasks.where((t) => !t.isCompleted).take(3)) {
        buffer.writeln(
            '  - ⏳ ${task.title} (${_stringCategoryToDisplayName(task.category)})');
      }
    } else {
      buffer.writeln('📌 Hôm nay: Không có task nào');
    }

    if (tomorrowTasks.isNotEmpty) {
      buffer.writeln('📅 Ngày mai: ${tomorrowTasks.length} task');
      for (final task in tomorrowTasks.take(3)) {
        final status = task.isCompleted ? '✅' : '⏳';
        buffer.writeln('  - $status ${task.title}');
      }
    }

    if (thisWeekTasks.isNotEmpty) {
      final weekCompleted = thisWeekTasks.where((t) => t.isCompleted).length;
      buffer.writeln(
          '📆 Tuần này: ${thisWeekTasks.length} task (Hoàn thành: $weekCompleted)');
    }

    final categories = <String, int>{};
    final categoryCompleted = <String, int>{};

    for (var task in thisMonthCreated) {
      categories[task.category] = (categories[task.category] ?? 0) + 1;
      if (task.isCompleted) {
        categoryCompleted[task.category] =
            (categoryCompleted[task.category] ?? 0) + 1;
      }
    }

    if (categories.isNotEmpty) {
      buffer.writeln('\n📋 THEO DANH MỤC (Tháng này):');
      for (final entry in categories.entries) {
        final completed = categoryCompleted[entry.key] ?? 0;
        final total = entry.value;
        final percent =
            total > 0 ? (completed / total * 100).toStringAsFixed(0) : '0';
        buffer.writeln(
            '• ${_stringCategoryToDisplayName(entry.key)}: $completed/$total ($percent%)');
      }
    }

    final recentCompleted = completedTasks
        .where((t) => now.difference(t.createdAt).inDays <= 7)
        .take(3)
        .toList();

    if (recentCompleted.isNotEmpty) {
      buffer.writeln('\n✅ HOÀN THÀNH GẦN ĐÂY:');
      for (final task in recentCompleted) {
        final daysDiff = now.difference(task.createdAt).inDays;
        final timeDesc = daysDiff == 0
            ? 'Hôm nay'
            : daysDiff == 1
                ? 'Hôm qua'
                : '$daysDiff ngày trước';
        buffer.writeln('• $timeDesc: ${task.title}');
      }
    }

    return buffer.toString();
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

  Future<String> getChatResponse(String prompt) async {
    return _executeWithRetry(() async {
      final contextData = _buildUserContext();

      final enhancedPrompt = '''
        Bạn là AI Assistant thông minh cho ứng dụng quản lý tài chính và công việc.

        NGỮ CẢNH NGƯỜI DÙNG:
        $contextData

        CÂU HỎI NGƯỜI DÙNG: $prompt

        Hãy trả lời câu hỏi dựa trên ngữ cảnh trên. Nếu câu hỏi liên quan đến:
        - Chi tiêu/thu nhập: Sử dụng dữ liệu expense để phân tích và đưa ra gợi ý cụ thể
        - Công việc/task: Sử dụng dữ liệu task để đưa ra lời khuyên về quản lý thời gian
        - Ngân sách: Sử dụng dữ liệu budget để đánh giá tình hình tài chính
        - Câu hỏi chung: Kết hợp tất cả dữ liệu để đưa ra lời khuyên toàn diện

        Trả lời bằng tiếng Việt, ngắn gọn, thực tế và hữu ích. Sử dụng emoji phù hợp.
        ''';

      final content = [Content.text(enhancedPrompt)];
      final response = await _model.generateContent(content);

      return response.text ??
          'Xin lỗi, tôi không thể trả lời câu hỏi này lúc này.';
    }, 'trò chuyện AI');
  }

  String _buildUserContext() {
    final context = StringBuffer();

    final now = DateTime.now();
    context.writeln(
        '📅 Thời gian hiện tại: ${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute.toString().padLeft(2, '0')}');

    if (_taskController != null && _taskController!.tasks.isNotEmpty) {
      context.writeln('\n📋 CÔNG VIỆC:');
      context.writeln(_formatTaskData(_taskController!.tasks));
    } else {
      context.writeln('\n📋 CÔNG VIỆC: Chưa có task nào được tạo');
    }

    if (_expenseController != null && _expenseController!.expenses.isNotEmpty) {
      context.writeln('\n💰 CHI TIÊU/THU NHẬP:');
      context.writeln(_formatExpenseData(_expenseController!.expenses));

      final today = DateTime(now.year, now.month, now.day);
      final todayExpenses = _expenseController!.expenses.where((e) {
        final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
        return expenseDate.isAtSameMomentAs(today);
      }).toList();
      print('🔍 Today expenses: ${todayExpenses.length}');
    } else {
      context.writeln('\n💰 CHI TIÊU/THU NHẬP: Chưa có dữ liệu chi tiêu');
    }

    if (_budgetController != null && _budgetController!.budgets.isNotEmpty) {
      context.writeln('\n🎯 NGÂN SÁCH:');
      context.writeln(_formatBudgetSummary(_budgetController!.budgets));
    } else {
      context.writeln('\n🎯 NGÂN SÁCH: Chưa có ngân sách nào được thiết lập');
    }

    return context.toString();
  }

  String _formatBudgetSummary(List<BudgetModel> budgets) {
    final now = DateTime.now();
    final activeBudgets = budgets.where((b) {
      return b.startDate.isBefore(now) && b.endDate.isAfter(now);
    }).toList();

    final expiredBudgets = budgets.where((b) {
      return b.endDate.isBefore(now);
    }).toList();

    final upcomingBudgets = budgets.where((b) {
      return b.startDate.isAfter(now);
    }).toList();

    final buffer = StringBuffer();

    if (activeBudgets.isEmpty &&
        expiredBudgets.isEmpty &&
        upcomingBudgets.isEmpty) {
      return '- Không có ngân sách nào được thiết lập';
    }

    if (activeBudgets.isNotEmpty) {
      buffer.writeln('💰 NGÂN SÁCH ĐANG HOẠT ĐỘNG: ${activeBudgets.length}');

      for (final budget in activeBudgets) {
        final percentage = budget.amount > 0
            ? (budget.spentAmount / budget.amount * 100)
            : 0.0;
        final remaining = budget.amount - budget.spentAmount;
        final daysLeft = budget.endDate.difference(now).inDays;

        String statusIcon;
        String statusText;
        if (percentage >= 90) {
          statusIcon = '🔴';
          statusText = 'Nguy hiểm';
        } else if (percentage >= 70) {
          statusIcon = '🟡';
          statusText = 'Cảnh báo';
        } else {
          statusIcon = '🟢';
          statusText = 'An toàn';
        }

        buffer.writeln('• $statusIcon ${budget.name} ($statusText):');
        buffer.writeln(
            '  - Đã dùng: ${_formatMoney(budget.spentAmount)}/${_formatMoney(budget.amount)} (${percentage.toStringAsFixed(1)}%)');
        buffer.writeln('  - Còn lại: ${_formatMoney(remaining)}');
        buffer.writeln(
            '  - Thời gian: ${daysLeft} ngày (đến ${budget.endDate.day}/${budget.endDate.month})');

        if (daysLeft > 0 && remaining > 0) {
          final dailyLimit = remaining / daysLeft;
          buffer.writeln('  - Giới hạn/ngày: ${_formatMoney(dailyLimit)}');
        }
        buffer.writeln('');
      }
    }

    if (expiredBudgets.isNotEmpty) {
      final recentExpired = expiredBudgets
          .where((b) => now.difference(b.endDate).inDays <= 30)
          .take(2)
          .toList();

      if (recentExpired.isNotEmpty) {
        buffer.writeln('📊 NGÂN SÁCH VỪA KẾT THÚC:');
        for (final budget in recentExpired) {
          final percentage = budget.amount > 0
              ? (budget.spentAmount / budget.amount * 100)
              : 0.0;
          final daysAgo = now.difference(budget.endDate).inDays;
          final resultIcon = percentage <= 100 ? '✅' : '❌';
          buffer.writeln(
              '• $resultIcon ${budget.name} (${daysAgo} ngày trước): ${percentage.toStringAsFixed(1)}%');
        }
        buffer.writeln('');
      }
    }

    if (upcomingBudgets.isNotEmpty) {
      final soonStarting = upcomingBudgets
          .where((b) => b.startDate.difference(now).inDays <= 7)
          .take(2)
          .toList();

      if (soonStarting.isNotEmpty) {
        buffer.writeln('� NGÂN SÁCH SẮP HOẠT ĐỘNG:');
        for (final budget in soonStarting) {
          final daysUntil = budget.startDate.difference(now).inDays;
          buffer.writeln(
              '• ${budget.name}: ${_formatMoney(budget.amount)} (${daysUntil} ngày nữa)');
        }
        buffer.writeln('');
      }
    }

    if (activeBudgets.isNotEmpty) {
      final totalBudget = activeBudgets.fold(0.0, (sum, b) => sum + b.amount);
      final totalSpent =
          activeBudgets.fold(0.0, (sum, b) => sum + b.spentAmount);
      final totalRemaining = totalBudget - totalSpent;
      final overallPercentage =
          totalBudget > 0 ? (totalSpent / totalBudget * 100) : 0.0;

      buffer.writeln('📈 TỔNG QUAN:');
      buffer.writeln('• Tổng ngân sách: ${_formatMoney(totalBudget)}');
      buffer.writeln(
          '• Đã chi tiêu: ${_formatMoney(totalSpent)} (${overallPercentage.toStringAsFixed(1)}%)');
      buffer.writeln('• Còn lại: ${_formatMoney(totalRemaining)}');
    }

    return buffer.toString();
  }

  Future<String> _executeWithRetry(
      Future<String> Function() operation, String operationName,
      {int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('🔄 Thực hiện $operationName (lần thử $attempt/$maxRetries)');
        return await operation();
      } catch (e) {
        print('❌ Lỗi lần thử $attempt: ${e.toString()}');

        if (e.toString().contains('503') ||
            e.toString().contains('UNAVAILABLE')) {
          if (attempt < maxRetries) {
            final waitTime = attempt * 2;
            print('⏳ Đợi ${waitTime}s trước khi thử lại...');
            await Future.delayed(Duration(seconds: waitTime));
            continue;
          } else {
            return 'Dịch vụ AI hiện tại không khả dụng. Vui lòng thử lại sau ít phút. ⚠️\n\nCó thể do:\n- Server Google đang bận\n- Vượt quá giới hạn API\n- Sự cố mạng tạm thời';
          }
        }

        if (e.toString().contains('429') || e.toString().contains('quota')) {
          return 'Đã vượt quá giới hạn sử dụng AI. Vui lòng thử lại sau ít phút. 🕐';
        }

        if (e.toString().contains('401') ||
            e.toString().contains('authentication')) {
          return 'Lỗi xác thực API. Vui lòng kiểm tra cấu hình API key. 🔑';
        }

        return 'Lỗi khi $operationName: ${_getErrorMessage(e)} 😔';
      }
    }

    return 'Không thể thực hiện $operationName sau $maxRetries lần thử.';
  }

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Vấn đề kết nối mạng';
    } else if (errorStr.contains('timeout')) {
      return 'Hết thời gian chờ';
    } else if (errorStr.contains('server')) {
      return 'Lỗi máy chủ';
    }
    return 'Lỗi không xác định';
  }
}
