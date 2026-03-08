import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jodhere/core/api/api_client.dart';
import 'package:jodhere/features/booking/data/models/booking_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BookingResponse> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final apiClient = ApiClient(Supabase.instance.client);
      final response = await apiClient.get('/bookings');
      final data = response['data'] as List<dynamic>;
      setState(() {
        bookings = data.map((e) => BookingResponse.fromJson(e as Map<String, dynamic>)).toList();
      });
    } catch (e) {
      // Handle error, perhaps show snackbar
    }
  }
  @override
  Widget build(BuildContext context) {
    final activeBooking = bookings.where((b) => ['PENDING', 'ARRIVED'].contains(b.status)).firstOrNull;
    final historyBookings = bookings.where((b) => ['CANCELLED', 'COMPLETED', 'EXPIRED'].contains(b.status)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParkingStatusCard(activeBooking),
          const SizedBox(height: 24),
          _buildSectionHeader('ประวัติการจอด'),
          if (historyBookings.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'ไม่มีประวัติการจอด',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            )
          else
            ...historyBookings.map((booking) => _buildRecentActivityItemFromBooking(booking)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                color: Colors.deepPurple[600],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParkingStatusCard(BookingResponse? booking) {
    if (booking == null) {
      // No active booking
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurple[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
              Icons.directions_car,
              color: Colors.white70,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'ไม่มีการจองที่ทำอยู่',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ไปจองพื้นที่จอดรถ',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        )
      );
    }

    final duration = booking.bookedTimeEnd.difference(booking.bookedTimeStart).inMinutes / 60.0;
    final cost = booking.hourlyRate * duration;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[700],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'สถานที่จอด',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                booking.parking.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'สถานะ',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    _getStatusLabel(booking.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _buildStatusDetail('เวลาเริ่มจอง', DateFormat('HH:mm').format(booking.bookedTimeStart)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'ค่าจอดปัจจุบัน',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            '฿ ${cost.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple[700],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ดูรายละเอียด',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityItem(
    String title,
    String subtitle,
    String price,
    String duration,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month,
              size: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                duration,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityItemFromBooking(BookingResponse booking) {
    final totalMinutes = booking.bookedTimeEnd.difference(booking.bookedTimeStart).inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    final cost = booking.hourlyRate * (totalMinutes / 60.0);
    final dateStr = DateFormat('dd MMM yyyy').format(booking.bookedTimeStart);
    
    final durationStr = minutes > 0 ? '$hours ชม. $minutes นาที' : '$hours ชม.';

    return _buildRecentActivityItem(
      'จอดรถที่ ${booking.parking.name}',
      dateStr,
      '฿${cost.toStringAsFixed(0)}',
      durationStr,
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'รอดำเนิน';
      case 'ARRIVED':
        return 'เข้าแล้ว';
      case 'COMPLETED':
        return 'เสร็จสิ้น';
      case 'CANCELLED':
        return 'ยกเลิก';
      default:
        return status;
    }
  }
}
