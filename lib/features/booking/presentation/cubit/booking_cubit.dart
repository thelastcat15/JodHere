import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/data/repositories/booking_repository.dart';
import 'package:jodhere/features/booking/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;
  
  BookingCubit(this._repository) : super(BookingInitial());


  Future<void> getBookings() async {
    try {
      emit(BookingLoading());

      final bookings = await _repository.getBookings();

      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> getBookingDetail(String id) async {
    try {
      emit(BookingLoading());

      final booking = await _repository.getBooking(id);

      emit(BookingDetailLoaded(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> createBooking({
    required String parkingId,
    required String zoneId,
    required String slotId,
    required DateTime start,
  }) async {
    try {
      emit(BookingLoading());

      final booking = await _repository.createBooking(
        parkingId: parkingId,
        zoneId: zoneId,
        slotId: slotId,
        start: start,
      );

      emit(BookingCreated(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      emit(BookingLoading());

      await _repository.cancelBooking(id);

      emit(BookingCancelled(id));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> checkInBooking(String id) async {
    try {
      emit(BookingLoading());

      final booking = await _repository.checkInBooking(id);

      emit(BookingCheckedIn(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> checkOutBooking(String id) async {
    try {
      emit(BookingLoading());

      final booking = await _repository.checkOutBooking(id);

      emit(BookingCheckedOut(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}