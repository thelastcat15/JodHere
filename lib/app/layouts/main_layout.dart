import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/home/presentation/pages/home_page.dart';
import 'package:jodhere/features/booking/presentation/pages/booking_page.dart';
import 'package:jodhere/features/profile/presentation/pages/profile_page.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_list_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/parking_detail_cubit.dart';
import 'package:jodhere/features/booking/presentation/cubit/slot_cubit.dart';
import 'package:jodhere/features/profile/data/repositories/profile_repository.dart';
import 'package:jodhere/features/booking/data/repositories/booking_repository.dart';
import 'package:jodhere/features/booking/data/repositories/parking_repository.dart';
import 'package:jodhere/core/api/api_client.dart';
import 'package:jodhere/shared/widgets/app_navbar.dart';
import 'package:jodhere/shared/widgets/app_topbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    final supabase = Supabase.instance.client;
    final apiClient = ApiClient(supabase);
    
    // Initialize repositories
    final profileRepository = ProfileRepository(apiClient);
    final bookingRepository = BookingRepository(apiClient);
    final parkingRepository = ParkingRepository(apiClient);

    _pages = [
      const HomePage(),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ParkingListCubit(parkingRepository),
          ),
          BlocProvider(
            create: (_) => ParkingDetailCubit(parkingRepository),
          ),
          BlocProvider(
            create: (_) => SlotCubit(parkingRepository),
          ),
          BlocProvider(
            create: (_) => BookingCubit(bookingRepository),
          ),
        ],
        child: const BookingPage(),
      ),
      BlocProvider(
        create: (_) => ProfileCubit(profileRepository),
        child: const ProfilePage(),
      ),
    ];
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppTopBar(),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: AppNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}