import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/activity_type.dart';

part 'task_activity_entity.freezed.dart';

@freezed
abstract class TaskActivityEntity with _$TaskActivityEntity {
  const factory TaskActivityEntity({
    required String id,
    required String taskId,
    required ActivityType type,

    /// The previous value for change events: the normalized title for
    /// [ActivityType.titleChanged], the normalized description (`null` when
    /// there was none) for [ActivityType.descriptionChanged], and the
    /// `TaskPriority.name` for [ActivityType.priorityChanged].
    String? oldValue,

    /// The new value for change events, in the same form as [oldValue]
    /// (`null` when a description was removed).
    String? newValue,
    required DateTime createdAt,
  }) = _TaskActivityEntity;
}
