import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/task_priority.dart';
import '../cubit/task_form_cubit.dart';
import '../states/task_form_state.dart';
import '../widgets/priority_label.dart';

/// Shared create/edit form. Pops `true` when something was persisted.
class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late final TaskFormCubit _cubit = context.read<TaskFormCubit>();
  late final TextEditingController _title = TextEditingController(
    text: _cubit.state.title,
  );
  late final TextEditingController _description = TextEditingController(
    text: _cubit.state.description,
  );

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskFormCubit, TaskFormState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status == TaskFormStatus.saved,
      listener: (context, state) => Navigator.of(context).pop(state.didPersist),
      // Text fields own their controllers; typing needs no rebuild.
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.priority != curr.priority ||
          prev.titleError != curr.titleError ||
          prev.errorMessage != curr.errorMessage,
      builder: (context, state) {
        final saving = state.status == TaskFormStatus.saving;
        return Scaffold(
          appBar: AppBar(title: Text(state.isEdit ? 'Edit task' : 'New task')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _title,
                enabled: !saving,
                autofocus: !state.isEdit,
                textInputAction: TextInputAction.next,
                onChanged: _cubit.titleChanged,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  border: const OutlineInputBorder(),
                  errorText: state.titleError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _description,
                enabled: !saving,
                minLines: 3,
                maxLines: 6,
                onChanged: _cubit.descriptionChanged,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Priority', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<TaskPriority>(
                segments: [
                  for (final p in TaskPriority.values)
                    ButtonSegment(value: p, label: Text(p.label)),
                ],
                selected: {state.priority},
                onSelectionChanged: saving
                    ? null
                    : (s) => _cubit.priorityChanged(s.first),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: saving ? null : _cubit.save,
                icon: saving
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  state.status == TaskFormStatus.failure
                      ? 'Retry save'
                      : 'Save',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
