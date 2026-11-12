/// Domain-facing failures thrown by repositories.
///
/// Repositories throw (rather than return Either/Result) so callers can use
/// plain return values, e.g. `(await repo.getTask(id)).completed`.
sealed class TaskFailure implements Exception {
  const TaskFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// A write was rejected and rolled back; nothing was persisted.
final class WriteFailedFailure extends TaskFailure {
  const WriteFailedFailure([
    super.message = 'Could not save changes. Nothing was modified.',
  ]);
}

final class TaskNotFoundFailure extends TaskFailure {
  const TaskNotFoundFailure(String id) : super('Task $id no longer exists.');
}

/// Input rejected by business rules (e.g. empty title). Nothing was written.
final class InvalidInputFailure extends TaskFailure {
  const InvalidInputFailure(super.message);
}

final class UnexpectedFailure extends TaskFailure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}
