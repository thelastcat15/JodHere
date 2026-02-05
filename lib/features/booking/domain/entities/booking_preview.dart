import 'package:flutter/foundation.dart';
import 'parking_spot.dart';

@immutable
class BookingPreview {
  final double ratePerHour;
  final double otherFee;
  final List<ParkingSpot> spots;

  const BookingPreview({
    required this.ratePerHour,
    required this.otherFee,
    required this.spots,
  });

  double get total => ratePerHour + otherFee;

  BookingPreview copyWith({
    double? ratePerHour,
    double? otherFee,
    List<ParkingSpot>? spots,
  }) {
    return BookingPreview(
      ratePerHour: ratePerHour ?? this.ratePerHour,
      otherFee: otherFee ?? this.otherFee,
      spots: spots ?? this.spots,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingPreview &&
          runtimeType == other.runtimeType &&
          ratePerHour == other.ratePerHour &&
          otherFee == other.otherFee &&
          spots == other.spots;

  @override
  int get hashCode => ratePerHour.hashCode ^ otherFee.hashCode ^ spots.hashCode;
}
