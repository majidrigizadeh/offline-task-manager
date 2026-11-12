import '../enums/task_priority.dart';
import '../repositories/task_repository.dart';
import 'task_input_validator.dart';

class UpdateTask {
  const UpdateTask(this._repository);

  final TaskRepository _repository;

  /// Returns `false` (and writes nothing) when no value changed.
  Future<bool> call({
    required String id,
    required String title,
    String? description,
    required TaskPriority priority,
  }) {
    TaskInputValidator.validateTitle(title);
    return _repository.updateTask(
      id: id,
      title: title,
      description: description,
      priority: priority,
    );
  }
}
