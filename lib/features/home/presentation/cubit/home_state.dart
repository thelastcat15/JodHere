import 'package:jodhere/features/booking/data/models/booking_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<BookingResponse> bookings;

  HomeLoaded(this.bookings);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeBookingCancelled extends HomeState {
  final List<BookingResponse> bookings;
  final String cancelledBookingId;

  HomeBookingCancelled(this.bookings, this.cancelledBookingId);
}
