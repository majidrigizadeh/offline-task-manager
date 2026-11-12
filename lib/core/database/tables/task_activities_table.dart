import 'package:drift/drift.dart';

import 'tasks_table.dart';

@DataClassName('TaskActivityRow')
@TableIndex(
  name: 'idx_task_activities_task_created',
  columns: {#taskId, #createdAt},
)
class TaskActivities extends Table {
  TextColumn get id => text()();

  /// History is owned by its task: deleting a task deletes its activities.
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();

  /// `ActivityType.name` (created / priorityChanged / completed / reopened).
  TextColumn get type => text()();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
