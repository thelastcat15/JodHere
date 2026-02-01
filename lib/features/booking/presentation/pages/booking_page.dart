import 'package:flutter/material.dart';
import 'package:jodhere/features/booking/presentation/widgets/booking_search_bar.dart';
import 'package:jodhere/features/booking/presentation/widgets/booking_filter_row.dart';
import 'package:jodhere/features/booking/presentation/widgets/booking_datetime_section.dart';
import 'package:jodhere/features/booking/presentation/widgets/booking_parking_list.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookingSearchBar(),
          const SizedBox(height: 12),
          const BookingFilterRow(),

          const SizedBox(height: 20),
          const BookingDateTimeSection(),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ที่จอดรถใกล้เคียง',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: const [
                  Icon(Icons.filter_list, size: 18),
                  SizedBox(width: 6),
                  Text('ตัวกรอง'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Column(
            children: List.generate(
              6,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BookingParkingListItem(
                  title: 'ลานจอดรถ เซ็นทรัลเวิลด์',
                  subtitle: 'ระยะทาง 0.$i กม.',
                  rating: '4.5',
                  price: '฿45/ชม.',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
