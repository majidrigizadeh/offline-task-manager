import '../entities/task_entity.dart';
import '../entities/task_query.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  const GetTasks(this._repository);

  final TaskRepository _repository;

  Future<List<TaskEntity>> call(TaskQuery query) => _repository.getTasks(query);
}
