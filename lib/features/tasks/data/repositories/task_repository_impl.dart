import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_activity_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_query.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../mappers/task_activity_mapper.dart';
import '../mappers/task_mapper.dart';

/// Adapts [TaskLocalDataSource] to the domain contract: maps models to
/// entities (via mapper extensions) and data exceptions to [TaskFailure]s.
@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._local);

  final TaskLocalDataSource _local;

  @override
  Future<List<TaskEntity>> getTasks(TaskQuery query) => _read(
    () async =>
        (await _local.getTasks(query)).map((m) => m.toEntity()).toList(),
  );

  @override
  Future<TaskEntity> getTask(String id) =>
      _read(() async => (await _local.getTask(id)).toEntity());

  @override
  Future<List<TaskActivityEntity>> getActivities(String taskId) =>
      _read(() async => (await _local.getActivities(taskId)).toEntities());

  @override
  Future<TaskEntity> createTask({
    required String title,
    String? description,
    required TaskPriority priority,
  }) => _write(
    () async => (await _local.createTask(
      title: title,
      description: description,
      priority: priority,
    )).toEntity(),
  );

  @override
  Future<bool> updateTask({
    required String id,
    required String title,
    String? description,
    required TaskPriority priority,
  }) => _write(
    () => _local.updateTask(
      id: id,
      title: title,
      description: description,
      priority: priority,
    ),
  );

  @override
  Future<bool> completeTask(String id) => _write(() => _local.completeTask(id));

  @override
  Future<bool> reopenTask(String id) => _write(() => _local.reopenTask(id));

  @override
  Future<void> deleteTask(String id) => _write(() => _local.deleteTask(id));

  Future<T> _read<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on RecordNotFoundException catch (e) {
      throw TaskNotFoundFailure(e.id);
    } catch (e) {
      throw UnexpectedFailure('Could not load tasks ($e).');
    }
  }

  /// Any exception inside a write means the transaction was rolled back.
  Future<T> _write<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on RecordNotFoundException catch (e) {
      throw TaskNotFoundFailure(e.id);
    } on SimulatedWriteFailure {
      throw const WriteFailedFailure(
        'Simulated write failure. Nothing was saved.',
      );
    } catch (e) {
      throw WriteFailedFailure('Could not save changes ($e).');
    }
  }
}
