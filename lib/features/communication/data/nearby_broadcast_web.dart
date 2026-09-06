import 'dart:js_interop';

@JS('BroadcastChannel')
extension type _BroadcastChannel._(JSObject _) implements JSObject {
  external factory _BroadcastChannel(String name);
  external void postMessage(JSAny? message);
  external set onmessage(JSFunction? callback);
}

/// Same-origin live updates for the demonstration nearby inbox.
final class NearbyBroadcast {
  static _BroadcastChannel? _channel;
  static final List<void Function()> _listeners = [];

  static void _ensure() {
    if (_channel != null) {
      return;
    }
    _channel = _BroadcastChannel('aarogya-nearby');
    _channel!.onmessage = ((JSAny _) {
      _fanout();
    }).toJS;
  }

  static void listen(void Function() onChange) {
    _ensure();
    _listeners.add(onChange);
  }

  static void unlisten(void Function() onChange) {
    _listeners.remove(onChange);
  }

  static void notify() {
    _ensure();
    _channel?.postMessage('update'.toJS);
    _fanout();
  }

  static void _fanout() {
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}
