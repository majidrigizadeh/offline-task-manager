import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/text_normalizer.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/task_input_validator.dart';
import '../../domain/usecases/update_task.dart';
import '../states/task_form_state.dart';

/// One form for create (no [initialTask]) and edit.
@injectable
class TaskFormCubit extends Cubit<TaskFormState> {
  TaskFormCubit(
    this._createTask,
    this._updateTask,
    @factoryParam this._initialTask,
  ) : super(
        TaskFormState(
          isEdit: _initialTask != null,
          title: _initialTask?.title ?? '',
          description: _initialTask?.description ?? '',
          priority: _initialTask?.priority ?? TaskPriority.medium,
        ),
      );

  final CreateTask _createTask;
  final UpdateTask _updateTask;
  final TaskEntity? _initialTask;

  void titleChanged(String value) =>
      emit(state.copyWith(title: value, titleError: null));

  void descriptionChanged(String value) =>
      emit(state.copyWith(description: value));

  void priorityChanged(TaskPriority value) =>
      emit(state.copyWith(priority: value));

  /// Same normalization as the data source, so both agree on "unchanged".
  bool get hasChanges {
    final initial = _initialTask;
    if (initial == null) return true;
    return TextNormalizer.title(state.title) !=
            TextNormalizer.title(initial.title) ||
        TextNormalizer.description(state.description) !=
            TextNormalizer.description(initial.description) ||
        state.priority != initial.priority;
  }

  Future<void> save() async {
    if (state.status == TaskFormStatus.saving) return;

    if (TextNormalizer.title(state.title).isEmpty) {
      emit(state.copyWith(titleError: TaskInputValidator.titleRequired));
      return;
    }

    final initial = _initialTask;
    if (initial != null && !hasChanges) {
      emit(state.copyWith(status: TaskFormStatus.saved, didPersist: false));
      return;
    }

    emit(state.copyWith(status: TaskFormStatus.saving, errorMessage: null));
    try {
      final bool persisted;
      if (initial == null) {
        await _createTask(
          title: state.title,
          description: state.description,
          priority: state.priority,
        );
        persisted = true;
      } else {
        persisted = await _updateTask(
          id: initial.id,
          title: state.title,
          description: state.description,
          priority: state.priority,
        );
      }
      if (isClosed) return;
      emit(state.copyWith(status: TaskFormStatus.saved, didPersist: persisted));
    } on TaskFailure catch (failure) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TaskFormStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }
}
