import 'package:jodhere/features/booking/domain/entities/booking_preview.dart';
import 'package:jodhere/features/booking/data/models/parking_spot_model.dart';

class BookingPreviewModel extends BookingPreview {
  BookingPreviewModel({
    required super.ratePerHour,
    required super.otherFee,
    required List<ParkingSpotModel> spots,
  }) : super(spots: spots);

  BookingPreview toEntity() {
    return BookingPreview(
      ratePerHour: ratePerHour,
      otherFee: otherFee,
      spots: spots,
    );
  }
}
