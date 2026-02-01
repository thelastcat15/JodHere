import 'package:jodhere/features/booking/data/datasources/booking_mock_datasource.dart';
import 'package:jodhere/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:jodhere/features/booking/domain/usecases/get_booking_preview.dart';

class BookingDI {
  late final BookingMockDataSource _datasource;
  late final BookingRepositoryImpl _repository;

  late final GetBookingPreview getBookingPreview;

  BookingDI() {
    _datasource = BookingMockDataSource();
    _repository = BookingRepositoryImpl(_datasource);

    getBookingPreview = GetBookingPreview(_repository);
  }
}
