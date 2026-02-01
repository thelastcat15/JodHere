import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text('ค้นหาตำแหน่งที่จอดรถ', style: TextStyle(color: Colors.grey[600]))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                child: Row(children: const [Icon(Icons.my_location, size: 16), SizedBox(width: 8), Text('ใกล้ฉัน')]),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                child: Row(children: const [Icon(Icons.bookmark_border, size: 16), SizedBox(width: 8), Text('บันทึกไว้')]),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Text('เลือกวันและเวลา', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateTimeColumn('วันที่เข้า', '15 ม.ค. 2025', '09:00'),
              _buildDateTimeColumn('วันที่ออก', '15 ม.ค. 2025', '18:00'),
            ],
          ),
          const SizedBox(height: 8),
          Text('ระยะเวลาจอด: 9 ชั่วโมง', style: TextStyle(color: Colors.grey[600])),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ที่จอดรถใกล้เคียง', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(children: const [Icon(Icons.filter_list, size: 18), SizedBox(width: 6), Text('ตัวกรอง')]),
            ],
          ),
          const SizedBox(height: 12),

          // List of parking options
          Column(
            children: List.generate(6, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildBookingListItem(context, 'ลานจอดรถ เซ็นทรัลเวิลด์', 'ระยะทาง 0.$i กม.', '4.5', '฿45/ชม.'),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeColumn(String label, String date, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        const SizedBox(height: 8),
        Row(children: [const Icon(Icons.calendar_today, size: 18), const SizedBox(width: 8), Text(date, style: const TextStyle(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        Row(children: [const Icon(Icons.access_time, size: 18), const SizedBox(width: 8), Text(time, style: const TextStyle(fontWeight: FontWeight.bold))]),
      ],
    );
  }

  Widget _buildBookingListItem(BuildContext context, String title, String subtitle, String rating, String price) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.local_parking, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [Icon(Icons.star, size: 14, color: Colors.orange), const SizedBox(width: 6), Text('$rating • $subtitle', style: TextStyle(color: Colors.grey[600], fontSize: 12))]),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('เลือก'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}