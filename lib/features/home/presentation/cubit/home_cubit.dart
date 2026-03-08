import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/data/models/booking_model.dart';
import 'package:jodhere/features/booking/data/repositories/booking_repository.dart';
import 'package:jodhere/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BookingRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  /// Fetch all bookings
  Future<List<BookingResponse>> fetchBookings() async {
    try {
      emit(HomeLoading());
      final bookings = await _repository.getBookings();
      emit(HomeLoaded(bookings));
      return bookings;
    } catch (e) {
      emit(HomeError(e.toString()));
      return [];
    }
  }

  /// Cancel a booking and refresh the list
  Future<void> cancelBooking(String bookingId) async {
    try {
      // Show loading
      emit(HomeLoading());

      // Cancel booking
      await _repository.cancelBooking(bookingId);

      // Refresh bookings
      final bookings = await _repository.getBookings();

      // Emit cancelled state
      emit(HomeBookingCancelled(bookings, bookingId));

      // Then immediately emit loaded state for normal UI
      emit(HomeLoaded(bookings));
    } catch (e) {
      emit(HomeError(e.toString()));
      // Optionally reload bookings on error
      fetchBookings();
    }
  }

  /// Refresh bookings (for pull-to-refresh or when returning from booking)
  Future<void> refreshBookings() async {
    await fetchBookings();
  }
}
