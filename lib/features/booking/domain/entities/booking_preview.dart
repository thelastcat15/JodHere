import 'parking_spot.dart';

class BookingPreview {
  final double ratePerHour;
  final double otherFee;
  final List<ParkingSpot> spots;

  BookingPreview({
    required this.ratePerHour,
    required this.otherFee,
    required this.spots,
  });

  double get total => ratePerHour + otherFee;
}
