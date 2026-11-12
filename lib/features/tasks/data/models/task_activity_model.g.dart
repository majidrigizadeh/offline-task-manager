// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskActivityModel _$TaskActivityModelFromJson(Map<String, dynamic> json) =>
    _TaskActivityModel(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      type: json['type'] as String,
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TaskActivityModelToJson(_TaskActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'type': instance.type,
      'oldValue': instance.oldValue,
      'newValue': instance.newValue,
      'createdAt': instance.createdAt.toIso8601String(),
    };
