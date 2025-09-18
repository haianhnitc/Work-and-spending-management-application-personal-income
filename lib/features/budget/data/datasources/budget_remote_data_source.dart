import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/budget_model.dart';

class _CategorySpendingData {
  double amount;
  int transactionCount;

  _CategorySpendingData(this.amount, this.transactionCount);
}

abstract class BudgetRemoteDataSource {
  Stream<List<BudgetModel>> getBudgets(String userId);
  Future<BudgetModel?> getBudgetById(String userId, String budgetId);
  Future<void> createBudget(String userId, BudgetModel budget);
  Future<void> updateBudget(String userId, BudgetModel budget);
  Future<void> deleteBudget(String userId, String budgetId);
  Future<void> updateSpentAmount(String userId, String budgetId, double amount);
  Future<BudgetReportModel> getBudgetReport(String userId, String budgetId);
  Future<BudgetModel> createSmartBudget(
      String userId, String category, DateTime startDate, DateTime endDate);
  Future<BudgetModel> autoAdjustBudget(String userId, String budgetId);
  Future<List<BudgetAlertModel>> checkBudgetAlerts(
      String userId, String budgetId);
  Stream<List<BudgetModel>> getBudgetsByCategory(
      String userId, String category);
  Stream<List<BudgetModel>> getBudgetsByPeriod(String userId, String period);
  Future<Map<String, dynamic>> getBudgetOverview(String userId);
  Future<BudgetModel> createBudgetFromTemplate(
      String userId, String templateName);
  Future<BudgetModel> duplicateBudget(
      String userId, String budgetId, DateTime newStartDate);
  Future<String> exportBudgetReport(
      String userId, String budgetId, String format);
  Future<void> syncBudgetWithExpenses(String userId, String budgetId);
  Future<List<String>> getBudgetSuggestions(String userId);
}

