// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetModelImpl _$$BudgetModelImplFromJson(Map<String, dynamic> json) =>
    _$BudgetModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0.0,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      period: json['period'] as String? ?? 'monthly',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      categoryLimits: (json['categoryLimits'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => BudgetAlertModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BudgetModelImplToJson(_$BudgetModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'category': instance.category,
      'amount': instance.amount,
      'spentAmount': instance.spentAmount,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'period': instance.period,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'categoryLimits': instance.categoryLimits,
      'alerts': instance.alerts,
    };

_$BudgetAlertModelImpl _$$BudgetAlertModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetAlertModelImpl(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$BudgetAlertModelImplToJson(
        _$BudgetAlertModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'type': instance.type,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
    };

_$BudgetReportModelImpl _$$BudgetReportModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetReportModelImpl(
      budgetId: json['budgetId'] as String,
      budgetName: json['budgetName'] as String,
      totalBudget: (json['totalBudget'] as num).toDouble(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      usagePercentage: (json['usagePercentage'] as num).toDouble(),
      categorySpending: (json['categorySpending'] as List<dynamic>)
          .map((e) => CategorySpendingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => BudgetAlertModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportDate: DateTime.parse(json['reportDate'] as String),
    );

Map<String, dynamic> _$$BudgetReportModelImplToJson(
        _$BudgetReportModelImpl instance) =>
    <String, dynamic>{
      'budgetId': instance.budgetId,
      'budgetName': instance.budgetName,
      'totalBudget': instance.totalBudget,
      'totalSpent': instance.totalSpent,
      'remainingAmount': instance.remainingAmount,
      'usagePercentage': instance.usagePercentage,
      'categorySpending': instance.categorySpending,
      'alerts': instance.alerts,
      'reportDate': instance.reportDate.toIso8601String(),
    };

_$CategorySpendingModelImpl _$$CategorySpendingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategorySpendingModelImpl(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
    );

Map<String, dynamic> _$$CategorySpendingModelImplToJson(
        _$CategorySpendingModelImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'transactionCount': instance.transactionCount,
    };
