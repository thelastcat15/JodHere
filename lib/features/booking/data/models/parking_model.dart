class ParkingResponse {
  final String id;
  final String name;
  final String type;
  final String contact;
  final String address;
  final String description;
  final double coordinateX;
  final double coordinateY;
  final int availableSlots;

  ParkingResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.contact,
    required this.address,
    required this.description,
    required this.coordinateX,
    required this.coordinateY,
    required this.availableSlots,
  });

  factory ParkingResponse.fromJson(Map<String, dynamic> json) {
    return ParkingResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      contact: json['contact'],
      address: json['address'],
      description: json['description'],
      coordinateX: (json['coordinate_x'] as num).toDouble(),
      coordinateY: (json['coordinate_y'] as num).toDouble(),
      availableSlots: json['available_slots'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'contact': contact,
      'address': address,
      'description': description,
      'coordinate_x': coordinateX,
      'coordinate_y': coordinateY,
      'available_slots': availableSlots,
    };
  }
}

class ParkingDetailResponse {
  final String id;
  final String name;
  final String type;
  final String contact;
  final String address;
  final String description;
  final double coordinateX;
  final double coordinateY;
  final List<PlaceImage> images;
  final List<ZoneResponse> zones;

  ParkingDetailResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.contact,
    required this.address,
    required this.description,
    required this.coordinateX,
    required this.coordinateY,
    required this.images,
    required this.zones,
  });

  factory ParkingDetailResponse.fromJson(Map<String, dynamic> json) {
    return ParkingDetailResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      contact: json['contact'],
      address: json['address'],
      description: json['description'],
      coordinateX: (json['coordinate_x'] as num).toDouble(),
      coordinateY: (json['coordinate_y'] as num).toDouble(),
      images: (json['images'] as List)
          .map((e) => PlaceImage.fromJson(e))
          .toList(),
      zones: (json['zones'] as List)
          .map((e) => ZoneResponse.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'contact': contact,
      'address': address,
      'description': description,
      'coordinate_x': coordinateX,
      'coordinate_y': coordinateY,
      'images': images.map((e) => e.toJson()).toList(),
      'zones': zones.map((e) => e.toJson()).toList(),
    };
  }
}

class PlaceImage {
  final String id;
  final String parkingId;
  final String path;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlaceImage({
    required this.id,
    required this.parkingId,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlaceImage.fromJson(Map<String, dynamic> json) {
    return PlaceImage(
      id: json['id'],
      parkingId: json['parking_id'],
      path: json['path'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parking_id': parkingId,
      'path': path,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ZoneResponse {
  final String id;
  final String name;
  final double hourRate;

  ZoneResponse({
    required this.id,
    required this.name,
    required this.hourRate,
  });

  factory ZoneResponse.fromJson(Map<String, dynamic> json) {
    return ZoneResponse(
      id: json['id'],
      name: json['name'],
      hourRate: (json['hour_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hour_rate': hourRate,
    };
  }
}

class ParkingSlotResponse {
  final String id;
  final String name;
  final String status;
  final String zoneId;

  ParkingSlotResponse({
    required this.id,
    required this.name,
    required this.status,
    required this.zoneId,
  });

  factory ParkingSlotResponse.fromJson(Map<String, dynamic> json) {
    return ParkingSlotResponse(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      zoneId: json['zone_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'zone_id': zoneId,
    };
  }
}