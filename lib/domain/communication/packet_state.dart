enum PacketState {
  created,
  stored,
  queued,
  transmitting,
  sent,
  deliveryConfirmed,
  failed,
}

extension PacketStateX on PacketState {
  bool get isDelivered => this == PacketState.deliveryConfirmed;

  bool get canShowTransmitted =>
      this == PacketState.sent || this == PacketState.deliveryConfirmed;
}
