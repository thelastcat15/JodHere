import 'package:jodhere/features/booking/domain/entities/booking_preview.dart';
import 'package:jodhere/features/booking/domain/repositories/booking_repository.dart';
import 'package:jodhere/features/booking/data/datasources/booking_mock_datasource.dart';
import 'package:jodhere/features/booking/domain/value_objects/parking_id.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingMockDataSource datasource;

  BookingRepositoryImpl(this.datasource);

  @override
  Future<BookingPreview> getBookingPreview(ParkingId parkingId) async {
    final model = await datasource.getPreview(parkingId.value);
    return model;
  }
}
