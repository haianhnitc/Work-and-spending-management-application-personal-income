// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      dueDate:
          const TimestampConverter().fromJson(json['dueDate'] as Timestamp),
      isCompleted: json['isCompleted'] as bool? ?? false,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
      category: json['category'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': const TimestampConverter().toJson(instance.dueDate),
      'isCompleted': instance.isCompleted,
      'estimatedCost': instance.estimatedCost,
      'category': instance.category,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
