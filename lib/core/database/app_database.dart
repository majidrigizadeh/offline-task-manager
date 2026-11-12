import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'migrations/migrations.dart';
import 'tables/task_activities_table.dart';
import 'tables/tasks_table.dart';

export 'tables/task_activities_table.dart';
export 'tables/tasks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks, TaskActivities])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-disk database in the app support directory.
  factory AppDatabase.open() => AppDatabase(
    LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, AppConstants.databaseFileName));
      return NativeDatabase.createInBackground(file);
    }),
  );

  /// Bump on every schema change and add a step in `migrations.dart`.
  static const int currentSchemaVersion = 1;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: runMigrations,
    beforeOpen: (details) async {
      // Required for ON DELETE CASCADE; SQLite disables FKs by default.
      await customStatement('PRAGMA foreign_keys = ON');
      // Wait for locks held by other connections instead of failing at once.
      await customStatement('PRAGMA busy_timeout = 5000');
    },
  );
}
