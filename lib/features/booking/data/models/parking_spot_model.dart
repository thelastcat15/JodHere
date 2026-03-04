import 'package:jodhere/features/booking/domain/entities/parking_spot.dart';

class ParkingSpotModel extends ParkingSpot {
  const ParkingSpotModel({
    required super.number,
    required super.available,
    required super.zone,
  });
}
