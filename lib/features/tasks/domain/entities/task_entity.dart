import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/task_priority.dart';

part 'task_entity.freezed.dart';

@freezed
abstract class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String id,
    required String title,
    String? description,
    required TaskPriority priority,
    required bool completed,
    required DateTime createdAt,
  }) = _TaskEntity;
}
