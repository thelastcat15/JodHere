class ParkingId {
  final String value;
  
  const ParkingId(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkingId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ParkingId($value)';
}