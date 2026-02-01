import 'package:flutter/material.dart';

class BookingFilterRow extends StatelessWidget {
  const BookingFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.my_location, size: 16),
              SizedBox(width: 8),
              Text('ใกล้ฉัน'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.bookmark_border, size: 16),
              SizedBox(width: 8),
              Text('บันทึกไว้'),
            ],
          ),
        ),
      ],
    );
  }
}
