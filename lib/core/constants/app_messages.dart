/// All user-facing UI strings shown by pages and widgets.
///
/// Static text is `const` so it can be used inside `const` widgets.
/// Text with runtime values is exposed as static methods.
abstract final class AppMessages {
  // App
  static const String appTitle = 'Tasks';

  // Common actions
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String history = 'History';
  static const String save = 'Save';
  static const String retrySave = 'Retry save';
  static const String clear = 'Clear';

  // Task list page
  static const String taskListTitle = 'Tasks';
  static const String newTask = 'New task';
  static const String deleteTaskTitle = 'Delete task?';
  static String deleteTaskContent(String title) =>
      '"$title" and its history will be deleted.';
  static const String loadTasksFailed = 'Could not load tasks.';
  static const String noTasksMatch =
      'No tasks match the current search and filters.';

  // Task form page
  static const String editTask = 'Edit task';
  static const String titleLabel = 'Title *';
  static const String descriptionLabel = 'Description (optional)';
  static const String priority = 'Priority';

  // Priorities
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';

  // Search & filters
  static const String searchHint = 'Search by title';
  static const String anyPriority = 'Any priority';
  static const String filterAll = 'All';
  static const String filterActive = 'Active';
  static const String filterDone = 'Done';

  // Failure-mode switch
  static const String failWrites = 'Fail writes';

  // Activity timeline sheet
  static String historyTitle(String taskTitle) => 'History — $taskTitle';
  static const String loadHistoryFailed = 'Could not load history.';
  static const String activityCreated = 'Task created';
  static const String activityCompleted = 'Task completed';
  static const String activityReopened = 'Task reopened';
  static String activityPriorityChanged(String from, String to) =>
      'Priority changed: $from → $to';
  static const String activityTimestampFormat = 'MMM d, y · HH:mm:ss';
}
