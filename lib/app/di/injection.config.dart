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
import '../../features/tasks/domain/repositories/task_repository.dart' as _i148;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
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
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
