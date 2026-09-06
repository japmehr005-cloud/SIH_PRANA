export 'platform_dependencies_stub.dart'
    if (dart.library.io) 'platform_dependencies_io.dart'
    if (dart.library.js_interop) 'platform_dependencies_web.dart'
    if (dart.library.html) 'platform_dependencies_web.dart';
