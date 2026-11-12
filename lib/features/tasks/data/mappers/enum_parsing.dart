import '../../domain/enums/activity_type.dart';
import '../../domain/enums/task_priority.dart';

/// Safe parsing of enum names coming from storage or (later) the network.
/// `Enum.values.byName` throws on unknown input; these never throw.
extension TaskPriorityParsing on String {
  /// Unknown priorities degrade to [TaskPriority.medium] rather than crashing.
  TaskPriority toTaskPriority() =>
      TaskPriority.values.asNameMap()[this] ?? TaskPriority.medium;

  /// `null` for unknown activity types (e.g. written by a newer app version).
  ActivityType? toActivityTypeOrNull() => ActivityType.values.asNameMap()[this];
}
