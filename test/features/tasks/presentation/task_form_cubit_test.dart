import 'package:flutter_test/flutter_test.dart';
import 'package:testniksam/core/error/failures.dart';
import 'package:testniksam/features/tasks/domain/entities/task_entity.dart';
import 'package:testniksam/features/tasks/domain/enums/task_priority.dart';
import 'package:testniksam/features/tasks/domain/usecases/create_task.dart';
import 'package:testniksam/features/tasks/domain/usecases/update_task.dart';
import 'package:testniksam/features/tasks/presentation/cubit/task_form_cubit.dart';
import 'package:testniksam/features/tasks/presentation/states/task_form_state.dart';

import '../../../helpers/fake_task_repository.dart';

void main() {
  late FakeTaskRepository repo;

  setUp(
    () => repo = FakeTaskRepository(tasks: [buildTask('1', title: 'Keep')]),
  );

  TaskFormCubit build([TaskEntity? task]) =>
      TaskFormCubit(CreateTask(repo), UpdateTask(repo), task);

  test('blank title is rejected without writing', () async {
    final cubit = build()..titleChanged('   ');
    await cubit.save();
    expect(cubit.state.titleError, isNotNull);
    expect(cubit.state.status, TaskFormStatus.editing);
    expect(repo.writeCalls, isEmpty);
  });

  test(
    'unchanged edit (blank description vs null) does not call update',
    () async {
      final cubit = build(repo.tasks.single)
        ..titleChanged(' Keep ')
        ..descriptionChanged('  ');
      await cubit.save();
      expect(cubit.state.status, TaskFormStatus.saved);
      expect(cubit.state.didPersist, isFalse);
      expect(repo.writeCalls, isEmpty);
    },
  );

  test('failed save keeps the input and can be retried', () async {
    final cubit = build()
      ..titleChanged('New task')
      ..descriptionChanged('details')
      ..priorityChanged(TaskPriority.high);
    repo.failWritesWith = const WriteFailedFailure('nope');

    await cubit.save();
    expect(cubit.state.status, TaskFormStatus.failure);
    expect(cubit.state.errorMessage, 'nope');
    expect(cubit.state.title, 'New task');
    expect(cubit.state.description, 'details');
    expect(cubit.state.priority, TaskPriority.high);

    repo.failWritesWith = null;
    await cubit.save();
    expect(cubit.state.status, TaskFormStatus.saved);
    expect(cubit.state.didPersist, isTrue);
    expect(repo.writeCalls, ['create', 'create']);
  });
}
