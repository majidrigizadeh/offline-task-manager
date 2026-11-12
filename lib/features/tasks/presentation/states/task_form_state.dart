import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/task_priority.dart';

part 'task_form_state.freezed.dart';

enum TaskFormStatus { editing, saving, saved, failure }

@freezed
abstract class TaskFormState with _$TaskFormState {
  const factory TaskFormState({
    required bool isEdit,
    @Default('') String title,
    @Default('') String description,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(TaskFormStatus.editing) TaskFormStatus status,
    String? titleError,

    /// Save error; the user's input is kept so they can retry.
    String? errorMessage,

    /// Set when [status] is `saved`: whether anything was persisted.
    @Default(false) bool didPersist,
  }) = _TaskFormState;
}
