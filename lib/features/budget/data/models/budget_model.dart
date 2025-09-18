import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

@freezed
class BudgetModel with _$BudgetModel {
  const factory BudgetModel({
    required String id,
    required String userId,
    required String name,
    required String category,
    required double amount,
    @Default(0.0) double spentAmount,
    required DateTime startDate,
    required DateTime endDate,
    @Default('monthly') String period,
    @Default([]) List<String> tags,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default({}) Map<String, double> categoryLimits,
    @Default([]) List<BudgetAlertModel> alerts,
  }) = _BudgetModel;

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  factory BudgetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BudgetModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      spentAmount: (data['spentAmount'] ?? 0.0).toDouble(),
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ??
          DateTime.now().add(Duration(days: 30)),
      period: data['period'] ?? 'monthly',
      tags: List<String>.from(data['tags'] ?? []),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      categoryLimits: Map<String, double>.from(data['categoryLimits'] ?? {}),
      alerts: (data['alerts'] as List<dynamic>?)
              ?.map((e) => BudgetAlertModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

extension BudgetModelExtension on BudgetModel {
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'category': category,
      'amount': amount,
      'spentAmount': spentAmount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'period': period,
      'tags': tags,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'categoryLimits': categoryLimits,
      'alerts': alerts.map((e) => e.toJson()).toList(),
    };
  }
}

@freezed
class BudgetAlertModel with _$BudgetAlertModel {
  const factory BudgetAlertModel({
    required String id,
    required String budgetId,
    required String type,
    required String message,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _BudgetAlertModel;

  factory BudgetAlertModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetAlertModelFromJson(json);
}

@freezed
class BudgetReportModel with _$BudgetReportModel {
  const factory BudgetReportModel({
    required String budgetId,
    required String budgetName,
    required double totalBudget,
    required double totalSpent,
    required double remainingAmount,
    required double usagePercentage,
    required List<CategorySpendingModel> categorySpending,
    required List<BudgetAlertModel> alerts,
    required DateTime reportDate,
  }) = _BudgetReportModel;

  factory BudgetReportModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetReportModelFromJson(json);
}

@freezed
class CategorySpendingModel with _$CategorySpendingModel {
  const factory CategorySpendingModel({
    required String category,
    required double amount,
    required double percentage,
    required int transactionCount,
  }) = _CategorySpendingModel;

  factory CategorySpendingModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySpendingModelFromJson(json);
}
