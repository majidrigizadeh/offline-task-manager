import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_messages.dart';
import '../../domain/entities/task_activity_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/enums/activity_type.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/usecases/get_task_activities.dart';
import 'priority_label.dart';

/// Read-only, one-shot fetch, so a FutureBuilder is enough (no cubit).
class ActivityTimelineSheet extends StatefulWidget {
  const ActivityTimelineSheet({
    super.key,
    required this.task,
    required this.getActivities,
  });

  final TaskEntity task;
  final GetTaskActivities getActivities;

  @override
  State<ActivityTimelineSheet> createState() => _ActivityTimelineSheetState();
}

class _ActivityTimelineSheetState extends State<ActivityTimelineSheet> {
  late final Future<List<TaskActivityEntity>> _activities = widget
      .getActivities(widget.task.id);
  static final DateFormat _format = DateFormat(
    AppMessages.activityTimestampFormat,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                AppMessages.historyTitle(widget.task.title),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: FutureBuilder<List<TaskActivityEntity>>(
                future: _activities,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(AppMessages.loadHistoryFailed),
                    );
                  }
                  final activities = snapshot.data;
                  if (activities == null) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: activities.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: Icon(_icon(activities[i].type)),
                      title: Text(_describe(activities[i])),
                      subtitle: Text(
                        _format.format(activities[i].createdAt.toLocal()),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _icon(ActivityType type) => switch (type) {
    ActivityType.created => Icons.add_circle_outline,
    ActivityType.titleChanged => Icons.title,
    ActivityType.descriptionChanged => Icons.notes,
    ActivityType.priorityChanged => Icons.flag_outlined,
    ActivityType.completed => Icons.check_circle_outline,
    ActivityType.reopened => Icons.replay,
  };

  static String _describe(TaskActivityEntity a) => switch (a.type) {
    ActivityType.created => AppMessages.activityCreated,
    ActivityType.titleChanged => AppMessages.activityTitleChanged(
      a.oldValue ?? '',
      a.newValue ?? '',
    ),
    ActivityType.descriptionChanged => switch ((a.oldValue, a.newValue)) {
      (null, _) => AppMessages.activityDescriptionAdded,
      (_, null) => AppMessages.activityDescriptionRemoved,
      _ => AppMessages.activityDescriptionChanged,
    },
    ActivityType.priorityChanged => AppMessages.activityPriorityChanged(
      _priority(a.oldValue),
      _priority(a.newValue),
    ),
    ActivityType.completed => AppMessages.activityCompleted,
    ActivityType.reopened => AppMessages.activityReopened,
  };

  static String _priority(String? name) =>
      TaskPriority.values.asNameMap()[name]?.label ?? (name ?? '?');
}
