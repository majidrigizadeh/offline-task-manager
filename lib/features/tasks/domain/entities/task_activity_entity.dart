import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/activity_type.dart';

part 'task_activity_entity.freezed.dart';

@freezed
abstract class TaskActivityEntity with _$TaskActivityEntity {
  const factory TaskActivityEntity({
    required String id,
    required String taskId,
    required ActivityType type,

    /// For [ActivityType.priorityChanged]: the previous `TaskPriority.name`.
    String? oldValue,

    /// For [ActivityType.priorityChanged]: the new `TaskPriority.name`.
    String? newValue,
    required DateTime createdAt,
  }) = _TaskActivityEntity;
}
