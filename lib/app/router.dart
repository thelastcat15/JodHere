import 'package:flutter/material.dart';

import 'package:jodhere/app/layouts/main_layout.dart';
import 'package:jodhere/app/routes/parking_detail_route.dart';
import 'package:jodhere/features/booking/presentation/pages/parking_booking_page.dart';

class AppRoutes {
  static const main = '/';
  static const parkingDetail = '/parking-detail';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.main:
        return MaterialPageRoute(
          builder: (_) => const MainLayout(),
        );

      case AppRoutes.parkingDetail:
        final args = settings.arguments as ParkingDetailArgs;

        return MaterialPageRoute(
          builder: (_) => ParkingBookingPage(
            parkingId: args.parkingId,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
