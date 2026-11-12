import 'package:testniksam/core/utils/clock.dart';

/// Deterministic clock: every call advances by 1 ms.
class FakeClock implements Clock {
  FakeClock([DateTime? start]) : _now = start ?? DateTime.utc(2026, 1, 1, 9);

  DateTime _now;

  @override
  DateTime now() => _now = _now.add(const Duration(milliseconds: 1));
}
