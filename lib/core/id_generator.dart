import 'package:uuid/uuid.dart';

abstract interface class IdGenerator {
  String next();
}

final class UuidGenerator implements IdGenerator {
  const UuidGenerator();

  static const Uuid _uuid = Uuid();

  @override
  String next() => _uuid.v4();
}

final class SequentialIdGenerator implements IdGenerator {
  SequentialIdGenerator({this.prefix = 'evt'});

  final String prefix;
  int _counter = 0;

  @override
  String next() {
    _counter += 1;
    return '$prefix-$_counter';
  }
}
