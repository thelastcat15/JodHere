import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/data/repositories/parking_repository.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_list_state.dart';

class ParkingListCubit extends Cubit<ParkingListState> {
  final ParkingRepository _repository;

  ParkingListCubit(this._repository) : super(ParkingListInitial());

  Future<void> getParkings() async {
    try {
      emit(ParkingListLoading());

      final parkings = await _repository.getParkings();

      emit(ParkingListLoaded(parkings));
    } catch (e) {
      emit(ParkingListError(e.toString()));
    }
  }
}