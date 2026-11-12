import '../entities/task_page.dart';
import '../entities/task_query.dart';
import '../repositories/task_repository.dart';

/// Reads one page of tasks matching [TaskQuery], newest first.
class GetTasks {
  const GetTasks(this._repository);

  final TaskRepository _repository;

  /// Returns up to [limit] tasks starting at [offset]. One extra row is
  /// requested to know whether another page exists, without a COUNT query.
  Future<TaskPage> call(
    TaskQuery query, {
    int offset = 0,
    required int limit,
  }) async {
    RangeError.checkNotNegative(offset, 'offset');
    if (limit < 1) throw RangeError.range(limit, 1, null, 'limit');

    final tasks = await _repository.getTasks(
      query,
      offset: offset,
      limit: limit + 1,
    );
    final hasMore = tasks.length > limit;
    return TaskPage(
      tasks: hasMore ? tasks.sublist(0, limit) : tasks,
      hasMore: hasMore,
    );
  }
}
