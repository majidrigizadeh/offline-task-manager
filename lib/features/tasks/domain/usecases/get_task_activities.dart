import '../entities/task_activity_entity.dart';
import '../repositories/task_repository.dart';

class GetTaskActivities {
  const GetTaskActivities(this._repository);

  final TaskRepository _repository;

  Future<List<TaskActivityEntity>> call(String taskId) =>
      _repository.getActivities(taskId);
}
