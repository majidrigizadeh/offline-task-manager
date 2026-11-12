import '../repositories/task_repository.dart';

class CompleteTask {
  const CompleteTask(this._repository);

  final TaskRepository _repository;

  /// Returns `false` if the task was already completed (no event written).
  Future<bool> call(String id) => _repository.completeTask(id);
}
