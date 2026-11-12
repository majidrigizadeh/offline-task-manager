import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_entity.dart';

part 'task_page.freezed.dart';

/// One slice of the task list for a `TaskQuery`, in list order.
@freezed
abstract class TaskPage with _$TaskPage {
  const factory TaskPage({
    required List<TaskEntity> tasks,

    /// Whether at least one more task matches the query after this slice.
    required bool hasMore,
  }) = _TaskPage;
}
