import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/data/repositories/parking_repository.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_detail_state.dart';

class ParkingDetailCubit extends Cubit<ParkingDetailState> {
  final ParkingRepository _repository;

  ParkingDetailCubit(this._repository) : super(ParkingDetailInitial());

  Future<void> getParkingDetail(String parkingId) async {
    try {
      emit(ParkingDetailLoading());

      final parkingDetail = await _repository.getParkingDetail(parkingId);

      emit(ParkingDetailLoaded(parkingDetail));
    } catch (e) {
      emit(ParkingDetailError(e.toString()));
    }
  }
}