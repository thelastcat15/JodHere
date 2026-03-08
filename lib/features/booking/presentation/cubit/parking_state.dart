import 'package:jodhere/features/booking/data/models/parking_model.dart';

abstract class ParkingState {}

class ParkingInitial extends ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingLoaded extends ParkingState {
  final List<ParkingResponse> parkings;

  ParkingLoaded(this.parkings);
}

class ParkingDetailLoaded extends ParkingState {
  final ParkingDetailResponse parking;

  ParkingDetailLoaded(this.parking);
}

class ParkingSlotsLoading extends ParkingState {}

class ParkingSlotsLoaded extends ParkingState {
  final List<ParkingSlotResponse> slots;

  ParkingSlotsLoaded(this.slots);
}

class ParkingError extends ParkingState {
  final String message;

  ParkingError(this.message);
}