import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/write_failure_config.dart';
import '../../core/utils/clock.dart';

@module
abstract class AppModule {
  @lazySingleton
  WriteFailureConfig get writeFailureConfig => WriteFailureConfig();

  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  Clock get clock => const Clock();
}
