import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_query.dart';

part 'task_list_state.freezed.dart';

enum TaskListStatus { initial, loading, success, empty, failure }

/// A failed mutation. [occurrence] is unique per failure so the UI shows the
/// message again even if the same error repeats.
@freezed
abstract class TaskActionError with _$TaskActionError {
  const factory TaskActionError({
    required String message,
    required int occurrence,
  }) = _TaskActionError;
}

@freezed
abstract class TaskListState with _$TaskListState {
  const factory TaskListState({
    @Default(TaskListStatus.initial) TaskListStatus status,

    /// Always the last list successfully read from the database: every page
    /// loaded so far for the current query.
    @Default(<TaskEntity>[]) List<TaskEntity> tasks,

    /// More tasks match the query beyond [tasks].
    @Default(false) bool hasMore,

    /// A next-page read is in flight (the list itself stays interactive).
    @Default(false) bool isLoadingMore,

    /// The last next-page read failed; [tasks] is unchanged.
    String? loadMoreError,

    /// Latest search/filter intent. Survives mutations and reloads.
    @Default(TaskQuery()) TaskQuery query,

    /// Tasks with a mutation in flight (UI affordance only; correctness is
    /// enforced in the persistence layer).
    @Default(<String>{}) Set<String> pendingTaskIds,
    String? loadError,
    TaskActionError? actionError,
  }) = _TaskListState;
}
