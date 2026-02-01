import 'package:jodhere/features/booking/domain/entities/booking_preview.dart';
import 'package:jodhere/features/booking/domain/value_objects/parking_id.dart';

abstract class BookingRepository {
  Future<BookingPreview> getBookingPreview(ParkingId parkingId);
}
