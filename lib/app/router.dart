import 'package:flutter/material.dart';

import 'package:jodhere/app/layouts/main_layout.dart';
import 'package:jodhere/app/routes/parking_detail_route.dart';
import 'package:jodhere/features/booking/presentation/pages/parking_booking_page.dart';
import 'package:jodhere/features/signup/presentation/pages/login_page.dart';
import 'package:jodhere/features/signup/presentation/pages/sign_up_page.dart';
import 'package:jodhere/shared/services/auth.dart';

class AppRoutes {
  static const main = '/';
  static const parkingDetail = '/parking-detail';
  static const login = '/login';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (!authService.isLoggedIn) {
      if (settings.name == AppRoutes.login) {
        return MaterialPageRoute(builder: (_) => const LoginPage());
      }

      return MaterialPageRoute(builder: (_) => Scaffold(body: SignUpPage()));
    }

    switch (settings.name) {
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      case AppRoutes.parkingDetail:
        final args = settings.arguments as ParkingDetailArgs;

        return MaterialPageRoute(
          builder: (_) => ParkingBookingPage(parkingId: args.parkingId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
