import 'package:flutter/foundation.dart';

@immutable
class ParkingSpot {
  final String number;
  final bool available;
  final String zone;

  const ParkingSpot({
    required this.number,
    required this.available,
    required this.zone,
  });

  ParkingSpot copyWith({String? number, bool? available, String? zone}) {
    return ParkingSpot(
      number: number ?? this.number,
      available: available ?? this.available,
      zone: zone ?? this.zone,
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
