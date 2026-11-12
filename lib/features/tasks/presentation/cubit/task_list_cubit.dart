import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/enums/completion_filter.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/usecases/complete_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/reopen_task.dart';
import '../states/task_list_state.dart';

/// Loads, searches, filters and mutates the task list.
///
/// * Search is debounced; every load carries a request id and only the
///   latest request may emit ("latest query wins").
/// * No optimistic updates: after every mutation, successful or not, the list
///   is reloaded from the database with the current query.
@injectable
class TaskListCubit extends Cubit<TaskListState> {
  TaskListCubit(
    this._getTasks,
    this._completeTask,
    this._reopenTask,
    this._deleteTask, {
    @ignoreParam Duration debounce = AppConstants.searchDebounce,
  }) : _debounceDuration = debounce,
       super(const TaskListState());

  final GetTasks _getTasks;
  final CompleteTask _completeTask;
  final ReopenTask _reopenTask;
  final DeleteTask _deleteTask;
  final Duration _debounceDuration;

  Timer? _debounce;
  int _latestRequestId = 0;
  int _errorOccurrence = 0;
  Future<void> Function()? _retryAction;

  bool get canRetry => _retryAction != null;

  // ---------------------------------------------------------------- loading

  Future<void> load() {
    _debounce?.cancel();
    return _load();
  }

  void searchChanged(String text) {
    if (text == state.query.search) return;
    emit(state.copyWith(query: state.query.copyWith(search: text)));
    // Invalidate any in-flight result immediately; it belongs to an old query.
    _latestRequestId++;
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _load);
  }

  Future<void> priorityFilterChanged(TaskPriority? priority) {
    if (priority == state.query.priority) return Future.value();
    emit(state.copyWith(query: state.query.copyWith(priority: priority)));
    return load();
  }

  Future<void> completionFilterChanged(CompletionFilter filter) {
    if (filter == state.query.completion) return Future.value();
    emit(state.copyWith(query: state.query.copyWith(completion: filter)));
    return load();
  }

  Future<void> _load() async {
    final requestId = ++_latestRequestId;
    final query = state.query;
    emit(state.copyWith(status: TaskListStatus.loading, loadError: null));
    try {
      final tasks = await _getTasks(query);
      if (isClosed || requestId != _latestRequestId) return; // stale
      emit(
        state.copyWith(
          tasks: tasks,
          status: tasks.isEmpty ? TaskListStatus.empty : TaskListStatus.success,
        ),
      );
    } on TaskFailure catch (failure) {
      if (isClosed || requestId != _latestRequestId) return;
      emit(
        state.copyWith(
          status: TaskListStatus.failure,
          loadError: failure.message,
        ),
      );
    }
  }

  // -------------------------------------------------------------- mutations

  Future<void> toggleCompletion(TaskEntity task) =>
      task.completed ? reopen(task.id) : complete(task.id);

  Future<void> complete(String taskId) =>
      _mutate(taskId, () => _completeTask(taskId));

  Future<void> reopen(String taskId) =>
      _mutate(taskId, () => _reopenTask(taskId));

  Future<void> delete(String taskId) =>
      _mutate(taskId, () => _deleteTask(taskId));

  /// Re-runs the last failed mutation.
  Future<void> retryLastAction() async {
    final action = _retryAction;
    _retryAction = null;
    if (action != null) await action();
  }

  Future<void> _mutate(String taskId, Future<Object?> Function() action) async {
    if (state.pendingTaskIds.contains(taskId)) return;
    emit(state.copyWith(pendingTaskIds: {...state.pendingTaskIds, taskId}));

    TaskFailure? failure;
    try {
      await action();
      _retryAction = null;
    } on TaskFailure catch (f) {
      failure = f;
      _retryAction = () => _mutate(taskId, action);
    }
    if (isClosed) return;

    emit(
      state.copyWith(pendingTaskIds: {...state.pendingTaskIds}..remove(taskId)),
    );
    // Show what is actually stored, whether the write succeeded or not.
    await _load();
    if (failure != null && !isClosed) {
      emit(
        state.copyWith(
          actionError: TaskActionError(
            message: failure.message,
            occurrence: ++_errorOccurrence,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
