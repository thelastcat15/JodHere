import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/data/repositories/parking_repository.dart';
import 'package:jodhere/features/booking/presentation/cubit/slot_state.dart';

class SlotCubit extends Cubit<SlotState> {
  final ParkingRepository _repository;

  SlotCubit(this._repository) : super(SlotInitial());

  Future<void> getParkingSlots(String parkingId, String zoneId) async {
    try {
      emit(SlotLoading());

      final slots = await _repository.getParkingSlots(parkingId, zoneId);

      emit(SlotLoaded(slots));
    } catch (e) {
      emit(SlotError(e.toString()));
    }
  }
}