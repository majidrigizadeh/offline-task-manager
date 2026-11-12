import 'package:injectable/injectable.dart';

import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/domain/usecases/complete_task.dart';
import '../../features/tasks/domain/usecases/create_task.dart';
import '../../features/tasks/domain/usecases/delete_task.dart';
import '../../features/tasks/domain/usecases/get_task_activities.dart';
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/domain/usecases/reopen_task.dart';
import '../../features/tasks/domain/usecases/update_task.dart';

/// Registers use cases here so the domain layer has no injectable imports.
@module
abstract class TasksModule {
  @lazySingleton
  GetTasks getTasks(TaskRepository r) => GetTasks(r);

  @lazySingleton
  GetTaskActivities getTaskActivities(TaskRepository r) => GetTaskActivities(r);

  @lazySingleton
  CreateTask createTask(TaskRepository r) => CreateTask(r);

  @lazySingleton
  UpdateTask updateTask(TaskRepository r) => UpdateTask(r);

  @lazySingleton
  CompleteTask completeTask(TaskRepository r) => CompleteTask(r);

  @lazySingleton
  ReopenTask reopenTask(TaskRepository r) => ReopenTask(r);

  @lazySingleton
  DeleteTask deleteTask(TaskRepository r) => DeleteTask(r);
}
