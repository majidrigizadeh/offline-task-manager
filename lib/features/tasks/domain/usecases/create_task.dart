import '../entities/task_entity.dart';
import '../enums/task_priority.dart';
import '../repositories/task_repository.dart';
import 'task_input_validator.dart';

class CreateTask {
  const CreateTask(this._repository);

  final TaskRepository _repository;

  /// Creates the task and its `created` activity atomically.
  Future<TaskEntity> call({
    required String title,
    String? description,
    required TaskPriority priority,
  }) {
    TaskInputValidator.validateTitle(title);
    return _repository.createTask(
      title: title,
      description: description,
      priority: priority,
    );
  }
}
