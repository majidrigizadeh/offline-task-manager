import '../../../../core/database/app_database.dart';
import '../../domain/entities/task_activity_entity.dart';
import '../models/task_activity_model.dart';
import 'enum_parsing.dart';

extension TaskActivityRowMapper on TaskActivityRow {
  TaskActivityModel toModel() => TaskActivityModel(
    id: id,
    taskId: taskId,
    type: type,
    oldValue: oldValue,
    newValue: newValue,
    createdAt: createdAt,
  );
}

extension TaskActivityModelMapper on TaskActivityModel {
  /// `null` when the stored type is unknown to this app version.
  TaskActivityEntity? toEntityOrNull() {
    final parsedType = type.toActivityTypeOrNull();
    if (parsedType == null) return null;
    return TaskActivityEntity(
      id: id,
      taskId: taskId,
      type: parsedType,
      oldValue: oldValue,
      newValue: newValue,
      createdAt: createdAt,
    );
  }

  TaskActivityRow toRow() => TaskActivityRow(
    id: id,
    taskId: taskId,
    type: type,
    oldValue: oldValue,
    newValue: newValue,
    createdAt: createdAt,
  );
}

extension TaskActivityModelListMapper on Iterable<TaskActivityModel> {
  /// Maps to entities, skipping activity types this version can't render.
  List<TaskActivityEntity> toEntities() =>
      map((m) => m.toEntityOrNull()).nonNulls.toList(growable: false);
}

extension TaskActivityEntityMapper on TaskActivityEntity {
  TaskActivityModel toModel() => TaskActivityModel(
    id: id,
    taskId: taskId,
    type: type.name,
    oldValue: oldValue,
    newValue: newValue,
    createdAt: createdAt,
  );
}
