import '../error/exceptions.dart';

/// Single source of truth for write-failure simulation.
///
/// The initial value comes from `--dart-define=FAIL_WRITES=true`. It can be
/// flipped at runtime (debug switch in the app bar) so that "Retry" can be
/// demonstrated after a simulated failure.
///
/// The persistence layer calls [throwIfEnabled] **inside** a transaction,
/// right after the first write, so a failure always exercises a rollback.
class WriteFailureConfig {
  WriteFailureConfig({this.enabled = enabledAtLaunch});

  /// Compile-time flag. The only place `FAIL_WRITES` is read.
  static const bool enabledAtLaunch = bool.fromEnvironment('FAIL_WRITES');

  bool enabled;

  void throwIfEnabled(String operation) {
    if (enabled) throw SimulatedWriteFailure(operation);
  }
}
