import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/completion_filter.dart';
import '../enums/task_priority.dart';

part 'task_query.freezed.dart';

/// Search + filter criteria for the task list. All criteria combine (AND).
@freezed
abstract class TaskQuery with _$TaskQuery {
  const factory TaskQuery({
    /// Case-insensitive substring match on the title. Empty = no filter.
    @Default('') String search,

    /// `null` = any priority.
    TaskPriority? priority,
    @Default(CompletionFilter.all) CompletionFilter completion,
  }) = _TaskQuery;
}
