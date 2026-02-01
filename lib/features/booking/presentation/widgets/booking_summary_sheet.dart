import 'package:flutter/material.dart';
import 'package:jodhere/features/booking/domain/entities/booking_preview.dart';

class BookingSummarySheet extends StatelessWidget {
  final BookingPreview preview;
  final String zone;
  final String spotNumber;

  const BookingSummarySheet({
    super.key,
    required this.preview,
    required this.zone,
    required this.spotNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Zone $zone / Spot $spotNumber',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _row('ค่าที่จอง', preview.ratePerHour),
          _row('ค่าที่จอด', preview.otherFee),
          const Divider(),
          _row('รวม', preview.total, bold: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยืนยันการจอง'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '฿${value.toStringAsFixed(0)}',
          style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
