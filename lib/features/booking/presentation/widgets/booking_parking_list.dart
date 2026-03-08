import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_detail_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/slot_cubit.dart';
import 'package:jodhere/features/booking/presentation/pages/parking_booking_page.dart';

class BookingParkingListItem extends StatelessWidget {
  final String parkingId;
  final String title;
  final String subtitle;
  final int availableSlots;

  const BookingParkingListItem({
    super.key,
    required this.parkingId,
    required this.title,
    required this.subtitle,
    required this.availableSlots,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_parking, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'ว่าง $availableSlots ที่ • ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<ParkingDetailCubit>(),
                          ),
                          BlocProvider.value(
                            value: context.read<SlotCubit>(),
                          ),
                          BlocProvider.value(
                            value: context.read<BookingCubit>(),
                          ),
                        ],
                        child: ParkingBookingPage(
                          parkingId: parkingId,
                          title: title,
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
