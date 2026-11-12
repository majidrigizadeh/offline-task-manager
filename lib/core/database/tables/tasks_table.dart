import 'package:drift/drift.dart';

@DataClassName('TaskRow')
@TableIndex(
  name: 'idx_tasks_completed_priority',
  columns: {#completed, #priority},
)
@TableIndex(name: 'idx_tasks_created_at', columns: {#createdAt})
class Tasks extends Table {
  /// UUID v4 — client-generated so rows can later be synced without remapping.
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();

  /// `TaskPriority.name` (low / medium / high).
  TextColumn get priority => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
