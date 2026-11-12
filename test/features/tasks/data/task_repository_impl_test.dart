import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:testniksam/core/config/write_failure_config.dart';
import 'package:testniksam/core/database/app_database.dart';
import 'package:testniksam/core/error/failures.dart';
import 'package:testniksam/core/utils/clock.dart';
import 'package:testniksam/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:testniksam/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:testniksam/features/tasks/domain/entities/task_query.dart';
import 'package:testniksam/features/tasks/domain/enums/activity_type.dart';
import 'package:testniksam/features/tasks/domain/enums/completion_filter.dart';
import 'package:testniksam/features/tasks/domain/enums/task_priority.dart';
import 'package:testniksam/features/tasks/domain/repositories/task_repository.dart';
import 'package:testniksam/features/tasks/domain/usecases/get_tasks.dart';
import 'package:uuid/uuid.dart';

import '../../../helpers/fake_clock.dart';

/// Every call returns the same instant, to force `created_at` ties.
class _FrozenClock implements Clock {
  @override
  DateTime now() => DateTime.utc(2026, 1, 1, 9);
}

typedef DbSnapshot = ({List<TaskRow> tasks, List<TaskActivityRow> activities});

TaskRepository buildRepository(AppDatabase db, WriteFailureConfig failures) =>
    TaskRepositoryImpl(
      TaskLocalDataSource(db, failures, const Uuid(), FakeClock()),
    );

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  late AppDatabase db;
  late WriteFailureConfig failures;
  late TaskRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    failures = WriteFailureConfig(enabled: false);
    repository = buildRepository(db, failures);
  });

  tearDown(() => db.close());

  Future<DbSnapshot> snapshot() async => (
    tasks: await db.select(db.tasks).get(),
    activities: await db.select(db.taskActivities).get(),
  );

  Future<String> createTask({
    String title = 'Task',
    String? description,
    TaskPriority priority = TaskPriority.medium,
  }) async => (await repository.createTask(
    title: title,
    description: description,
    priority: priority,
  )).id;

  Future<List<ActivityType>> activityTypes(String taskId) async =>
      (await repository.getActivities(taskId)).map((e) => e.type).toList();

  group('create', () {
    test('persists the task and its created activity together', () async {
      final id = await createTask(title: '  Write tests  ', description: ' ');

      final task = await repository.getTask(id);
      expect(task.title, 'Write tests');
      expect(task.description, isNull);
      expect(task.completed, isFalse);
      expect(await activityTypes(id), [ActivityType.created]);
    });
  });

  group('atomic rollback when FAIL_WRITES is enabled', () {
    late String id;
    late DbSnapshot before;

    setUp(() async {
      id = await createTask(title: 'Original', priority: TaskPriority.low);
      before = await snapshot();
      failures.enabled = true;
    });

    Future<void> expectRolledBack(Future<Object?> Function() action) async {
      await expectLater(action(), throwsA(isA<WriteFailedFailure>()));
      final after = await snapshot();
      expect(after.tasks, before.tasks);
      expect(after.activities, before.activities);
    }

    test('create leaves no task and no activity', () async {
      await expectRolledBack(
        () => repository.createTask(title: 'New', priority: TaskPriority.high),
      );
    });

    test('title-only update (single write) is rolled back', () async {
      await expectRolledBack(
        () => repository.updateTask(
          id: id,
          title: 'Renamed',
          priority: TaskPriority.low,
        ),
      );
    });

    test('priority update and its activity are rolled back', () async {
      await expectRolledBack(
        () => repository.updateTask(
          id: id,
          title: 'Original',
          priority: TaskPriority.high,
        ),
      );
    });

    test('complete is rolled back', () async {
      await expectRolledBack(() => repository.completeTask(id));
    });

    test('reopen is rolled back', () async {
      failures.enabled = false;
      await repository.completeTask(id);
      before = await snapshot();
      failures.enabled = true;

      await expectRolledBack(() => repository.reopenTask(id));
    });

    test('delete restores the task and its cascaded history', () async {
      await expectRolledBack(() => repository.deleteTask(id));
    });

    test('retry succeeds once failures are disabled', () async {
      await expectRolledBack(() => repository.completeTask(id));

      failures.enabled = false;
      expect(await repository.completeTask(id), isTrue);
      expect(await activityTypes(id), [
        ActivityType.created,
        ActivityType.completed,
      ]);
    });
  });

  group('no-op saves write nothing', () {
    test('identical values return false and change no rows', () async {
      final id = await createTask(title: 'Same', description: 'Desc');
      final before = await snapshot();

      final changed = await repository.updateTask(
        id: id,
        title: 'Same',
        description: 'Desc',
        priority: TaskPriority.medium,
      );

      expect(changed, isFalse);
      final after = await snapshot();
      expect(after.tasks, before.tasks);
      expect(after.activities, before.activities);
    });

    test(
      'null vs empty/blank description and padded title are unchanged',
      () async {
        final id = await createTask(title: 'Same');
        final before = await snapshot();

        for (final description in [null, '', '   ']) {
          final changed = await repository.updateTask(
            id: id,
            title: '  Same ',
            description: description,
            priority: TaskPriority.medium,
          );
          expect(changed, isFalse, reason: 'description: "$description"');
        }
        expect((await snapshot()).tasks, before.tasks);
      },
    );

    test(
      'no-op still writes nothing while failures are enabled (no error)',
      () async {
        final id = await createTask(title: 'Same');
        failures.enabled = true;

        final changed = await repository.updateTask(
          id: id,
          title: 'Same',
          priority: TaskPriority.medium,
        );

        expect(changed, isFalse);
      },
    );
  });

  group('priority change activity', () {
    test('records old and new values', () async {
      final id = await createTask(title: 'P', priority: TaskPriority.low);

      final changed = await repository.updateTask(
        id: id,
        title: 'P',
        priority: TaskPriority.high,
      );

      expect(changed, isTrue);
      final events = await repository.getActivities(id);
      expect(events.map((e) => e.type), [
        ActivityType.created,
        ActivityType.priorityChanged,
      ]);
      expect(events.last.oldValue, 'low');
      expect(events.last.newValue, 'high');
      expect((await repository.getTask(id)).priority, TaskPriority.high);
    });
  });

  group('title and description change activities', () {
    test('title change records normalized old and new values', () async {
      final id = await createTask(title: 'Old', priority: TaskPriority.low);

      final changed = await repository.updateTask(
        id: id,
        title: '  New  ',
        priority: TaskPriority.low,
      );

      expect(changed, isTrue);
      expect((await repository.getTask(id)).title, 'New');
      final events = await repository.getActivities(id);
      expect(events.map((e) => e.type), [
        ActivityType.created,
        ActivityType.titleChanged,
      ]);
      expect(events.last.oldValue, 'Old');
      expect(events.last.newValue, 'New');
    });

    test('description added, changed and removed are each recorded', () async {
      final id = await createTask(title: 'D');

      Future<void> setDescription(String? description) async {
        final changed = await repository.updateTask(
          id: id,
          title: 'D',
          description: description,
          priority: TaskPriority.medium,
        );
        expect(changed, isTrue);
      }

      await setDescription(' first ');
      await setDescription('second');
      await setDescription('   ');

      final events = await repository.getActivities(id);
      expect(events.map((e) => e.type), [
        ActivityType.created,
        ActivityType.descriptionChanged,
        ActivityType.descriptionChanged,
        ActivityType.descriptionChanged,
      ]);
      expect(events.skip(1).map((e) => (e.oldValue, e.newValue)), [
        (null, 'first'),
        ('first', 'second'),
        ('second', null),
      ]);
    });

    test('changing every field in one save records one event per field, '
        'in form order', () async {
      final id = await createTask(
        title: 'Old',
        description: 'old notes',
        priority: TaskPriority.low,
      );

      await repository.updateTask(
        id: id,
        title: 'New',
        description: 'new notes',
        priority: TaskPriority.high,
      );

      expect(await activityTypes(id), [
        ActivityType.created,
        ActivityType.titleChanged,
        ActivityType.descriptionChanged,
        ActivityType.priorityChanged,
      ]);
    });

    test('whitespace-only edits record nothing', () async {
      final id = await createTask(title: 'Same', description: 'notes');

      final changed = await repository.updateTask(
        id: id,
        title: ' Same ',
        description: 'notes  ',
        priority: TaskPriority.medium,
      );

      expect(changed, isFalse);
      expect(await activityTypes(id), [ActivityType.created]);
    });

    test('title, description and priority events roll back together', () async {
      final id = await createTask(title: 'Old', priority: TaskPriority.low);
      final before = await snapshot();
      failures.enabled = true;

      await expectLater(
        repository.updateTask(
          id: id,
          title: 'New',
          description: 'notes',
          priority: TaskPriority.high,
        ),
        throwsA(isA<WriteFailedFailure>()),
      );

      final after = await snapshot();
      expect(after.tasks, before.tasks);
      expect(after.activities, before.activities);
    });
  });

  group('complete / reopen concurrency', () {
    late String taskId;

    setUp(() async => taskId = await createTask());

    test(
      'rapid complete requests should create only one completed event',
      () async {
        await Future.wait([
          repository.completeTask(taskId),
          repository.completeTask(taskId),
        ]);

        final task = await repository.getTask(taskId);
        final events = await repository.getActivities(taskId);

        expect(task.completed, true);

        expect(events.where((e) => e.type == ActivityType.completed).length, 1);
      },
    );

    test('rapid reopen requests create only one reopened event', () async {
      await repository.completeTask(taskId);

      final results = await Future.wait([
        repository.reopenTask(taskId),
        repository.reopenTask(taskId),
      ]);

      expect(results.where((changed) => changed), hasLength(1));
      expect((await repository.getTask(taskId)).completed, isFalse);
      expect(await activityTypes(taskId), [
        ActivityType.created,
        ActivityType.completed,
        ActivityType.reopened,
      ]);
    });

    test('interleaved complete/reopen never repeats an event type', () async {
      await Future.wait([
        for (var i = 0; i < 20; i++)
          i.isEven
              ? repository.completeTask(taskId)
              : repository.reopenTask(taskId),
      ]);

      final types = (await activityTypes(taskId)).skip(1).toList();
      for (var i = 1; i < types.length; i++) {
        expect(types[i], isNot(types[i - 1]), reason: 'events: $types');
      }
      final task = await repository.getTask(taskId);
      final expectedLast = task.completed
          ? ActivityType.completed
          : ActivityType.reopened;
      if (types.isNotEmpty) expect(types.last, expectedLast);
    });

    test(
      'complete waits for a writer on ANOTHER connection, then sees its '
      'committed state and no-ops (BEGIN IMMEDIATE + busy_timeout)',
      () async {
        final dir = await Directory.systemTemp.createTemp('tasks_two_conn');
        addTearDown(() => dir.delete(recursive: true));
        final file = File(p.join(dir.path, 'tasks.sqlite'));

        // Background isolates => two independent SQLite connections, so
        // Drift's per-connection transaction queue cannot serialize them.
        final dbA = AppDatabase(NativeDatabase.createInBackground(file));
        final dbB = AppDatabase(NativeDatabase.createInBackground(file));
        addTearDown(dbA.close);
        addTearDown(dbB.close);
        final repoA = buildRepository(dbA, WriteFailureConfig(enabled: false));
        final id = (await repoA.createTask(
          title: 'Shared',
          priority: TaskPriority.low,
        )).id;

        // Connection B completes the task in a write transaction it keeps open.
        await dbB.customStatement('BEGIN IMMEDIATE');
        await dbB.customStatement(
          'UPDATE tasks SET completed = 1 WHERE id = ?',
          [id],
        );
        await dbB
            .into(dbB.taskActivities)
            .insert(
              TaskActivitiesCompanion.insert(
                id: 'from-connection-b',
                taskId: id,
                type: ActivityType.completed.name,
                createdAt: DateTime.utc(2026, 1, 1, 10),
              ),
            );

        // A starts completing while B still holds the write lock.
        final pendingA = repoA.completeTask(id);
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await dbB.customStatement('COMMIT');

        // Drift begins transactions with BEGIN IMMEDIATE, so A blocks on the
        // write lock (busy_timeout) until B commits, then sees fresh state.
        // Without `PRAGMA busy_timeout` A fails with "database is locked"
        // (verified by removing the pragma).
        expect(await pendingA, isFalse);
        final events = await repoA.getActivities(id);
        expect(
          events.where((e) => e.type == ActivityType.completed),
          hasLength(1),
        );
        expect((await repoA.getTask(id)).completed, isTrue);
      },
    );
  });

  group('missing task', () {
    const missing = 'does-not-exist';

    test('every mutation throws TaskNotFoundFailure', () async {
      final notFound = throwsA(isA<TaskNotFoundFailure>());
      await expectLater(repository.getTask(missing), notFound);
      await expectLater(repository.completeTask(missing), notFound);
      await expectLater(repository.reopenTask(missing), notFound);
      await expectLater(repository.deleteTask(missing), notFound);
      await expectLater(
        repository.updateTask(
          id: missing,
          title: 'x',
          priority: TaskPriority.low,
        ),
        notFound,
      );
    });
  });

  group('search and filters', () {
    setUp(() async {
      await createTask(title: 'Buy milk', priority: TaskPriority.high);
      final bread = await createTask(
        title: 'buy bread',
        priority: TaskPriority.low,
      );
      final report = await createTask(
        title: 'Write report',
        priority: TaskPriority.high,
      );
      await createTask(title: '100% done', priority: TaskPriority.medium);
      await createTask(title: 'snake_case', priority: TaskPriority.low);
      await repository.completeTask(bread);
      await repository.completeTask(report);
    });

    Future<List<String>> titles(TaskQuery query) async =>
        (await repository.getTasks(
          query,
          offset: 0,
          limit: 100,
        )).map((t) => t.title).toList();

    test('no filters returns all tasks, newest first', () async {
      expect(await titles(const TaskQuery()), [
        'snake_case',
        '100% done',
        'Write report',
        'buy bread',
        'Buy milk',
      ]);
    });

    test('search is case-insensitive substring', () async {
      expect(await titles(const TaskQuery(search: 'BUY')), [
        'buy bread',
        'Buy milk',
      ]);
    });

    test('priority + completion combine', () async {
      expect(
        await titles(
          const TaskQuery(
            priority: TaskPriority.high,
            completion: CompletionFilter.completed,
          ),
        ),
        ['Write report'],
      );
      expect(
        await titles(
          const TaskQuery(
            priority: TaskPriority.high,
            completion: CompletionFilter.active,
          ),
        ),
        ['Buy milk'],
      );
    });

    test('search + priority + completion combine', () async {
      expect(
        await titles(
          const TaskQuery(
            search: 'buy',
            priority: TaskPriority.low,
            completion: CompletionFilter.completed,
          ),
        ),
        ['buy bread'],
      );
      expect(
        await titles(
          const TaskQuery(
            search: 'buy',
            priority: TaskPriority.low,
            completion: CompletionFilter.active,
          ),
        ),
        isEmpty,
      );
    });

    test('LIKE wildcards in the query are matched literally', () async {
      expect(await titles(const TaskQuery(search: '%')), ['100% done']);
      expect(await titles(const TaskQuery(search: '_')), ['snake_case']);
    });
  });

  group('pagination', () {
    late GetTasks getTasks;

    setUp(() async {
      getTasks = GetTasks(repository);
      for (var i = 0; i < 7; i++) {
        await createTask(
          title: 'Task $i',
          priority: i.isEven ? TaskPriority.high : TaskPriority.low,
        );
      }
    });

    Future<List<String>> allPages(TaskQuery query, int pageSize) async {
      final titles = <String>[];
      var hasMore = true;
      while (hasMore) {
        final page = await getTasks(
          query,
          offset: titles.length,
          limit: pageSize,
        );
        expect(page.tasks.length, lessThanOrEqualTo(pageSize));
        titles.addAll(page.tasks.map((t) => t.title));
        hasMore = page.hasMore;
      }
      return titles;
    }

    test(
      'pages concatenate to the full ordered list, no gaps or overlap',
      () async {
        expect(await allPages(const TaskQuery(), 3), [
          for (var i = 6; i >= 0; i--) 'Task $i',
        ]);
      },
    );

    test('paging applies after search and filters', () async {
      final page = await getTasks(
        const TaskQuery(priority: TaskPriority.high),
        limit: 2,
      );
      expect(page.tasks.map((t) => t.title), ['Task 6', 'Task 4']);
      expect(page.hasMore, isTrue);
      expect(await allPages(const TaskQuery(priority: TaskPriority.high), 2), [
        'Task 6',
        'Task 4',
        'Task 2',
        'Task 0',
      ]);
    });

    test('hasMore is false when the last page is exactly full', () async {
      final page = await getTasks(const TaskQuery(), offset: 4, limit: 3);
      expect(page.tasks, hasLength(3));
      expect(page.hasMore, isFalse);
    });

    test('an offset past the end returns an empty page', () async {
      final page = await getTasks(const TaskQuery(), offset: 50, limit: 3);
      expect(page.tasks, isEmpty);
      expect(page.hasMore, isFalse);
    });

    test(
      'tasks created in the same millisecond page by insertion order',
      () async {
        await db.delete(db.tasks).go();
        final sameInstant = TaskRepositoryImpl(
          TaskLocalDataSource(db, failures, const Uuid(), _FrozenClock()),
        );
        for (var i = 0; i < 5; i++) {
          await sameInstant.createTask(
            title: 'Tie $i',
            priority: TaskPriority.medium,
          );
        }
        expect(await allPages(const TaskQuery(), 2), [
          for (var i = 4; i >= 0; i--) 'Tie $i',
        ]);
      },
    );

    test('rejects a negative offset or a non-positive limit', () {
      expect(
        () => getTasks(const TaskQuery(), offset: -1, limit: 1),
        throwsRangeError,
      );
      expect(() => getTasks(const TaskQuery(), limit: 0), throwsRangeError);
    });
  });

  group('delete', () {
    test('cascades to the activity history', () async {
      final id = await createTask();
      await repository.completeTask(id);
      final other = await createTask(title: 'Other');

      await repository.deleteTask(id);

      final remaining = await db.select(db.taskActivities).get();
      expect(remaining.map((a) => a.taskId).toSet(), {other});
      await expectLater(
        repository.getTask(id),
        throwsA(isA<TaskNotFoundFailure>()),
      );
    });
  });

  group('persistence', () {
    test('data survives closing and reopening the database file', () async {
      final dir = await Directory.systemTemp.createTemp('tasks_restart');
      addTearDown(() => dir.delete(recursive: true));
      final file = File(p.join(dir.path, 'tasks.sqlite'));

      final first = AppDatabase(NativeDatabase(file));
      final repo1 = buildRepository(first, WriteFailureConfig(enabled: false));
      final created = await repo1.createTask(
        title: 'Survivor',
        priority: TaskPriority.high,
      );
      await repo1.completeTask(created.id);
      await first.close();

      final second = AppDatabase(NativeDatabase(file));
      addTearDown(second.close);
      final repo2 = buildRepository(second, WriteFailureConfig(enabled: false));

      final task = await repo2.getTask(created.id);
      expect(task.title, 'Survivor');
      expect(task.completed, isTrue);
      expect((await repo2.getActivities(created.id)).map((e) => e.type), [
        ActivityType.created,
        ActivityType.completed,
      ]);
    });
  });
}
