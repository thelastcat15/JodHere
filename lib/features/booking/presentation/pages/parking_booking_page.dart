import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_detail_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_detail_state.dart';
import 'package:jodhere/features/booking/presentation/cubit/slot_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/slot_state.dart';
import 'package:jodhere/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/booking_state.dart';
import 'package:jodhere/features/booking/data/repositories/booking_repository.dart';
import 'package:jodhere/core/api/api_client.dart';
import 'package:jodhere/core/api/api_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ParkingBookingPage extends StatefulWidget {
  final String title;
  final String parkingId;

  const ParkingBookingPage({
    super.key,
    required this.parkingId,
    required this.title,
  });

  @override
  State<ParkingBookingPage> createState() => _ParkingBookingPageState();
}

class _ParkingBookingPageState extends State<ParkingBookingPage> {
  static const String _mockImageUrl = 'https://picsum.photos/seed/jodhere-parking/1200/800';

  String? _selectedZoneId;
  final DateTime _selectedTime = DateTime.now();

  String _resolveImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) {
      return _mockImageUrl;
    }

    final trimmedPath = path.trim();
    if (trimmedPath.startsWith('http://') || trimmedPath.startsWith('https://')) {
      return trimmedPath;
    }

    final base = ApiConfig.baseUrl.replaceFirst('/api/v1', '');
    final normalizedPath = trimmedPath.startsWith('/') ? trimmedPath : '/$trimmedPath';
    return '$base$normalizedPath';
  }

  @override
  void initState() {
    super.initState();
    // Load parking details when page initializes
    context.read<ParkingDetailCubit>().getParkingDetail(widget.parkingId);
  }

  /// Check if user has active booking (PENDING or ARRIVED)
  Future<bool> _hasActiveBooking() async {
    try {
      final apiClient = ApiClient(Supabase.instance.client);
      final repository = BookingRepository(apiClient);
      final bookings = await repository.getBookings();
      
      // Check if bookings is null or empty
      if (bookings.isEmpty) {
        return false;
      }
      
      // Check if there's any active booking
      return bookings.any((booking) => 
        booking.status == 'PENDING' || booking.status == 'ARRIVED'
      );
    } catch (e) {
      // Return false if any error occurs (including null errors)
      debugPrint('Error checking active booking: $e');
      return false;
    }
  }

  /// Show confirmation dialog before creating booking
  Future<void> _showBookingConfirmation(String slotName, String zoneName) async {
    // Show loading dialog while checking
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // First check if user already has active booking
    final hasActive = await _hasActiveBooking();
    
    if (!mounted) return;
    
    // Close loading dialog
    Navigator.of(context).pop();

    if (hasActive) {
      // Show error dialog - cannot book multiple slots
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('ไม่สามารถจองได้'),
            content: const Text('คุณมีการจองที่กำลังดำเนินการอยู่แล้ว\nกรุณายกเลิกการจองเดิมก่อนจองใหม่'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('ยืนยันการจอง'),
          content: Text(
            'คุณต้องการจองที่จอด $slotName\nในโซน $zoneName ใช่หรือไม่?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('ยืนยันการจอง'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      // Double check before creating booking
      final stillHasActive = await _hasActiveBooking();
      
      if (!mounted) return;

      if (stillHasActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('คุณมีการจองที่กำลังดำเนินการอยู่แล้ว'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Proceed with booking
      if (mounted && _selectedZoneId != null) {
        // Find the slot ID from the slot name
        final slotState = context.read<SlotCubit>().state;
        if (slotState is SlotLoaded) {
          final slot = slotState.slots.firstWhere((s) => s.name == slotName);
          context.read<BookingCubit>().createBooking(
            parkingId: widget.parkingId,
            zoneId: _selectedZoneId!,
            slotId: slot.id,
            start: _selectedTime,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลือกที่จอด')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ParkingDetailCubit, ParkingDetailState>(
            listener: (context, state) {
              if (state is ParkingDetailLoaded) {
                // Auto-select first zone and load its slots if not already selected
                if (_selectedZoneId == null && state.parkingDetail.zones.isNotEmpty) {
                  final firstZoneId = state.parkingDetail.zones.first.id;
                  setState(() {
                    _selectedZoneId = firstZoneId;
                  });
                  // Automatically load slots for the first zone
                  context.read<SlotCubit>().getParkingSlots(
                        widget.parkingId,
                        firstZoneId,
                      );
                }
              }
            },
          ),
          BlocListener<BookingCubit, BookingState>(
            listener: (context, state) {
              if (state is BookingCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('การจองสำเร็จ!')),
                );
                // Navigate back to booking page or home
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (state is BookingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('เกิดข้อผิดพลาด: ${state.message}')),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ParkingDetailCubit, ParkingDetailState>(
          builder: (context, state) {
            if (state is ParkingDetailLoading && _selectedZoneId == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ParkingDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('เกิดข้อผิดพลาด: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ParkingDetailCubit>().getParkingDetail(widget.parkingId);
                      },
                      child: const Text('ลองใหม่อีกครั้ง'),
                    ),
                  ],
                ),
              );
            }

            if (state is! ParkingDetailLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final parking = state.parkingDetail;
            final zones = parking.zones;
            final firstImagePath = parking.images.isNotEmpty ? parking.images.first.path : null;
            final imageUrl = _resolveImageUrl(firstImagePath);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          httpHeaders: const {
                            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                          },
                          placeholder: (context, url) => Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.grey[100],
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.deepPurple,
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.deepPurple.shade100,
                                    Colors.deepPurple.shade50,
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_parking,
                                    size: 48,
                                    color: Colors.deepPurple.shade300,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: Colors.deepPurple.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${zones.length} โซน • ${parking.description}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final selectedZone = zones.firstWhere(
                            (zone) => zone.id == _selectedZoneId,
                            orElse: () => zones.first,
                          );
                          return Text(
                            '฿${selectedZone.hourRate.toStringAsFixed(0)}/ชม.',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Zone selection chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: zones
                              .map(
                                (zone) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: Text(zone.name),
                                    selected: _selectedZoneId == zone.id,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedZoneId = zone.id;
                                          // Load slots when zone is selected
                                          context.read<SlotCubit>().getParkingSlots(
                                                widget.parkingId,
                                                zone.id,
                                              );
                                        }
                                      });
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Slots display
                Expanded(
                  child: _selectedZoneId != null
                      ? BlocBuilder<SlotCubit, SlotState>(
                          builder: (context, slotState) {
                          if (slotState is SlotLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (slotState is SlotLoaded) {
                              final slots = slotState.slots;
                              final availableSlots =
                                  slots.where((s) => (s.status) == 'available').toList();

                              if (availableSlots.isEmpty) {
                                return const Center(
                                  child: Text('ไม่มีช่องจอดรถว่าง'),
                                );
                              }

                              return GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                                itemCount: availableSlots.length,
                                itemBuilder: (context, index) {
                                  final slot = availableSlots[index];

                                  return GestureDetector(
                                    onTap: () {
                                      // Get zone name for confirmation dialog
                                      final parkingState = context.read<ParkingDetailCubit>().state;
                                      String zoneName = '';
                                      if (parkingState is ParkingDetailLoaded) {
                                        final zone = parkingState.parkingDetail.zones
                                            .firstWhere((z) => z.id == _selectedZoneId);
                                        zoneName = zone.name;
                                      }
                                      
                                      // Show confirmation dialog
                                      _showBookingConfirmation(slot.name, zoneName);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: slot.status == 'available'
                                            ? Colors.green[50]
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: slot.status == 'available'
                                              ? Colors.green
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          slot.name,
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
                            }

                            if (slotState is SlotError) {
                              return Center(
                                child: Text('เกิดข้อผิดพลาด: ${slotState.message}'),
                              );
                            }

                            return const Center(
                              child: Text('เลือกโซนเพื่อแสดงช่องจอดรถ'),
                            );
                          },
                        )
                      : const Center(
                          child: Text('เลือกโซนเพื่อเริ่มต้น'),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}



