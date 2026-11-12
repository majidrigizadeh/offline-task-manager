import 'dart:async';

import 'package:testniksam/core/error/failures.dart';
import 'package:testniksam/features/tasks/domain/entities/task_activity_entity.dart';
import 'package:testniksam/features/tasks/domain/entities/task_entity.dart';
import 'package:testniksam/features/tasks/domain/entities/task_query.dart';
import 'package:testniksam/features/tasks/domain/enums/task_priority.dart';
import 'package:testniksam/features/tasks/domain/repositories/task_repository.dart';

/// In-memory repository whose reads can be held open to simulate slow
/// queries and whose writes can be made to fail.
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({List<TaskEntity>? tasks}) : tasks = tasks ?? [];

  List<TaskEntity> tasks;

  /// Every getTasks call, in order.
  final List<TaskQuery> queries = [];

  /// When true, getTasks returns a pending future registered in [pendingReads].
  bool holdReads = false;
  final List<({TaskQuery query, Completer<List<TaskEntity>> completer})>
  pendingReads = [];

  TaskFailure? failWritesWith;
  final List<String> writeCalls = [];

  List<TaskEntity> _filter(TaskQuery q) => tasks
      .where(
        (t) =>
            t.title.toLowerCase().contains(q.search.trim().toLowerCase()) &&
            (q.priority == null || t.priority == q.priority),
      )
      .toList();

  @override
  Future<List<TaskEntity>> getTasks(TaskQuery query) {
    queries.add(query);
    if (!holdReads) return Future.value(_filter(query));
    final completer = Completer<List<TaskEntity>>();
    pendingReads.add((query: query, completer: completer));
    return completer.future;
  }

  void releaseRead(int index) {
    final read = pendingReads[index];
    read.completer.complete(_filter(read.query));
  }

  Future<T> _write<T>(String name, T Function() apply) async {
    writeCalls.add(name);
    await Future<void>.delayed(Duration.zero);
    final failure = failWritesWith;
    if (failure != null) throw failure;
    return apply();
  }

  TaskEntity _byId(String id) => tasks.firstWhere((t) => t.id == id);

  void _replace(TaskEntity updated) =>
      tasks = [for (final t in tasks) t.id == updated.id ? updated : t];

  @override
  Future<bool> completeTask(String id) => _write('complete:$id', () {
    if (_byId(id).completed) return false;
    _replace(_byId(id).copyWith(completed: true));
    return true;
  });

  @override
  Future<bool> reopenTask(String id) => _write('reopen:$id', () {
    if (!_byId(id).completed) return false;
    _replace(_byId(id).copyWith(completed: false));
    return true;
  });

  @override
  Future<void> deleteTask(String id) =>
      _write('delete:$id', () => tasks.removeWhere((t) => t.id == id));

  @override
  Future<TaskEntity> createTask({
    required String title,
    String? description,
    required TaskPriority priority,
  }) => _write('create', () {
    final task = TaskEntity(
      id: 'id${tasks.length}',
      title: title,
      description: description,
      priority: priority,
      completed: false,
      createdAt: DateTime.utc(2026),
    );
    tasks = [...tasks, task];
    return task;
  });

  @override
  Future<bool> updateTask({
    required String id,
    required String title,
    String? description,
    required TaskPriority priority,
  }) => _write('update:$id', () {
    _replace(
      _byId(id)
          .copyWith(title: title, description: description, priority: priority),
    );
    return true;
  });

  @override
  Future<TaskEntity> getTask(String id) async => _byId(id);

  @override
  Future<List<TaskActivityEntity>> getActivities(String taskId) async => [];
}

TaskEntity buildTask(
  String id, {
  String? title,
  TaskPriority priority = TaskPriority.medium,
  bool completed = false,
  String? description,
}) => TaskEntity(
  id: id,
  title: title ?? 'Task $id',
  description: description,
  priority: priority,
  completed: completed,
  createdAt: DateTime.utc(2026),
);
