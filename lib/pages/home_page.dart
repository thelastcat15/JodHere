import 'package:flutter/material.dart';
import 'booking_page.dart';
import '../widgets/app_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeContent(),
      const BookingPage(),
      // placeholders for other tabs
      Center(child: Text('แผนที่', style: Theme.of(context).textTheme.titleLarge)),
      Center(child: Text('แต้ม', style: Theme.of(context).textTheme.titleLarge)),
      Center(child: Text('โปรไฟล์', style: Theme.of(context).textTheme.titleLarge)),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_parking, color: Colors.deepPurple, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'ParkEasy',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: AppNavBar(
        currentIndex: _selectedIndex,
        onTap: (i) {
          if (i == 0 || i == 1) {
            setState(() => _selectedIndex = i);
            return;
          }

          // Map other tabs to named routes
          final routeNames = {
            2: '/map',
            3: '/points',
            4: '/profile',
          };

          final route = routeNames[i];
          if (route != null) Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  Widget _homeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPointsCard(),
          const SizedBox(height: 16),
          _buildActionButtons(),
          const SizedBox(height: 24),
          _buildSectionHeader('รถของฉัน', trailing: '+ เพิ่มรถ'),
          _buildCarCard(),
          const SizedBox(height: 16),
          _buildParkingStatusCard(),
          const SizedBox(height: 24),
          _buildSectionHeader('ลานจอดใกล้เคียง', trailing: 'ดูทั้งหมด'),
          _buildNearbyParkingCard('ลานจอดรถ Central World', 'ราชปรารภ, ปทุมวัน', '1.2 กม.', '฿ 40/ชม.', '24 ชม.', 4.5),
          const SizedBox(height: 16),
          _buildNearbyParkingCard('ลานจอดรถ Siam Paragon', 'พระราม 1, ปทุมวัน', '0.8 กม.', '฿ 50/ชม.', '10:00-22:00', 4.8),
          const SizedBox(height: 24),
          _buildSectionHeader('กิจกรรมล่าสุด'),
          _buildRecentActivityItem('จอดรถที่ Central World', 'วันนี้ 14:30 • +50 แต้ม', '฿120', '3 ชม.'),
          _buildRecentActivityItem('จอดที่จอด Siam Paragon', '23 ธ.ค. 2025 • +25 แต้ม', '฿200', '5 ชม.'),
          _buildRecentActivityItem('จอดรถที่ MBK Center', '22 ธ.ค. 2025 • +30 แต้ม', '฿80', '2 ชม.'),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF341F8C), Color(0xFF85409D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('คะแนนสะสม', style: TextStyle(color: Colors.white70, fontSize: 13)),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star, color: Colors.yellow, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text('2,450', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Text('แต้ม', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.arrow_upward, color: Colors.white70, size: 14),
              SizedBox(width: 4),
              Text('+50 แต้มจากการจอดล่าสุด', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(Icons.calendar_today, 'รายการทั้งหมด'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(Icons.camera_alt_outlined, 'แถดรถสดชัดที่'),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (trailing != null)
            Text(trailing, style: TextStyle(color: Colors.deepPurple[600], fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 24,
            child: const Icon(Icons.directions_car_filled, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('กย 1234 กรุงเทพ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Toyota Camry - ขาว', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  Widget _buildParkingStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[700],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('สถานะปลดล็อค', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const Text('กำลังจอดรถ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('ใช้งานอยู่', style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusDetail('ทะเบียนรถ', 'กย 1234 สกม'),
              _buildStatusDetail('เวลาเข้า', '09:30 น.'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('ค่าจอดปัจจุบัน', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const Text('฿ 40', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('ดูรายละเอียด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildNearbyParkingCard(String name, String location, String distance, String price, String hours, double rating) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 140,
              width: double.infinity,
              color: Colors.grey[200],
              child: Stack(
                children: [
                  // Placeholder for Map
                  Center(child: Icon(Icons.map, size: 50, color: Colors.grey[400])),
                  Positioned(
                    top: 50,
                    left: 150,
                    child: Icon(Icons.location_on, color: Colors.deepPurple[800], size: 30),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(rating.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                Text(location, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoItem(Icons.location_on_outlined, distance),
                    const SizedBox(width: 16),
                    _buildInfoItem(Icons.payments_outlined, price),
                    const SizedBox(width: 16),
                    _buildInfoItem(Icons.access_time, hours),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[800],
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('นำทาง', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bookmark_border, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentActivityItem(String title, String subtitle, String price, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_month, size: 18, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(duration, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
