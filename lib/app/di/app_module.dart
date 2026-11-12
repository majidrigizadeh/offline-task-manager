import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/write_failure_config.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/clock.dart';

/// Closes the database when the container is reset/disposed.
FutureOr<void> closeDatabase(AppDatabase db) => db.close();

@module
abstract class AppModule {
  @LazySingleton(dispose: closeDatabase)
  AppDatabase get database => AppDatabase.open();

  @lazySingleton
  WriteFailureConfig get writeFailureConfig => WriteFailureConfig();

  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  Clock get clock => const Clock();
}
