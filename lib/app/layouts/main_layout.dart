import 'package:flutter/material.dart';
import 'package:jodhere/features/booking/presentation/pages/booking_page.dart';
import 'package:jodhere/features/booking/presentation/pages/booking_page_backup.dart';
import 'package:jodhere/features/home/presentation/pages/home_page.dart';
// import 'package:jodhere/features/map/presentation/pages/map_page.dart';
import 'package:jodhere/features/points/presentation/pages/points_page.dart';
import 'package:jodhere/features/profile/presentation/pages/profile_page.dart';
import 'package:jodhere/shared/widgets/app_navbar.dart';
import 'package:jodhere/shared/widgets/app_topbar.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({
    super.key,
    this.initialIndex = 0,  
  });
  
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final _pages = const [
    HomePage(),
    BookingPage(),
    BookingPageBackup(),
    // MapPage(),
    PointsPage(),
    ProfilePage(),
  ];

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
        appBar: AppTopBar(title: 'JodHere'),
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
