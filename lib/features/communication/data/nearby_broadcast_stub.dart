final class NearbyBroadcast {
  static final List<void Function()> _listeners = [];

  static void listen(void Function() onChange) {
    _listeners.add(onChange);
  }

  static void unlisten(void Function() onChange) {
    _listeners.remove(onChange);
  }

  static void notify() {
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}
