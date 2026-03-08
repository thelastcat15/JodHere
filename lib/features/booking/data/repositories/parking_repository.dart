import 'package:jodhere/features/booking/data/models/parking_model.dart';
import 'package:jodhere/core/api/api_client.dart';

class ParkingRepository {
  final ApiClient api;

  ParkingRepository(this.api);

  /// Get all parkings - endpoint is /api/v1/parking (not /parkings)
  Future<List<ParkingResponse>> getParkings() async {
    final res = await api.get("/parking");

    final List data = res["data"];

    return data
        .map((e) => ParkingResponse.fromJson(e))
        .toList();
  }

  /// Get parking detail by ID
  Future<ParkingDetailResponse> getParkingDetail(String id) async {
    final res = await api.get("/parking/$id");

    return ParkingDetailResponse.fromJson(res["data"]);
  }

  /// Get parking slots for a specific zone
  Future<List<ParkingSlotResponse>> getParkingSlots(
    String parkingId,
    String zoneId,
  ) async {
    final res = await api.get("/parking/$parkingId/zones/$zoneId/slots");

    final List data = res["data"];

    return data
        .map((e) => ParkingSlotResponse.fromJson(e))
        .toList();
  }

  Future<String> deleteParking(
    String parkingId,
    String zoneId,
  ) async {
    final res = await api.delete("/parking/$parkingId");

    return res["message"];
  }
}