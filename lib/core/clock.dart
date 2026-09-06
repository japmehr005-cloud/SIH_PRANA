abstract interface class Clock {
  DateTime now();
}

final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}

final class ControllableClock implements Clock {
  ControllableClock([DateTime? initial])
    : _now = initial ?? DateTime.utc(2026, 9, 6, 8);

  DateTime _now;

  @override
  DateTime now() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }

  void setNow(DateTime value) {
    _now = value.toUtc();
  }
}
