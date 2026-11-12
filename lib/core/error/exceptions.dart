/// Data-layer exceptions. These never reach presentation: the repository
/// translates them into [TaskFailure]s.
class SimulatedWriteFailure implements Exception {
  const SimulatedWriteFailure(this.operation);

  final String operation;

  @override
  String toString() => 'SimulatedWriteFailure($operation)';
}

class RecordNotFoundException implements Exception {
  const RecordNotFoundException(this.id);

  final String id;

  @override
  String toString() => 'RecordNotFoundException($id)';
}
