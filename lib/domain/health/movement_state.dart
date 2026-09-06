enum MovementState { none, low, normal, high, irregular }

extension MovementStateX on MovementState {
  bool get isResting => this == MovementState.none || this == MovementState.low;

  static MovementState? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return MovementState.values.asNameMap()[raw];
  }
}
