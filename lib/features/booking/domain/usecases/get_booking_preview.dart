import 'package:jodhere/features/booking/domain/entities/booking_preview.dart';
import 'package:jodhere/features/booking/domain/repositories/booking_repository.dart';
import 'package:jodhere/features/booking/domain/value_objects/parking_id.dart';

class GetBookingPreview {
  final BookingRepository repository;

  GetBookingPreview(this.repository);

  Future<BookingPreview> call(ParkingId parkingId) {
    return repository.getBookingPreview(parkingId);
  }
}
