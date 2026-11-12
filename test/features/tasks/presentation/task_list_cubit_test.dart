import 'dart:async';

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

TaskListCubit buildCubit(FakeTaskRepository repo, {int pageSize = 20}) =>
    TaskListCubit(
      GetTasks(repo),
      CompleteTask(repo),
      ReopenTask(repo),
      DeleteTask(repo),
      debounce: _debounce,
      pageSize: pageSize,
    );

Future<void> waitDebounce() =>
    Future<void>.delayed(_debounce + const Duration(milliseconds: 20));

List<String> titlesOf(TaskListCubit cubit) =>
    cubit.state.tasks.map((t) => t.title).toList();

List<String> idsOf(TaskListCubit cubit) =>
    cubit.state.tasks.map((t) => t.id).toList();

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

  group('pagination (page size 2)', () {
    // Odd ids are high priority, even ids low.
    setUp(() {
      repo = FakeTaskRepository(
        tasks: [
          for (var i = 1; i <= 5; i++)
            buildTask(
              '$i',
              priority: i.isOdd ? TaskPriority.high : TaskPriority.low,
            ),
        ],
      );
    });

    TaskListCubit build() {
      final cubit = buildCubit(repo, pageSize: 2);
      addTearDown(cubit.close);
      return cubit;
    }

    test('first load reads one page and probes for more', () async {
      final cubit = build();
      await cubit.load();

      expect(idsOf(cubit), ['1', '2']);
      expect(cubit.state.hasMore, isTrue);
      expect(repo.pageRequests, [(offset: 0, limit: 3)]);
    });

    test('loadMore appends pages until the end, then stops', () async {
      final cubit = build();
      await cubit.load();
      await cubit.loadMore();
      await cubit.loadMore();

      expect(idsOf(cubit), ['1', '2', '3', '4', '5']);
      expect(cubit.state.hasMore, isFalse);
      expect(cubit.state.isLoadingMore, isFalse);

      await cubit.loadMore();
      expect(repo.pageRequests, [
        (offset: 0, limit: 3),
        (offset: 2, limit: 3),
        (offset: 4, limit: 3),
      ]);
    });

    test('a mutation reloads every loaded row, not just page one', () async {
      final cubit = build();
      await cubit.load();
      await cubit.loadMore();

      await cubit.complete('1');
      expect(repo.pageRequests.last, (offset: 0, limit: 5));
      expect(idsOf(cubit), ['1', '2', '3', '4']);
      expect(cubit.state.tasks.first.completed, isTrue);
      expect(cubit.state.hasMore, isTrue);

      // A delete pulls the next stored row into the window.
      await cubit.delete('2');
      expect(idsOf(cubit), ['1', '3', '4', '5']);
      expect(cubit.state.hasMore, isFalse);
    });

    test('a filter change starts again from the first page', () async {
      final cubit = build();
      await cubit.load();
      await cubit.loadMore();

      await cubit.priorityFilterChanged(TaskPriority.high);

      expect(repo.pageRequests.last, (offset: 0, limit: 3));
      expect(idsOf(cubit), ['1', '3']);
      expect(cubit.state.hasMore, isTrue);
    });

    test('a next page in flight is dropped when the query changes', () async {
      final cubit = build();
      await cubit.load();
      repo.holdReads = true;

      unawaited(cubit.loadMore()); // read #0: offset 2 of the old query
      expect(cubit.state.isLoadingMore, isTrue);
      unawaited(cubit.priorityFilterChanged(TaskPriority.high)); // read #1

      repo.releaseRead(1);
      await pumpEventQueue();
      repo.releaseRead(0); // stale page arrives last
      await pumpEventQueue();

      expect(idsOf(cubit), ['1', '3']);
      expect(cubit.state.isLoadingMore, isFalse);
    });

    test('loadMore is ignored while a search is debouncing', () async {
      final cubit = build();
      await cubit.load();

      cubit.searchChanged('Task 5');
      await cubit.loadMore(); // shown rows belong to the old query

      expect(repo.pageRequests, hasLength(1));
      await waitDebounce();
      expect(idsOf(cubit), ['5']);
    });

    test('a failed next page keeps the list and can be retried', () async {
      final cubit = build();
      await cubit.load();
      repo.failReadsWith = const UnexpectedFailure('boom');

      await cubit.loadMore();
      expect(idsOf(cubit), ['1', '2']);
      expect(cubit.state.status, TaskListStatus.success);
      expect(cubit.state.loadMoreError, 'boom');
      expect(cubit.state.isLoadingMore, isFalse);

      repo.failReadsWith = null;
      await cubit.loadMore();
      expect(idsOf(cubit), ['1', '2', '3', '4']);
      expect(cubit.state.loadMoreError, isNull);
    });

    test(
      'rows shifted under the offset trigger a full window reload',
      () async {
        final cubit = build();
        await cubit.load();
        // Another writer inserts a newer task, pushing '2' to offset 2.
        repo.tasks = [buildTask('0'), ...repo.tasks];

        await cubit.loadMore();

        expect(idsOf(cubit), ['0', '1', '2', '3']);
        expect(repo.pageRequests.last, (offset: 0, limit: 5));
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
