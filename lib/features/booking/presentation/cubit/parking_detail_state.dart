import 'package:equatable/equatable.dart';
import 'package:jodhere/features/booking/data/models/parking_model.dart';

abstract class ParkingDetailState extends Equatable {
  const ParkingDetailState();

  @override
  List<Object?> get props => [];
}

class ParkingDetailInitial extends ParkingDetailState {}

class ParkingDetailLoading extends ParkingDetailState {}

class ParkingDetailLoaded extends ParkingDetailState {
  final ParkingDetailResponse parkingDetail;

  const ParkingDetailLoaded(this.parkingDetail);

  @override
  List<Object?> get props => [parkingDetail];
}

class ParkingDetailError extends ParkingDetailState {
  final String message;

  const ParkingDetailError(this.message);

  @override
  List<Object?> get props => [message];
}