import 'package:jodhere/features/booking/data/models/booking_model.dart';
import 'package:jodhere/core/api/api_client.dart';

class BookingRepository {
  final ApiClient api;

  BookingRepository(this.api);

  /// Get all user bookings
  Future<List<BookingResponse>> getBookings() async {
    final res = await api.get("/bookings");

    final List data = res["data"];

    return data
        .map((e) => BookingResponse.fromJson(e))
        .toList();
  }

  /// Get booking detail
  Future<BookingResponse> getBooking(String id) async {
    final res = await api.get("/bookings/$id");

    return BookingResponse.fromJson(res["data"]);
  }

  /// Create booking - API only requires booked_time_start
  Future<BookingResponse> createBooking({
    required String parkingId,
    required String zoneId,
    required String slotId,
    required DateTime start,
  }) async {
    final res = await api.post(
      "/bookings",
      body: {
        "parking_id": parkingId,
        "zone_id": zoneId,
        "slot_id": slotId,
        "booked_time_start": start.toIso8601String(),
      },
    );

    return BookingResponse.fromJson(res["data"]);
  }

  /// Cancel booking
  Future<void> cancelBooking(String id) async {
    await api.post("/bookings/$id/cancel");
  }

  /// Check-in booking
  Future<BookingResponse> checkInBooking(String id) async {
    final res = await api.post("/bookings/$id/checkin");

    return BookingResponse.fromJson(res["data"]);
  }

  /// Check-out booking
  Future<BookingResponse> checkOutBooking(String id) async {
    final res = await api.post("/bookings/$id/checkout");

    return BookingResponse.fromJson(res["data"]);
  }
}