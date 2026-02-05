abstract class BookingException implements Exception {
  final String message;
  BookingException(this.message);

  @override
  String toString() => message;
}

class InvalidParkingIdException extends BookingException {
  InvalidParkingIdException(String message) : super(message);
}

class BookingNotFoundExceptionException extends BookingException {
  BookingNotFoundExceptionException(String message) : super(message);
}

class BookingRepositoryException extends BookingException {
  BookingRepositoryException(String message) : super(message);
}
