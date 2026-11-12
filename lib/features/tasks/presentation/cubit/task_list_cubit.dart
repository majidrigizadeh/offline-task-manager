import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_query.dart';
import '../../domain/enums/completion_filter.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/usecases/complete_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/reopen_task.dart';
import '../states/task_list_state.dart';

/// Loads, pages, searches, filters and mutates the task list.
///
/// * Search is debounced; every read (first page, next page or refresh)
///   carries a request id and only the latest request may emit ("latest
///   query wins").
/// * Paging: [load] reads the first page; [loadMore] appends the next one.
/// * No optimistic updates: after every mutation, successful or not, the list
///   is reloaded from the database with the current query, keeping as many
///   rows as were already loaded ([refresh]).
@injectable
class TaskListCubit extends Cubit<TaskListState> {
  TaskListCubit(
    this._getTasks,
    this._completeTask,
    this._reopenTask,
    this._deleteTask, {
    @ignoreParam Duration debounce = AppConstants.searchDebounce,
    @ignoreParam this._pageSize = AppConstants.taskPageSize,
  }) : _debounceDuration = debounce,
       super(const TaskListState());

  final GetTasks _getTasks;
  final CompleteTask _completeTask;
  final ReopenTask _reopenTask;
  final DeleteTask _deleteTask;
  final Duration _debounceDuration;
  final int _pageSize;

  Timer? _debounce;
  int _latestRequestId = 0;
  int _errorOccurrence = 0;
  Future<void> Function()? _retryAction;

  /// The query that `state.tasks` was read with. Differs from `state.query`
  /// while a search is debouncing or a new query is loading.
  TaskQuery? _loadedQuery;

  bool get canRetry => _retryAction != null;

  // ---------------------------------------------------------------- loading

  /// Reads the first page for the current query.
  Future<void> load() {
    _debounce?.cancel();
    return _load(limit: _pageSize);
  }

  /// Re-reads the current query from the start, keeping the number of rows
  /// already loaded so the list doesn't shrink back to one page.
  Future<void> refresh() {
    _debounce?.cancel();
    return _load(limit: _refreshLimit);
  }

  /// Appends the next page. Ignored unless the shown list is settled and
  /// belongs to the current query.
  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.status != TaskListStatus.success ||
        state.query != _loadedQuery) {
      return;
    }
    final requestId = ++_latestRequestId;
    final query = state.query;
    final loaded = state.tasks;
    emit(state.copyWith(isLoadingMore: true, loadMoreError: null));
    try {
      final page = await _getTasks(
        query,
        offset: loaded.length,
        limit: _pageSize,
      );
      if (isClosed || requestId != _latestRequestId) return; // stale

      final loadedIds = {for (final t in loaded) t.id};
      if (page.tasks.any((t) => loadedIds.contains(t.id))) {
        // The stored list shifted under the offset; re-read the whole window.
        await _load(limit: loaded.length + _pageSize);
        return;
      }
      emit(
        state.copyWith(
          tasks: [...loaded, ...page.tasks],
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } on TaskFailure catch (failure) {
      if (isClosed || requestId != _latestRequestId) return;
      emit(
        state.copyWith(isLoadingMore: false, loadMoreError: failure.message),
      );
    }
  }

  void searchChanged(String text) {
    if (text == state.query.search) return;
    emit(
      state.copyWith(
        query: state.query.copyWith(search: text),
        isLoadingMore: false,
      ),
    );
    // Invalidate any in-flight result immediately; it belongs to an old query.
    _latestRequestId++;
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () => _load(limit: _pageSize));
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

  /// Rows to re-read: what is shown, if it belongs to the current query.
  int get _refreshLimit => state.query == _loadedQuery
      ? math.max(state.tasks.length, _pageSize)
      : _pageSize;

  Future<void> _load({required int limit}) async {
    final requestId = ++_latestRequestId;
    final query = state.query;
    emit(
      state.copyWith(
        status: TaskListStatus.loading,
        loadError: null,
        isLoadingMore: false, // any next-page read is now stale
        loadMoreError: null,
      ),
    );
    try {
      final page = await _getTasks(query, limit: limit);
      if (isClosed || requestId != _latestRequestId) return; // stale
      _loadedQuery = query;
      emit(
        state.copyWith(
          tasks: page.tasks,
          hasMore: page.hasMore,
          status: page.tasks.isEmpty
              ? TaskListStatus.empty
              : TaskListStatus.success,
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
    await _load(limit: _refreshLimit);
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
