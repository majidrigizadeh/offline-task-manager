import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testniksam/core/error/failures.dart';
import 'package:testniksam/features/tasks/domain/entities/task_query.dart';
import 'package:testniksam/features/tasks/domain/enums/completion_filter.dart';
import 'package:testniksam/features/tasks/domain/enums/task_priority.dart';
import 'package:testniksam/features/tasks/domain/usecases/complete_task.dart';
import 'package:testniksam/features/tasks/domain/usecases/delete_task.dart';
import 'package:testniksam/features/tasks/domain/usecases/get_tasks.dart';
import 'package:testniksam/features/tasks/domain/usecases/reopen_task.dart';
import 'package:testniksam/features/tasks/presentation/cubit/task_list_cubit.dart';
import 'package:testniksam/features/tasks/presentation/states/task_list_state.dart';

import '../../../helpers/fake_task_repository.dart';

const _debounce = Duration(milliseconds: 20);

TaskListCubit buildCubit(FakeTaskRepository repo) => TaskListCubit(
  GetTasks(repo),
  CompleteTask(repo),
  ReopenTask(repo),
  DeleteTask(repo),
  debounce: _debounce,
);

Future<void> waitDebounce() =>
    Future<void>.delayed(_debounce + const Duration(milliseconds: 20));

List<String> titlesOf(TaskListCubit cubit) =>
    cubit.state.tasks.map((t) => t.title).toList();

void main() {
  late FakeTaskRepository repo;

  setUp(() {
    repo = FakeTaskRepository(
      tasks: [
        buildTask('1', title: 'alpha', priority: TaskPriority.high),
        buildTask('2', title: 'alpine', priority: TaskPriority.low),
        buildTask('3', title: 'beta', priority: TaskPriority.high),
      ],
    );
  });

  group('search', () {
    test('a slow older query never overwrites a newer result', () async {
      final cubit = buildCubit(repo);
      addTearDown(cubit.close);
      await cubit.load();
      repo.holdReads = true;

      // "a" matches all three tasks, "alp" only two, so a stale overwrite
      // would be visible.
      cubit.searchChanged('a');
      await waitDebounce(); // request #0 ("a") in flight
      cubit.searchChanged('alp');
      await waitDebounce(); // request #1 ("alp") in flight

      expect(repo.pendingReads.map((r) => r.query.search), ['a', 'alp']);

      repo.releaseRead(1); // newest resolves first
      await pumpEventQueue();
      expect(titlesOf(cubit), ['alpha', 'alpine']);

      repo.releaseRead(0); // stale result arrives late
      await pumpEventQueue();
      expect(titlesOf(cubit), ['alpha', 'alpine']);
      expect(cubit.state.query.search, 'alp');
    });

    test(
      'a result in flight is discarded as soon as the user types again',
      () async {
        final cubit = buildCubit(repo);
        addTearDown(cubit.close);
        await cubit.load();
        repo.holdReads = true;

        cubit.searchChanged('be');
        await waitDebounce(); // "be" in flight
        cubit.searchChanged('b'); // typing again before it returns
        repo.releaseRead(0);
        await pumpEventQueue();

        expect(titlesOf(cubit), ['alpha', 'alpine', 'beta']); // unchanged
        await waitDebounce();
        repo.releaseRead(1);
        await pumpEventQueue();
        expect(titlesOf(cubit), ['beta']);
      },
    );

    blocTest<TaskListCubit, TaskListState>(
      'rapid typing is debounced into a single fetch for the final text',
      build: () => buildCubit(repo),
      act: (cubit) {
        cubit
          ..searchChanged('a')
          ..searchChanged('al')
          ..searchChanged('alp');
      },
      wait: _debounce * 3,
      verify: (cubit) {
        expect(repo.queries.map((q) => q.search), ['alp']);
        expect(titlesOf(cubit), ['alpha', 'alpine']);
      },
    );
  });

  group('mutations', () {
    test(
      'search and filters are preserved when reloading after a mutation',
      () async {
        final cubit = buildCubit(repo);
        addTearDown(cubit.close);
        await cubit.load();
        cubit.searchChanged('al');
        await waitDebounce();
        await cubit.priorityFilterChanged(TaskPriority.high);
        await cubit.completionFilterChanged(CompletionFilter.active);
        final expected = const TaskQuery(
          search: 'al',
          priority: TaskPriority.high,
          completion: CompletionFilter.active,
        );
        repo.queries.clear();

        await cubit.complete('1');

        expect(repo.writeCalls, ['complete:1']);
        expect(repo.queries, [expected]);
        expect(cubit.state.query, expected);
        expect(cubit.state.tasks.single.completed, isTrue);
      },
    );

    test('a second tap while a mutation is pending is ignored', () async {
      final cubit = buildCubit(repo);
      addTearDown(cubit.close);
      await cubit.load();

      await Future.wait([cubit.complete('1'), cubit.complete('1')]);

      expect(repo.writeCalls, ['complete:1']);
      expect(cubit.state.pendingTaskIds, isEmpty);
    });

    test(
      'failure reloads stored data, reports an error, and retry succeeds',
      () async {
        final cubit = buildCubit(repo);
        addTearDown(cubit.close);
        await cubit.load();
        repo.failWritesWith = const WriteFailedFailure('disk on fire');
        repo.queries.clear();

        await cubit.complete('1');

        expect(repo.queries, hasLength(1), reason: 'reloads from storage');
        expect(
          cubit.state.tasks.firstWhere((t) => t.id == '1').completed,
          isFalse,
        );
        expect(cubit.state.actionError?.message, 'disk on fire');
        expect(cubit.canRetry, isTrue);

        repo.failWritesWith = null;
        await cubit.retryLastAction();

        expect(repo.writeCalls, ['complete:1', 'complete:1']);
        expect(
          cubit.state.tasks.firstWhere((t) => t.id == '1').completed,
          isTrue,
        );
        expect(cubit.canRetry, isFalse);
      },
    );
  });

  test('close cancels a pending debounce timer', () async {
    final cubit = buildCubit(repo);
    cubit.searchChanged('al');
    await cubit.close();
    await waitDebounce();
    expect(repo.queries, isEmpty);
  });
}
