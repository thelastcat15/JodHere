import 'package:flutter/material.dart';
import 'package:jodhere/features/booking/data/datasources/booking_mock_datasource.dart';
import 'package:jodhere/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:jodhere/features/booking/domain/entities/booking_preview.dart';
import 'package:jodhere/features/booking/domain/usecases/get_booking_preview.dart';
import 'package:jodhere/features/booking/presentation/widgets/booking_summary_sheet.dart';

class ParkingBookingPage extends StatefulWidget {
  final String parkingId;

  const ParkingBookingPage({
    super.key,
    required this.parkingId,
  });

  @override
  State<ParkingBookingPage> createState() => _ParkingBookingPageState();
}

class _ParkingBookingPageState extends State<ParkingBookingPage> {
  late final GetBookingPreview _getPreview;
  final String _selectedZone = 'A';

  @override
  void initState() {
    super.initState();
    _getPreview = GetBookingPreview(
      BookingRepositoryImpl(BookingMockDataSource()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกที่จอด')),
      body: FutureBuilder<BookingPreview>(
        future: _getPreview(widget.parkingId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final preview = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: preview.spots.length,
            itemBuilder: (context, index) {
              final spot = preview.spots[index];

              return GestureDetector(
                onTap: spot.available
                    ? () => _openSummary(preview, spot.number)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: spot.available ? Colors.white : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      spot.number,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openSummary(BookingPreview preview, String spotNumber) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BookingSummarySheet(
        preview: preview,
        zone: _selectedZone,
        spotNumber: spotNumber,
      ),
    );
  }
}



// class ParkingBookingPage extends StatefulWidget {
//   final String parkingId;

//   const ParkingBookingPage({super.key, required this.parkingId});

//   @override
//   State<ParkingBookingPage> createState() => _ParkingBookingPageState();
// }

// class _ParkingBookingPageState extends State<ParkingBookingPage> {
//   String _selectedZone = 'A';
  
//   // Booking details (mock data)
//   final String _checkInDate = '15/03/25';
//   final String _checkOutDate = '15/03/25';
//   final String _checkInTime = '9:00';
//   final String _checkOutTime = '18:00';
//   final double _ratePerHour = 100.0;
//   final double _otherFee = 405.0;

//   // Mock parking spots data
//   final List<Map<String, dynamic>> _parkingSpots = [
//     {'number': '123', 'available': true},
//     {'number': '124', 'available': false},
//     {'number': '134', 'available': true},
//     {'number': '135', 'available': true},
//     {'number': '126', 'available': true},
//     {'number': '127', 'available': true},
//     {'number': '128', 'available': false},
//     {'number': '129', 'available': true},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple[800],
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'ParkEasy',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Parking Lot Image Placeholder
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
//               child: Container(
//                 height: 200,
//                 width: double.infinity,
//                 color: Colors.grey[200],
//                 child: Stack(
//                   children: [
//                     Center(child: Icon(Icons.location_city, size: 80, color: Colors.grey[400])),
//                     Positioned(
//                       top: 80,
//                       left: 150,
//                       child: Icon(Icons.location_on, color: Colors.deepPurple[800], size: 40),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Parking Lot Info
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.name,
//                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               widget.location,
//                               style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.yellow[100],
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.star, color: Colors.orange, size: 16),
//                             const SizedBox(width: 4),
//                             Text(widget.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Text(widget.distance, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//                       const SizedBox(width: 16),
//                       Icon(Icons.payments_outlined, size: 16, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Text(widget.price, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Zone Selection
//                   const Text('เลือกโซน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                   const SizedBox(height: 12),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: ['A', 'B', 'C', 'D']
//                           .map((zone) => Padding(
//                                 padding: const EdgeInsets.only(right: 12.0),
//                                 child: GestureDetector(
//                                   onTap: () => setState(() => _selectedZone = zone),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                     decoration: BoxDecoration(
//                                       color: _selectedZone == zone ? Colors.deepPurple : Colors.white,
//                                       borderRadius: BorderRadius.circular(20),
//                                       border: Border.all(
//                                         color: _selectedZone == zone ? Colors.deepPurple : Colors.grey[300]!,
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'zone $zone',
//                                       style: TextStyle(
//                                         color: _selectedZone == zone ? Colors.white : Colors.black87,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ))
//                           .toList(),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Parking Spots Grid
//                   const Text('เลือกพื้นที่จอด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                   const SizedBox(height: 12),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 12,
//                       childAspectRatio: 1.0,
//                     ),
//                     itemCount: _parkingSpots.length,
//                     itemBuilder: (context, index) {
//                       final spot = _parkingSpots[index];
//                       final isAvailable = spot['available'];

//                       return GestureDetector(
//                         onTap: isAvailable
//                             ? () {
//                                 _showBookingOverlay(spot['number']);
//                               }
//                             : null,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Colors.grey[300]!,
//                               width: 1,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0x0D000000),
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 0),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.directions_car_filled,
//                                   size: 40,
//                                   color: isAvailable ? Colors.black54 : Colors.grey[400],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   spot['number'],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     color: isAvailable ? Colors.black87 : Colors.grey[400],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   isAvailable ? 'Available' : 'Occupied',
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     color: isAvailable ? Colors.grey[600] : Colors.grey[400],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showBookingOverlay(String spotNumber) async {
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         final totalCost = _ratePerHour + _otherFee;
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'สถานที่: ${widget.name}',
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
//                             const SizedBox(width: 8),
//                             Text(_checkInDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x40000000),
//                                   blurRadius: 4,
//                                   offset: Offset(0, 0),
//                                 ),
//                               ],
//                             ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.access_time, size: 20, color: Colors.black54),
//                               const SizedBox(width: 8),
//                               Text(_checkInTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
//                             const SizedBox(width: 8),
//                             Text(_checkOutDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x40000000),
//                                   blurRadius: 4,
//                                   offset: Offset(0, 0),
//                                 ),
//                               ],
//                             ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.access_time, size: 20, color: Colors.black54),
//                               const SizedBox(width: 8),
//                               Text(_checkOutTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('อาคาร', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0x40000000),
//                                 blurRadius: 4,
//                                 offset: Offset(0, 0),
//                               ),
//                             ],
//                           ),
//                           child: Text('Zone $_selectedZone', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('ที่จอด', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0x40000000),
//                                 blurRadius: 4,
//                                 offset: Offset(0, 0),
//                               ),
//                             ],
//                           ),
//                           child: Text(spotNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                   Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0x40000000),
//                         blurRadius: 4,
//                         offset: Offset(0, 0),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('ค่าที่จอง :', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
//                           Text('฿ ${_ratePerHour.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('ค่าที่จอด :', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
//                           Text('฿ ${_otherFee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                         ],
//                       ),
//                       const Divider(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('ยอดรวมสุทธิ :', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 14)),
//                           Text('฿ ${totalCost.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('จองที่จอด $spotNumber ในโซน $_selectedZone สำเร็จ'),
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple[800],
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: const Text('จอง', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Center(
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey, fontSize: 14)),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }