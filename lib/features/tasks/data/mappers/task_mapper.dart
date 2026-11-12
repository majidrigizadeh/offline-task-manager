import '../../../../core/database/app_database.dart';
import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';
import 'enum_parsing.dart';

extension TaskRowMapper on TaskRow {
  TaskModel toModel() => TaskModel(
    id: id,
    title: title,
    description: description,
    priority: priority,
    completed: completed,
    createdAt: createdAt,
  );
}

extension TaskModelMapper on TaskModel {
  TaskEntity toEntity() => TaskEntity(
    id: id,
    title: title,
    description: description,
    priority: priority.toTaskPriority(),
    completed: completed,
    createdAt: createdAt,
  );

  TaskRow toRow() => TaskRow(
    id: id,
    title: title,
    description: description,
    priority: priority,
    completed: completed,
    createdAt: createdAt,
  );
}

extension TaskEntityMapper on TaskEntity {
  TaskModel toModel() => TaskModel(
    id: id,
    title: title,
    description: description,
    priority: priority.name,
    completed: completed,
    createdAt: createdAt,
  );
}