@Injectable(as: BudgetRemoteDataSource)
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<BudgetModel>> getBudgets(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<BudgetModel?> getBudgetById(String userId, String budgetId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .get();

    if (doc.exists) {
      return BudgetModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> createBudget(String userId, BudgetModel budget) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budget.id)
        .set(budget.toFirestore());
  }

  @override
  Future<void> updateBudget(String userId, BudgetModel budget) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budget.id)
        .update(budget.toFirestore());
  }

  @override
  Future<void> deleteBudget(String userId, String budgetId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .delete();
  }

  @override
  Future<void> updateSpentAmount(
      String userId, String budgetId, double amount) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .update({
      'spentAmount': amount,
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Future<BudgetReportModel> getBudgetReport(
      String userId, String budgetId) async {
    final budget = await getBudgetById(userId, budgetId);
    if (budget == null) {
      throw Exception('Budget not found');
    }

    final expensesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('category', isEqualTo: budget.category)
        .where('date', isGreaterThanOrEqualTo: budget.startDate)
        .where('date', isLessThanOrEqualTo: budget.endDate)
        .get();

    double actualSpent = 0;
    final categorySpending = <String, _CategorySpendingData>{};

    for (final doc in expensesSnapshot.docs) {
      final expense = doc.data();
      final amount = expense['amount']?.toDouble() ?? 0.0;
      final category = expense['category'] ?? 'unknown';

      actualSpent += amount;

      if (categorySpending.containsKey(category)) {
        categorySpending[category]!.amount += amount;
        categorySpending[category]!.transactionCount++;
      } else {
        categorySpending[category] = _CategorySpendingData(amount, 1);
      }
    }

    final categorySpendingList = categorySpending.entries
        .map((entry) => CategorySpendingModel(
              category: entry.key,
              amount: entry.value.amount,
              percentage: actualSpent > 0
                  ? (entry.value.amount / actualSpent) * 100
                  : 0,
              transactionCount: entry.value.transactionCount,
            ))
        .toList();

    if (actualSpent != budget.spentAmount) {
      await updateBudget(userId, budget.copyWith(spentAmount: actualSpent));
    }

    final alerts = await checkBudgetAlerts(userId, budgetId);

    return BudgetReportModel(
      budgetId: budget.id,
      budgetName: budget.name,
      totalBudget: budget.amount,
      totalSpent: actualSpent,
      remainingAmount: budget.amount - actualSpent,
      usagePercentage:
          budget.amount > 0 ? (actualSpent / budget.amount) * 100 : 0,
      categorySpending: categorySpendingList,
      alerts: alerts,
      reportDate: DateTime.now(),
    );
  }

  @override
  Future<BudgetModel> createSmartBudget(String userId, String category,
      DateTime startDate, DateTime endDate) async {
    final sixMonthsAgo = DateTime.now().subtract(Duration(days: 180));
    final expensesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('category', isEqualTo: category)
        .where('date', isGreaterThanOrEqualTo: sixMonthsAgo)
        .get();

    double totalHistorySpending = 0;
    int monthsCount = 6;

    for (final doc in expensesSnapshot.docs) {
      final expense = doc.data();
      totalHistorySpending += expense['amount']?.toDouble() ?? 0.0;
    }

    double avgMonthlySpending = totalHistorySpending / monthsCount;

    if (avgMonthlySpending == 0) {
      final categoryDefaults = {
        'food': 3000000.0,
        'transport': 2000000.0,
        'entertainment': 1500000.0,
        'utilities': 1000000.0,
        'health': 2000000.0,
        'shopping': 2500000.0,
        'education': 1500000.0,
        'other': 1000000.0,
      };
      avgMonthlySpending = categoryDefaults[category] ?? 2000000.0;
    }

    final durationInDays = endDate.difference(startDate).inDays;
    final periodMultiplier = durationInDays / 30.0;

    final smartBudgetAmount = (avgMonthlySpending * periodMultiplier * 1.1);

    final budget = BudgetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: 'Smart Budget - ${category.toUpperCase()}',
      category: category,
      amount: smartBudgetAmount,
      startDate: startDate,
      endDate: endDate,
      spentAmount: 0.0,
      period: durationInDays <= 35
          ? 'monthly'
          : durationInDays <= 100
              ? 'quarterly'
              : 'yearly',
      tags: ['smart', 'ai-generated'],
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      categoryLimits: {},
      alerts: [],
    );

    await createBudget(userId, budget);
    return budget;
  }

  @override
  Future<BudgetModel> autoAdjustBudget(String userId, String budgetId) async {
    final budget = await getBudgetById(userId, budgetId);
    if (budget == null) {
      throw Exception('Budget not found');
    }

    final currentUsage =
        budget.amount > 0 ? budget.spentAmount / budget.amount : 0;

    final historicalBudgets = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('category', isEqualTo: budget.category)
        .where('isActive', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(3)
        .get();

    double avgHistoricalUsage = 0;
    int historyCount = 0;

    for (final doc in historicalBudgets.docs) {
      final historicalBudget = BudgetModel.fromFirestore(doc);
      if (historicalBudget.amount > 0) {
        avgHistoricalUsage +=
            historicalBudget.spentAmount / historicalBudget.amount;
        historyCount++;
      }
    }

    if (historyCount > 0) {
      avgHistoricalUsage /= historyCount;
    } else {
      avgHistoricalUsage = 0.8;
    }

    double adjustmentFactor = 1.0;

    if (currentUsage > 0.9) {
      adjustmentFactor = 1.2 + (currentUsage - 0.9) * 0.5;
    } else if (currentUsage < 0.5 && avgHistoricalUsage < 0.6) {
      adjustmentFactor = 0.85 + (currentUsage * 0.3);
    } else if (avgHistoricalUsage > 0.8) {
      adjustmentFactor = 1.15;
    } else if (avgHistoricalUsage < 0.6) {
      adjustmentFactor = 0.9;
    }

    final newAmount = budget.amount * adjustmentFactor;
    final adjustedBudget = budget.copyWith(
      amount: newAmount,
      updatedAt: DateTime.now(),
      tags: [...budget.tags, 'auto-adjusted'],
    );

    await updateBudget(userId, adjustedBudget);

    print(
        'Auto-adjusted budget ${budget.name}: ${budget.amount} -> $newAmount (factor: $adjustmentFactor)');
    return adjustedBudget;
  }

  @override
  Future<List<BudgetAlertModel>> checkBudgetAlerts(
      String userId, String budgetId) async {
    final budget = await getBudgetById(userId, budgetId);
    if (budget == null) {
      return [];
    }

    final alerts = <BudgetAlertModel>[];
    final usagePercentage =
        budget.amount > 0 ? (budget.spentAmount / budget.amount) * 100 : 0;

    if (usagePercentage >= 90) {
      alerts.add(BudgetAlertModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        budgetId: budgetId,
        type: 'critical',
        message: 'Ngân sách đã sử dụng ${usagePercentage.toStringAsFixed(1)}%!',
        createdAt: DateTime.now(),
      ));
    } else if (usagePercentage >= 80) {
      alerts.add(BudgetAlertModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        budgetId: budgetId,
        type: 'warning',
        message: 'Ngân sách đã sử dụng ${usagePercentage.toStringAsFixed(1)}%',
        createdAt: DateTime.now(),
      ));
    }

    return alerts;
  }

  @override
  Stream<List<BudgetModel>> getBudgetsByCategory(
      String userId, String category) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<BudgetModel>> getBudgetsByPeriod(String userId, String period) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('period', isEqualTo: period)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<Map<String, dynamic>> getBudgetOverview(String userId) async {
    final budgets = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('isActive', isEqualTo: true)
        .get();

    final budgetList =
        budgets.docs.map((doc) => BudgetModel.fromFirestore(doc)).toList();

    final totalBudget =
        budgetList.fold(0.0, (sum, budget) => sum + budget.amount);
    final totalSpent =
        budgetList.fold(0.0, (sum, budget) => sum + budget.spentAmount);
    final totalRemaining = totalBudget - totalSpent;

    return {
      'totalBudget': totalBudget,
      'totalSpent': totalSpent,
      'totalRemaining': totalRemaining,
      'usagePercentage': totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0,
      'budgetCount': budgetList.length,
      'activeBudgets': budgetList.where((b) => b.isActive).length,
    };
  }

  @override
  Future<BudgetModel> createBudgetFromTemplate(
      String userId, String templateName) async {
    final templates = {
      'student': {
        'name': 'Ngân sách sinh viên',
        'categories': [
          {'category': 'food', 'amount': 2000000.0, 'percentage': 40},
          {'category': 'transport', 'amount': 800000.0, 'percentage': 16},
          {'category': 'education', 'amount': 1200000.0, 'percentage': 24},
          {'category': 'entertainment', 'amount': 600000.0, 'percentage': 12},
          {'category': 'other', 'amount': 400000.0, 'percentage': 8},
        ],
        'totalAmount': 5000000.0,
        'period': 'monthly',
      },
      'family': {
        'name': 'Ngân sách gia đình',
        'categories': [
          {'category': 'food', 'amount': 8000000.0, 'percentage': 32},
          {'category': 'utilities', 'amount': 3000000.0, 'percentage': 12},
          {'category': 'transport', 'amount': 4000000.0, 'percentage': 16},
          {'category': 'health', 'amount': 3000000.0, 'percentage': 12},
          {'category': 'education', 'amount': 2500000.0, 'percentage': 10},
          {'category': 'entertainment', 'amount': 2000000.0, 'percentage': 8},
          {'category': 'savings', 'amount': 2500000.0, 'percentage': 10},
        ],
        'totalAmount': 25000000.0,
        'period': 'monthly',
      },
      'minimalist': {
        'name': 'Ngân sách tối giản',
        'categories': [
          {'category': 'food', 'amount': 1500000.0, 'percentage': 50},
          {'category': 'transport', 'amount': 600000.0, 'percentage': 20},
          {'category': 'utilities', 'amount': 500000.0, 'percentage': 17},
          {'category': 'other', 'amount': 400000.0, 'percentage': 13},
        ],
        'totalAmount': 3000000.0,
        'period': 'monthly',
      },
      'freelancer': {
        'name': 'Ngân sách freelancer',
        'categories': [
          {'category': 'business', 'amount': 3000000.0, 'percentage': 20},
          {'category': 'food', 'amount': 3000000.0, 'percentage': 20},
          {'category': 'transport', 'amount': 2000000.0, 'percentage': 13},
          {'category': 'health', 'amount': 1500000.0, 'percentage': 10},
          {'category': 'savings', 'amount': 4500000.0, 'percentage': 30},
          {'category': 'entertainment', 'amount': 1000000.0, 'percentage': 7},
        ],
        'totalAmount': 15000000.0,
        'period': 'monthly',
      }
    };

    final template = templates[templateName.toLowerCase()];
    if (template == null) {
      throw Exception(
          'Template "$templateName" not found. Available: ${templates.keys.join(', ')}');
    }

    final mainCategory = template['categories'] as List;
    final primaryCategory = mainCategory.first['category'] as String;

    final budget = BudgetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: template['name'] as String,
      category: primaryCategory,
      amount: template['totalAmount'] as double,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      spentAmount: 0.0,
      period: template['period'] as String,
      tags: ['template', templateName.toLowerCase()],
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      categoryLimits: Map.fromEntries(
        mainCategory.map((cat) => MapEntry(
              cat['category'] as String,
              cat['amount'] as double,
            )),
      ),
      alerts: [],
    );

    await createBudget(userId, budget);

    for (final categoryData in mainCategory.skip(1)) {
      final subBudget = BudgetModel(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            '_${categoryData['category']}',
        userId: userId,
        name: '${template['name']} - ${categoryData['category']}',
        category: categoryData['category'] as String,
        amount: categoryData['amount'] as double,
        startDate: budget.startDate,
        endDate: budget.endDate,
        spentAmount: 0.0,
        period: budget.period,
        tags: ['template', templateName.toLowerCase(), 'sub-budget'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        categoryLimits: {},
        alerts: [],
      );

      await createBudget(userId, subBudget);
    }

    return budget;
  }

  @override
  Future<BudgetModel> duplicateBudget(
      String userId, String budgetId, DateTime newStartDate) async {
    final originalBudget = await getBudgetById(userId, budgetId);
    if (originalBudget == null) {
      throw Exception('Budget not found');
    }

    final newBudget = originalBudget.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      spentAmount: 0.0,
      startDate: newStartDate,
      endDate: newStartDate.add(Duration(days: 30)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await createBudget(userId, newBudget);
    return newBudget;
  }

  @override
  Future<String> exportBudgetReport(
      String userId, String budgetId, String format) async {
    await getBudgetReport(userId, budgetId);
    return 'Budget_Report_${budgetId}_${DateTime.now().millisecondsSinceEpoch}.$format';
  }

  @override
  Future<void> syncBudgetWithExpenses(String userId, String budgetId) async {
    final budget = await getBudgetById(userId, budgetId);
    if (budget == null) {
      throw Exception('Budget not found');
    }

    final expensesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('category', isEqualTo: budget.category)
        .where('date', isGreaterThanOrEqualTo: budget.startDate)
        .where('date', isLessThanOrEqualTo: budget.endDate)
        .get();

    double totalSpent = 0;
    for (final doc in expensesSnapshot.docs) {
      final expense = doc.data();
      totalSpent += expense['amount']?.toDouble() ?? 0.0;
    }

    await updateBudget(userId, budget.copyWith(spentAmount: totalSpent));

    print('Synced budget ${budget.name}: spent amount updated to $totalSpent');
  }

  @override
  Future<List<String>> getBudgetSuggestions(String userId) async {
    final suggestions = <String>[];

    final threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));
    final expensesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('date', isGreaterThanOrEqualTo: threeMonthsAgo)
        .get();

    final budgetsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('isActive', isEqualTo: true)
        .get();

    final existingCategories =
        budgetsSnapshot.docs.map((doc) => doc.data()['category']).toSet();

    final categorySpending = <String, double>{};
    for (final doc in expensesSnapshot.docs) {
      final expense = doc.data();
      final category = expense['category'] ?? 'other';
      final amount = expense['amount']?.toDouble() ?? 0.0;
      categorySpending[category] = (categorySpending[category] ?? 0) + amount;
    }

    final sortedCategories = categorySpending.entries
        .where((entry) => !existingCategories.contains(entry.key))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedCategories.take(5)) {
      final avgMonthlySpending = entry.value / 3;
      final suggestedAmount = (avgMonthlySpending * 1.1).round();

      suggestions.add(
          'Tạo ngân sách ${entry.key}: ${suggestedAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VND/tháng');
    }

    if (suggestions.length < 3) {
      final commonSuggestions = [
        'Tạo ngân sách khẩn cấp: 10% thu nhập',
        'Tạo ngân sách tiết kiệm: 20% thu nhập',
        'Tạo ngân sách giải trí: 5% thu nhập',
      ];

      for (final suggestion in commonSuggestions) {
        if (suggestions.length >= 5) break;
        suggestions.add(suggestion);
      }
    }

    return suggestions.isEmpty
        ? [
            'Bắt đầu bằng việc tạo ngân sách cho thực phẩm',
            'Tạo ngân sách cho giao thông',
            'Tạo ngân sách cho tiện ích'
          ]
        : suggestions;
  }
}
