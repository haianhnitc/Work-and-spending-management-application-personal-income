// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      linkedTaskId: json['linkedTaskId'] as String?,
      mood: $enumDecode(_$MoodEnumMap, json['mood']),
      reason: $enumDecode(_$ReasonEnumMap, json['reason']),
      incomeType:
          $enumDecodeNullable(_$IncomeTypeEnumMap, json['incomeType']) ??
              IncomeType.none,
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'category': instance.category,
      'linkedTaskId': instance.linkedTaskId,
      'mood': _$MoodEnumMap[instance.mood]!,
      'reason': _$ReasonEnumMap[instance.reason]!,
      'incomeType': _$IncomeTypeEnumMap[instance.incomeType]!,
    };

const _$MoodEnumMap = {
  Mood.happy: 'happy',
  Mood.neutral: 'neutral',
  Mood.sad: 'sad',
};

const _$ReasonEnumMap = {
  Reason.necessary: 'necessary',
  Reason.emotional: 'emotional',
  Reason.reward: 'reward',
};

const _$IncomeTypeEnumMap = {
  IncomeType.none: 'none',
  IncomeType.all: 'all',
  IncomeType.income: 'income',
};
