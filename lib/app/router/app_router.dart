import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/config/write_failure_config.dart';
import '../../features/tasks/domain/entities/task_entity.dart';
import '../../features/tasks/domain/usecases/get_task_activities.dart';
import '../../features/tasks/presentation/cubit/task_form_cubit.dart';
import '../../features/tasks/presentation/cubit/task_list_cubit.dart';
import '../../features/tasks/presentation/pages/task_form_page.dart';
import '../../features/tasks/presentation/pages/task_list_page.dart';
import '../di/injection.dart';

/// Composition root for screens: the only place (besides `main.dart`) that
/// reads from the service locator. Cubits are created per route and closed
/// by their BlocProvider.
abstract final class AppRouter {
  static const String taskList = '/';
  static const String taskForm = '/task-form';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskForm:
        final task = settings.arguments as TaskEntity?;
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<TaskFormCubit>(param1: task),
            child: const TaskFormPage(),
          ),
        );
      case taskList:
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<TaskListCubit>()..load(),
            child: TaskListPage(
              getActivities: getIt<GetTaskActivities>(),
              failureConfig: getIt<WriteFailureConfig>(),
            ),
          ),
        );
    }
  }
}
