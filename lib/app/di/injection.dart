import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Service locator. Only accessed from `main.dart` and `lib/app/router/`.
final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
void configureDependencies() => getIt.init();
