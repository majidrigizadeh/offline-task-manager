import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_messages.dart';
import '../../domain/entities/task_query.dart';
import '../../domain/enums/completion_filter.dart';
import '../../domain/enums/task_priority.dart';
import '../cubit/task_list_cubit.dart';
import '../states/task_list_state.dart';
import 'priority_label.dart';

class TaskFiltersBar extends StatelessWidget {
  const TaskFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TaskListCubit, TaskListState, TaskQuery>(
      selector: (state) => state.query,
      builder: (context, query) {
        final cubit = context.read<TaskListCubit>();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<TaskPriority?>(
                value: query.priority,
                hint: const Text(AppMessages.anyPriority),
                onChanged: cubit.priorityFilterChanged,
                items: [
                  const DropdownMenuItem(child: Text(AppMessages.anyPriority)),
                  for (final p in TaskPriority.values)
                    DropdownMenuItem(value: p, child: Text(p.label)),
                ],
              ),
              SegmentedButton<CompletionFilter>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: CompletionFilter.all,
                    label: Text(AppMessages.filterAll),
                  ),
                  ButtonSegment(
                    value: CompletionFilter.active,
                    label: Text(AppMessages.filterActive),
                  ),
                  ButtonSegment(
                    value: CompletionFilter.completed,
                    label: Text(AppMessages.filterDone),
                  ),
                ],
                selected: {query.completion},
                onSelectionChanged: (s) =>
                    cubit.completionFilterChanged(s.first),
              ),
            ],
          ),
        );
      },
    );
  }
}
