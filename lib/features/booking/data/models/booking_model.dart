class BookingResponse {
  final String id;
  final String status;

  final DateTime bookedTimeStart;
  final DateTime bookedTimeEnd;

  final double hourlyRate;
  final double? durationHours;
  final double? totalCost;

  final ParkingInfo parking;
  final ZoneInfo zone;
  final SlotInfo slot;

  BookingResponse({
    required this.id,
    required this.status,
    required this.bookedTimeStart,
    required this.bookedTimeEnd,
    required this.hourlyRate,
    this.durationHours,
    this.totalCost,
    required this.parking,
    required this.zone,
    required this.slot,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'],
      status: json['status'],
      bookedTimeStart: DateTime.parse(json['booked_time_start']),
      bookedTimeEnd: DateTime.parse(json['booked_time_end']),
      hourlyRate: (json['zone']['hour_rate'] as num).toDouble(),
      durationHours: json['duration_hours'] != null
          ? (json['duration_hours'] as num).toDouble()
          : null,
      totalCost: json['total_cost'] != null
          ? (json['total_cost'] as num).toDouble()
          : null,
      parking: ParkingInfo.fromJson(json['parking']),
      zone: ZoneInfo.fromJson(json['zone']),
      slot: SlotInfo.fromJson(json['slot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "booked_time_start": bookedTimeStart.toIso8601String(),
      "booked_time_end": bookedTimeEnd.toIso8601String(),
      "hourly_rate": hourlyRate,
      "duration_hours": durationHours,
      "total_cost": totalCost,
      "parking": parking.toJson(),
      "zone": zone.toJson(),
      "slot": slot.toJson(),
    };
  }
}

class ParkingInfo {
  final String id;
  final String name;

  ParkingInfo({
    required this.id,
    required this.name,
  });

  factory ParkingInfo.fromJson(Map<String, dynamic> json) {
    return ParkingInfo(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

class ZoneInfo {
  final String id;
  final String name;
  final double hourRate;

  ZoneInfo({
    required this.id,
    required this.name,
    required this.hourRate,
  });

  factory ZoneInfo.fromJson(Map<String, dynamic> json) {
    return ZoneInfo(
      id: json['id'],
      name: json['name'],
      hourRate: (json['hour_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "hour_rate": hourRate,
    };
  }
}

class SlotInfo {
  final String id;
  final String name;
  final double hourRate;

  SlotInfo({
    required this.id,
    required this.name,
    required this.hourRate,
  });

  factory SlotInfo.fromJson(Map<String, dynamic> json) {
    return SlotInfo(
      id: json['id'],
      name: json['name'],
      hourRate: (json['hour_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "hour_rate": hourRate,
    };
  }
}