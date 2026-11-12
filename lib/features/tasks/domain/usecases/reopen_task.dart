import '../repositories/task_repository.dart';

class ReopenTask {
  const ReopenTask(this._repository);

  final TaskRepository _repository;

  /// Returns `false` if the task was not completed (no event written).
  Future<bool> call(String id) => _repository.reopenTask(id);
}
