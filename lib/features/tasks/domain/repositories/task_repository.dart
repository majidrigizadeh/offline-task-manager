import '../entities/task_activity_entity.dart';
import '../entities/task_entity.dart';
import '../entities/task_query.dart';
import '../enums/task_priority.dart';

/// Contract for task persistence.
///
/// Every method throws a `TaskFailure` (see `core/error/failures.dart`) on
/// error. Every mutation is atomic: the task change and its activity event are
/// committed together or not at all.
///
/// Mutations return `true` when state changed and `false` for a no-op (e.g.
/// completing an already-completed task, or saving unchanged values). A no-op
/// writes nothing.
abstract interface class TaskRepository {
  /// Up to [limit] tasks matching [query], skipping the first [offset].
  /// Newest first; insertion order breaks ties, so pages never overlap.
  Future<List<TaskEntity>> getTasks(
    TaskQuery query, {
    required int offset,
    required int limit,
  });

  /// Throws `TaskNotFoundFailure` if [id] does not exist.
  Future<TaskEntity> getTask(String id);

  /// Chronological (oldest first).
  Future<List<TaskActivityEntity>> getActivities(String taskId);

  Future<TaskEntity> createTask({
    required String title,
    String? description,
    required TaskPriority priority,
  });

  Future<bool> updateTask({
    required String id,
    required String title,
    String? description,
    required TaskPriority priority,
  });

  Future<bool> completeTask(String id);

  Future<bool> reopenTask(String id);

  /// Deletes the task and its whole activity history.
  Future<void> deleteTask(String id);
}
