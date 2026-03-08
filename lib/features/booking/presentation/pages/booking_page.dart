import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_list_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_list_state.dart';
import 'package:jodhere/features/booking/data/models/parking_model.dart';
import 'package:jodhere/features/booking/presentation/widgets/booking_search_bar.dart';
import 'package:jodhere/features/booking/presentation/widgets/booking_parking_list.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String _searchQuery = '';
  List<ParkingResponse> _filteredParkings = [];

  @override
  void initState() {
    super.initState();
    // Load parkings when page initializes
    context.read<ParkingListCubit>().getParkings();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterParkings();
    });
  }

  void _filterParkings() {
    final parkingCubit = context.read<ParkingListCubit>();
    final currentState = parkingCubit.state;

    if (currentState is ParkingListLoaded) {
      if (_searchQuery.isEmpty) {
        _filteredParkings = currentState.parkings;
      } else {
        _filteredParkings = currentState.parkings
            .where((parking) =>
                (parking.name).toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (parking.address).toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (parking.type).toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('จองที่จอดรถ')),
      body: BlocListener<ParkingListCubit, ParkingListState>(
        listener: (context, state) {
          if (state is ParkingListLoaded) {
            _filterParkings();
          }
        },
        child: BlocBuilder<ParkingListCubit, ParkingListState>(
          builder: (context, state) {
            if (state is ParkingListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ParkingListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('เกิดข้อผิดพลาด: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ParkingListCubit>().getParkings();
                      },
                      child: const Text('ลองใหม่อีกครั้ง'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingSearchBar(onSearchChanged: _onSearchChanged),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searchQuery.isEmpty
                            ? 'ที่จอดรถใกล้เคียง'
                            : 'ผลการค้นหา (${_filteredParkings.length})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Display parking locations
                  if (state is ParkingListLoaded)
                    if (_filteredParkings.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('ไม่พบลานจอดรถที่ค้นหา'),
                        ),
                      )
                    else
                      Column(
                        children: _filteredParkings
                            .map(
                              (parking) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: BookingParkingListItem(
                                  parkingId: parking.id,
                                  title: parking.name,
                                  subtitle: parking.address,
                                  availableSlots: parking.availableSlots,
                                ),
                              ),
                            )
                            .toList(),
                      )
                  else
                    const Center(
                      child: Text('กำลังโหลดข้อมูล...'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
