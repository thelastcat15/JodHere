import 'package:jodhere/features/booking/data/models/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingResponse> bookings;

  BookingLoaded(this.bookings);
}

class BookingDetailLoaded extends BookingState {
  final BookingResponse booking;

  BookingDetailLoaded(this.booking);
}

class BookingCreated extends BookingState {
  final BookingResponse booking;

  BookingCreated(this.booking);
}

class BookingCancelled extends BookingState {
  final String bookingId;

  BookingCancelled(this.bookingId);
}

class BookingCheckedIn extends BookingState {
  final BookingResponse booking;

  BookingCheckedIn(this.booking);
}

class BookingCheckedOut extends BookingState {
  final BookingResponse booking;

  BookingCheckedOut(this.booking);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}