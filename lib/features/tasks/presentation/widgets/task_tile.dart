import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_messages.dart';
import '../../domain/entities/task_entity.dart';
import '../cubit/task_list_cubit.dart';
import '../states/task_list_state.dart';
import 'priority_label.dart';

enum _TileAction { edit, history, delete }

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
  });

  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Only this tile rebuilds when its own pending flag flips.
    return BlocSelector<TaskListCubit, TaskListState, bool>(
      selector: (state) => state.pendingTaskIds.contains(task.id),
      builder: (context, isPending) {
        return ListTile(
          leading: Checkbox(
            value: task.completed,
            onChanged: isPending ? null : (_) => onToggle(),
          ),
          title: Text(
            task.title,
            style: task.completed
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: task.priority.label,
                  style: TextStyle(
                    color: task.priority.color(scheme),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (task.description != null)
                  TextSpan(text: ' · ${task.description}'),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: isPending ? null : onEdit,
          trailing: isPending
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : PopupMenuButton<_TileAction>(
                  onSelected: (action) => switch (action) {
                    _TileAction.edit => onEdit(),
                    _TileAction.history => onHistory(),
                    _TileAction.delete => onDelete(),
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _TileAction.edit,
                      child: Text(AppMessages.edit),
                    ),
                    PopupMenuItem(
                      value: _TileAction.history,
                      child: Text(AppMessages.history),
                    ),
                    PopupMenuItem(
                      value: _TileAction.delete,
                      child: Text(AppMessages.delete),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
