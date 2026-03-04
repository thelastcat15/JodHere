import 'package:jodhere/features/booking/data/models/booking_preview_model.dart';
import 'package:jodhere/features/booking/data/models/parking_spot_model.dart';

class BookingMockDataSource {
  Future<BookingPreviewModel> getPreview(String parkingId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return BookingPreviewModel(
      ratePerHour: 100,
      otherFee: 405,
      spots: [
        ParkingSpotModel(number: '123', available: true, zone: 'A'),
        ParkingSpotModel(number: '124', available: false, zone: 'B'),
        ParkingSpotModel(number: '125', available: true, zone: 'B'),
        ParkingSpotModel(number: '126', available: true, zone: 'C'),
      ],
    );
  }
}
