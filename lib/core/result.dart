sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T get requireValue => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>(:final error) => throw StateError('Result failed: $error'),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final Object error;
}
