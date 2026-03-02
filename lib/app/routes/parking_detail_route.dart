class ParkingDetailArgs {
  final String parkingId;
  final String title;
  final String rating;
  final String price;

  const ParkingDetailArgs(
    this.parkingId, {
    required this.title,
    required this.rating,
    required this.price,
  });
}
