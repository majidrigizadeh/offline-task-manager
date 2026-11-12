import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/config/write_failure_config.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/get_task_activities.dart';
import '../cubit/task_list_cubit.dart';
import '../states/task_list_state.dart';
import '../widgets/activity_timeline_sheet.dart';
import '../widgets/failure_mode_switch.dart';
import '../widgets/search_field.dart';
import '../widgets/task_filters_bar.dart';
import '../widgets/task_tile.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({
    super.key,
    required this.getActivities,
    required this.failureConfig,
  });

  final GetTaskActivities getActivities;
  final WriteFailureConfig failureConfig;

  Future<void> _openForm(BuildContext context, [TaskEntity? task]) async {
    final cubit = context.read<TaskListCubit>();
    final persisted = await Navigator.of(context)
        .pushNamed<bool>(AppRouter.taskForm, arguments: task);
    if (persisted ?? false) await cubit.load();
  }

  Future<void> _confirmDelete(BuildContext context, TaskEntity task) async {
    final cubit = context.read<TaskListCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" and its history will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.delete(task.id);
  }

  void _showTimeline(BuildContext context, TaskEntity task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          ActivityTimelineSheet(task: task, getActivities: getActivities),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskListCubit, TaskListState>(
      listenWhen: (prev, curr) =>
          curr.actionError != null && prev.actionError != curr.actionError,
      listener: (context, state) {
        final cubit = context.read<TaskListCubit>();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.actionError!.message),
              action: cubit.canRetry
                  ? SnackBarAction(
                      label: 'Retry',
                      onPressed: cubit.retryLastAction,
                    )
                  : null,
            ),
          );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          actions: [FailureModeSwitch(config: failureConfig)],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(context),
          icon: const Icon(Icons.add),
          label: const Text('New task'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SearchField(),
            ),
            const TaskFiltersBar(),
            Expanded(
              child: _TaskListBody(
                onEdit: (task) => _openForm(context, task),
                onDelete: (task) => _confirmDelete(context, task),
                onHistory: (task) => _showTimeline(context, task),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListBody extends StatelessWidget {
  const _TaskListBody({
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
  });

  final ValueChanged<TaskEntity> onEdit;
  final ValueChanged<TaskEntity> onDelete;
  final ValueChanged<TaskEntity> onHistory;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      // Pending-id changes are handled per tile; filters by the filter bar.
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.tasks != curr.tasks ||
          prev.loadError != curr.loadError,
      builder: (context, state) {
        final isLoading = state.status == TaskListStatus.loading;
        if ((isLoading || state.status == TaskListStatus.initial) &&
            state.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == TaskListStatus.failure) {
          return _Message(
            icon: Icons.error_outline,
            text: state.loadError ?? 'Could not load tasks.',
            action: TextButton(
              onPressed: context.read<TaskListCubit>().load,
              child: const Text('Retry'),
            ),
          );
        }
        if (state.status == TaskListStatus.empty) {
          return const _Message(
            icon: Icons.inbox_outlined,
            text: 'No tasks match the current search and filters.',
          );
        }
        return Column(
          children: [
            SizedBox(
              height: 2,
              child: isLoading ? const LinearProgressIndicator() : null,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: state.tasks.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskTile(
                    key: ValueKey(task.id),
                    task: task,
                    onToggle: () =>
                        context.read<TaskListCubit>().toggleCompletion(task),
                    onEdit: () => onEdit(task),
                    onDelete: () => onDelete(task),
                    onHistory: () => onHistory(task),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
            ?action,
          ],
        ),
      ),
    );
  }
}
