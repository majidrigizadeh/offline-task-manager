import 'package:drift/drift.dart';

/// Schema history
/// --------------
/// v1: `tasks`, `task_activities` (FK task_id → tasks.id ON DELETE CASCADE).
///
/// How to add a schema change:
/// 1. Change the table classes and bump `AppDatabase.schemaVersion` to N.
/// 2. Add a step below: `if (from < N) { ... }` using [Migrator] helpers
///    (`addColumn`, `createTable`, `createIndex`, `alterTable(TableMigration)`).
/// 3. Never edit an existing step — users may be on any older version.
/// 4. Dump the new schema:
///    `dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/`
///    and (optionally) generate migration tests with
///    `dart run drift_dev schema steps` / `schema generate`.
///
/// Steps run sequentially inside Drift's migration transaction, so a v1 user
/// upgrading to v3 runs `from < 2` and then `from < 3`.
Future<void> runMigrations(Migrator m, int from, int to) async {
  // Example for a future v2:
  // if (from < 2) {
  //   await m.addColumn(db.tasks, db.tasks.dueDate);
  // }
  assert(from <= to, 'Downgrades are not supported ($from → $to)');
}
