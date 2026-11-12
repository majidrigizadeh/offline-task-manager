/// Injectable time source so tests can control timestamps.
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}
