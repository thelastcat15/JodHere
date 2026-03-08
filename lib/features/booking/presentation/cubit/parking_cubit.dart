import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/data/repositories/parking_repository.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_state.dart';

class ParkingCubit extends Cubit<ParkingState> {
  final ParkingRepository _repository;

  ParkingCubit(this._repository) : super(ParkingInitial());

  Future<void> getParkings() async {
    try {
      emit(ParkingLoading());

      final parkings = await _repository.getParkings();

      emit(ParkingLoaded(parkings));
    } catch (e) {
      emit(ParkingError(e.toString()));
    }
  }

  Future<void> getParkingDetail(String id) async {
    try {
      emit(ParkingLoading());

      final parking = await _repository.getParkingDetail(id);

      emit(ParkingDetailLoaded(parking));
    } catch (e) {
      emit(ParkingError(e.toString()));
    }
  }

  Future<void> getParkingSlots(String parkingId, String zoneId) async {
    try {
      emit(ParkingSlotsLoading());

      final slots = await _repository.getParkingSlots(parkingId, zoneId);

      emit(ParkingSlotsLoaded(slots));
    } catch (e) {
      emit(ParkingError(e.toString()));
    }
  }
}
