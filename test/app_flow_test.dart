import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testniksam/app/app.dart';
import 'package:testniksam/app/di/injection.dart';
import 'package:testniksam/core/config/write_failure_config.dart';
import 'package:testniksam/core/database/app_database.dart';
import 'package:testniksam/features/tasks/domain/enums/task_priority.dart';
import 'package:testniksam/features/tasks/domain/repositories/task_repository.dart';
import 'package:testniksam/features/tasks/presentation/widgets/task_tile.dart';

/// Drives the real app (DI, router, cubits, repository, SQLite) end to end,
/// swapping only the on-disk database for an in-memory one.
void main() {
  late AppDatabase db;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await getIt.reset();
    configureDependencies();
    db = AppDatabase(NativeDatabase.memory());
    getIt.allowReassignment = true;
    getIt.registerSingleton<AppDatabase>(db);
    getIt<WriteFailureConfig>().enabled = false;
  });

  tearDown(() async {
    await getIt.reset(dispose: false);
    await db.close();
  });

  Finder checkbox() => find.byType(Checkbox);
  bool isChecked(WidgetTester tester) =>
      tester.widget<Checkbox>(checkbox()).value ?? false;

  Future<void> openHistory(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Show menu').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
  }

  Future<void> closeSheet(WidgetTester tester) async {
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
  }

  testWidgets('create, complete, history, failure + retry, unchanged edit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const TaskApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('No tasks'), findsOneWidget);

    // Create.
    await tester.tap(find.text('New task'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Title *'),
      'Buy milk',
    );
    await tester.tap(find.text('High'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Buy milk'), findsOneWidget);
    expect(isChecked(tester), isFalse);

    // Complete.
    await tester.tap(checkbox());
    await tester.pumpAndSettle();
    expect(isChecked(tester), isTrue);

    await openHistory(tester);
    expect(find.text('Task created'), findsOneWidget);
    expect(find.text('Task completed'), findsOneWidget);
    await closeSheet(tester);

    // Simulated failure: reopen fails, stored (completed) state stays visible.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(checkbox());
    await tester.pumpAndSettle();
    expect(find.textContaining('Simulated write failure'), findsOneWidget);
    expect(isChecked(tester), isTrue);

    // Retry after turning failures off.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(isChecked(tester), isFalse);

    await openHistory(tester);
    expect(find.text('Task reopened'), findsOneWidget);
    expect(find.text('Task completed'), findsOneWidget);
    await closeSheet(tester);

    // Unchanged edit writes nothing.
    final activitiesBefore = await tester.runAsync(
      () => db.select(db.taskActivities).get(),
    );
    await tester.tap(find.text('Buy milk'));
    await tester.pumpAndSettle();
    expect(find.text('Edit task'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Edit task'), findsNothing);
    final activitiesAfter = await tester.runAsync(
      () => db.select(db.taskActivities).get(),
    );
    expect(activitiesAfter, activitiesBefore);

    // Title and description edits show up in the history.
    await tester.tap(find.text('Buy milk'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Title *'),
      'Buy oat milk',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Description (optional)'),
      'From the corner shop',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Buy oat milk'), findsOneWidget);

    await openHistory(tester);
    expect(
      find.text('Title changed: "Buy milk" → "Buy oat milk"'),
      findsOneWidget,
    );
    expect(find.text('Description added'), findsOneWidget);
    await closeSheet(tester);
  });

  testWidgets('scrolling loads further pages; a mutation keeps them loaded', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800); // phone-sized
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // 45 tasks = 3 pages of 20; "Task 44" is newest, "Task 00" oldest.
    await tester.runAsync(() async {
      final repository = getIt<TaskRepository>();
      for (var i = 0; i < 45; i++) {
        await repository.createTask(
          title: 'Task ${i.toString().padLeft(2, '0')}',
          priority: TaskPriority.medium,
        );
      }
    });

    await tester.pumpWidget(const TaskApp());
    await tester.pumpAndSettle();
    expect(find.text('Task 44'), findsOneWidget);

    final list = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    final oldest = find.text('Task 00');
    await tester.scrollUntilVisible(oldest, 300, scrollable: list);
    await tester.pumpAndSettle();
    expect(oldest, findsOneWidget);

    // Completing the last row reloads from storage without dropping pages.
    await tester.tap(
      find.descendant(
        of: find.ancestor(of: oldest, matching: find.byType(TaskTile)),
        matching: find.byType(Checkbox),
      ),
    );
    await tester.pumpAndSettle();
    expect(oldest, findsOneWidget);
    expect(
      tester
          .widget<Checkbox>(
            find.descendant(
              of: find.ancestor(of: oldest, matching: find.byType(TaskTile)),
              matching: find.byType(Checkbox),
            ),
          )
          .value,
      isTrue,
    );
  });
}
