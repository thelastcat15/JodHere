import 'package:equatable/equatable.dart';
import 'package:jodhere/features/booking/data/models/parking_model.dart';

abstract class ParkingListState extends Equatable {
  const ParkingListState();

  @override
  List<Object?> get props => [];
}

class ParkingListInitial extends ParkingListState {}

class ParkingListLoading extends ParkingListState {}

class ParkingListLoaded extends ParkingListState {
  final List<ParkingResponse> parkings;

  const ParkingListLoaded(this.parkings);

  @override
  List<Object?> get props => [parkings];
}

class ParkingListError extends ParkingListState {
  final String message;

  const ParkingListError(this.message);

  @override
  List<Object?> get props => [message];
}