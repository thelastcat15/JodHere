import 'package:flutter/foundation.dart';

@immutable
class ParkingSpot {
  final String number;
  final bool available;

  const ParkingSpot({
    required this.number,
    required this.available,
  });

  ParkingSpot copyWith({
    String? number,
    bool? available,
  }) {
    return ParkingSpot(
      number: number ?? this.number,
      available: available ?? this.available,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkingSpot &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          available == other.available;

  @override
  int get hashCode => number.hashCode ^ available.hashCode;
}
