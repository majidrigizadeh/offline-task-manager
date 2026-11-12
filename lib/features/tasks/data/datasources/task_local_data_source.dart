import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/write_failure_config.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/text_normalizer.dart';
import '../../domain/entities/task_query.dart';
import '../../domain/enums/activity_type.dart';
import '../../domain/enums/completion_filter.dart';
import '../../domain/enums/task_priority.dart';
import '../mappers/task_activity_mapper.dart';
import '../mappers/task_mapper.dart';
import '../models/task_activity_model.dart';
import '../models/task_model.dart';

/// All SQL for the tasks feature.
///
/// Invariants for every mutation:
/// * The task write and its activity insert run in ONE `transaction`.
/// * `_failureConfig.throwIfEnabled` runs inside the transaction right after
///   the first write, so a simulated failure always forces a real rollback.
/// * A no-op (nothing to change) writes nothing and returns `false`.
@lazySingleton
class TaskLocalDataSource {
  TaskLocalDataSource(this._db, this._failureConfig, this._uuid, this._clock);

  final AppDatabase _db;
  final WriteFailureConfig _failureConfig;
  final Uuid _uuid;
  final Clock _clock;

  // ---------------------------------------------------------------- reads

  /// Ordered by `created_at DESC, rowid DESC` — a total order, so
  /// LIMIT/OFFSET pages are stable and never overlap.
  Future<List<TaskModel>> getTasks(
    TaskQuery query, {
    required int offset,
    required int limit,
  }) async {
    final select = _db.select(_db.tasks)
      ..where((t) {
        final conditions = <Expression<bool>>[];
        final search = query.search.trim();
        if (search.isNotEmpty) {
          conditions.add(
            t.title.like('%${_escapeLike(search)}%', escapeChar: r'\'),
          );
        }
        final priority = query.priority;
        if (priority != null) conditions.add(t.priority.equals(priority.name));
        switch (query.completion) {
          case CompletionFilter.all:
            break;
          case CompletionFilter.active:
            conditions.add(t.completed.equals(false));
          case CompletionFilter.completed:
            conditions.add(t.completed.equals(true));
        }
        return conditions.isEmpty
            ? const Constant(true)
            : Expression.and(conditions);
      })
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
        (t) => OrderingTerm.desc(_db.tasks.rowId),
      ])
      ..limit(limit, offset: offset);
    final rows = await select.get();
    return rows.map((r) => r.toModel()).toList(growable: false);
  }

  Future<TaskModel> getTask(String id) async {
    final row = await _selectTask(id).getSingleOrNull();
    if (row == null) throw RecordNotFoundException(id);
    return row.toModel();
  }

  /// Oldest first; rowid breaks ties between events in the same millisecond.
  Future<List<TaskActivityModel>> getActivities(String taskId) async {
    final select = _db.select(_db.taskActivities)
      ..where((a) => a.taskId.equals(taskId))
      ..orderBy([
        (a) => OrderingTerm.asc(a.createdAt),
        (a) => OrderingTerm.asc(_db.taskActivities.rowId),
      ]);
    final rows = await select.get();
    return rows.map((r) => r.toModel()).toList(growable: false);
  }

  // ------------------------------------------------------------- mutations

  Future<TaskModel> createTask({
    required String title,
    String? description,
    required TaskPriority priority,
  }) {
    final now = _clock.now();
    final model = TaskModel(
      id: _uuid.v4(),
      title: TextNormalizer.title(title),
      description: TextNormalizer.description(description),
      priority: priority.name,
      completed: false,
      createdAt: now,
    );
    return _db.transaction(() async {
      await _db.into(_db.tasks).insert(model.toRow());
      _failureConfig.throwIfEnabled('createTask');
      await _insertActivity(taskId: model.id, type: ActivityType.created);
      return model;
    });
  }

  /// Diffs normalized input against the stored row; writes only what changed.
  Future<bool> updateTask({
    required String id,
    required String title,
    String? description,
    required TaskPriority priority,
  }) {
    return _db.transaction(() async {
      final current = await _selectTask(id).getSingleOrNull();
      if (current == null) throw RecordNotFoundException(id);

      final newTitle = TextNormalizer.title(title);
      final newDescription = TextNormalizer.description(description);
      final newPriority = priority.name;

      final titleChanged = newTitle != TextNormalizer.title(current.title);
      final descriptionChanged =
          newDescription != TextNormalizer.description(current.description);
      final priorityChanged = newPriority != current.priority;

      if (!titleChanged && !descriptionChanged && !priorityChanged) {
        return false; // Nothing changed: write nothing.
      }

      await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(
          title: titleChanged ? Value(newTitle) : const Value.absent(),
          description: descriptionChanged
              ? Value(newDescription)
              : const Value.absent(),
          priority: priorityChanged ? Value(newPriority) : const Value.absent(),
        ),
      );
      _failureConfig.throwIfEnabled('updateTask');

      // One event per changed field, in form order; rowid keeps that order
      // in the timeline when the timestamps are equal.
      if (titleChanged) {
        await _insertActivity(
          taskId: id,
          type: ActivityType.titleChanged,
          oldValue: TextNormalizer.title(current.title),
          newValue: newTitle,
        );
      }
      if (descriptionChanged) {
        await _insertActivity(
          taskId: id,
          type: ActivityType.descriptionChanged,
          oldValue: TextNormalizer.description(current.description),
          newValue: newDescription,
        );
      }
      if (priorityChanged) {
        await _insertActivity(
          taskId: id,
          type: ActivityType.priorityChanged,
          oldValue: current.priority,
          newValue: newPriority,
        );
      }
      return true;
    });
  }

  Future<bool> completeTask(String id) => _setCompleted(id, completed: true);

  Future<bool> reopenTask(String id) => _setCompleted(id, completed: false);

  /// Activities are removed by `ON DELETE CASCADE` in the same statement, so
  /// a rollback restores both the task and its history.
  Future<void> deleteTask(String id) {
    return _db.transaction(() async {
      final deleted = await (_db.delete(
        _db.tasks,
      )..where((t) => t.id.equals(id))).go();
      if (deleted == 0) throw RecordNotFoundException(id);
      _failureConfig.throwIfEnabled('deleteTask');
    });
  }

  // --------------------------------------------------------------- helpers

  /// Concurrency layers (see DESIGN.md):
  /// 1. Drift runs one transaction at a time per connection.
  /// 2. Drift's native backend starts transactions with `BEGIN IMMEDIATE`, so
  ///    writers on other connections/isolates wait (busy_timeout) instead of
  ///    reading stale state.
  /// 3. The check-and-set itself is a single conditional UPDATE: only a row
  ///    in the opposite state matches. It stays correct even if (1) and (2)
  ///    change, e.g. a backend whose transactions begin DEFERRED.
  Future<bool> _setCompleted(String id, {required bool completed}) {
    return _db.transaction(() async {
      final affected =
          await (_db.update(
                _db.tasks,
              )..where((t) => t.id.equals(id) & t.completed.equals(!completed)))
              .write(TasksCompanion(completed: Value(completed)));

      if (affected == 0) {
        // Either already in the target state (no-op) or the task is gone.
        final exists = await _selectTask(id).getSingleOrNull() != null;
        if (!exists) throw RecordNotFoundException(id);
        return false;
      }

      _failureConfig.throwIfEnabled(completed ? 'completeTask' : 'reopenTask');
      await _insertActivity(
        taskId: id,
        type: completed ? ActivityType.completed : ActivityType.reopened,
      );
      return true;
    });
  }

  SimpleSelectStatement<$TasksTable, TaskRow> _selectTask(String id) =>
      _db.select(_db.tasks)..where((t) => t.id.equals(id));

  Future<void> _insertActivity({
    required String taskId,
    required ActivityType type,
    String? oldValue,
    String? newValue,
  }) {
    final activity = TaskActivityModel(
      id: _uuid.v4(),
      taskId: taskId,
      type: type.name,
      oldValue: oldValue,
      newValue: newValue,
      createdAt: _clock.now(),
    );
    return _db.into(_db.taskActivities).insert(activity.toRow());
  }

  /// Escapes LIKE wildcards so user input is matched literally.
  static String _escapeLike(String input) => input
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
}
