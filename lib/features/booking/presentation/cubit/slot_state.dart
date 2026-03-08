import 'package:equatable/equatable.dart';
import 'package:jodhere/features/booking/data/models/parking_model.dart';

abstract class SlotState extends Equatable {
  const SlotState();

  @override
  List<Object?> get props => [];
}

class SlotInitial extends SlotState {}

class SlotLoading extends SlotState {}

class SlotLoaded extends SlotState {
  final List<ParkingSlotResponse> slots;

  const SlotLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class SlotError extends SlotState {
  final String message;

  const SlotError(this.message);

  @override
  List<Object?> get props => [message];
}