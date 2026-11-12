// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:uuid/uuid.dart' as _i706;

import '../../core/config/write_failure_config.dart' as _i916;
import '../../core/database/app_database.dart' as _i50;
import '../../core/utils/clock.dart' as _i874;
import '../../features/tasks/data/datasources/task_local_data_source.dart'
    as _i505;
import '../../features/tasks/data/repositories/task_repository_impl.dart'
    as _i20;
import '../../features/tasks/domain/entities/task_entity.dart' as _i1069;
import '../../features/tasks/domain/repositories/task_repository.dart' as _i148;
import '../../features/tasks/domain/usecases/complete_task.dart' as _i45;
import '../../features/tasks/domain/usecases/create_task.dart' as _i602;
import '../../features/tasks/domain/usecases/delete_task.dart' as _i840;
import '../../features/tasks/domain/usecases/get_task_activities.dart' as _i781;
import '../../features/tasks/domain/usecases/get_tasks.dart' as _i517;
import '../../features/tasks/domain/usecases/reopen_task.dart' as _i617;
import '../../features/tasks/domain/usecases/update_task.dart' as _i739;
import '../../features/tasks/presentation/cubit/task_form_cubit.dart' as _i863;
import '../../features/tasks/presentation/cubit/task_list_cubit.dart' as _i127;
import 'app_module.dart' as _i460;
import 'tasks_module.dart' as _i258;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final tasksModule = _$TasksModule();
    gh.lazySingleton<_i50.AppDatabase>(
      () => appModule.database,
      dispose: _i460.closeDatabase,
    );
    gh.lazySingleton<_i916.WriteFailureConfig>(
      () => appModule.writeFailureConfig,
    );
    gh.lazySingleton<_i706.Uuid>(() => appModule.uuid);
    gh.lazySingleton<_i874.Clock>(() => appModule.clock);
    gh.lazySingleton<_i505.TaskLocalDataSource>(
      () => _i505.TaskLocalDataSource(
        gh<_i50.AppDatabase>(),
        gh<_i916.WriteFailureConfig>(),
        gh<_i706.Uuid>(),
        gh<_i874.Clock>(),
      ),
    );
    gh.lazySingleton<_i148.TaskRepository>(
      () => _i20.TaskRepositoryImpl(gh<_i505.TaskLocalDataSource>()),
    );
    gh.lazySingleton<_i517.GetTasks>(
      () => tasksModule.getTasks(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i781.GetTaskActivities>(
      () => tasksModule.getTaskActivities(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i602.CreateTask>(
      () => tasksModule.createTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i739.UpdateTask>(
      () => tasksModule.updateTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i45.CompleteTask>(
      () => tasksModule.completeTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i617.ReopenTask>(
      () => tasksModule.reopenTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i840.DeleteTask>(
      () => tasksModule.deleteTask(gh<_i148.TaskRepository>()),
    );
    gh.factoryParam<_i863.TaskFormCubit, _i1069.TaskEntity?, dynamic>(
      (_initialTask, _) => _i863.TaskFormCubit(
        gh<_i602.CreateTask>(),
        gh<_i739.UpdateTask>(),
        _initialTask,
      ),
    );
    gh.factory<_i127.TaskListCubit>(
      () => _i127.TaskListCubit(
        gh<_i517.GetTasks>(),
        gh<_i45.CompleteTask>(),
        gh<_i617.ReopenTask>(),
        gh<_i840.DeleteTask>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

class _$TasksModule extends _i258.TasksModule {}
