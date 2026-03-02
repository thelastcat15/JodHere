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
  static const signup = '/signup';
  static const loginCallback = '/login-callback';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Allow the login-callback route even when not logged in
    final name = settings.name ?? '';
    // Handle incoming deep link URIs like: jodhere://login-callback?code=...
    if (name.startsWith('jodhere://')) {
      final uri = Uri.parse(name);
      if (uri.host == 'login-callback') {
        return MaterialPageRoute(
          builder: (_) => LoginCallbackPage(callbackUri: uri),
        );
      }
    }

    if (!authService.isLoggedIn) {
      if (name == AppRoutes.loginCallback) {
        final uri = settings.arguments as Uri?;
        return MaterialPageRoute(
          builder: (_) => LoginCallbackPage(callbackUri: uri),
        );
      } else if (name == AppRoutes.signup) {
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      } else {
        return MaterialPageRoute(builder: (_) => const LoginPage());
      }
    }

    switch (settings.name) {
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      case AppRoutes.parkingDetail:
        final args = settings.arguments as ParkingDetailArgs;

        return MaterialPageRoute(
          builder: (_) => ParkingBookingPage(
            parkingId: args.parkingId,
            title: args.title,
            rating: args.rating,
            price: args.price,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}

class LoginCallbackPage extends StatefulWidget {
  final Uri? callbackUri;

  const LoginCallbackPage({super.key, this.callbackUri});

  @override
  State<LoginCallbackPage> createState() => _LoginCallbackPageState();
}

class _LoginCallbackPageState extends State<LoginCallbackPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _process());
  }

  void _process() {
    final uri = widget.callbackUri;
    // Try to extract code or token from the URI
    final code = uri?.queryParameters['code'];
    final token = uri?.queryParameters['token'];

    // Supabase may return the access token in the fragment: #access_token=...
    String? fragmentAccessToken;
    if (uri != null && uri.fragment.isNotEmpty) {
      try {
        final fragMap = Uri.splitQueryString(uri.fragment);
        fragmentAccessToken = fragMap['access_token'];
        // also read refresh token if present
        final fragmentRefresh = fragMap['refresh_token'];
        if (fragmentRefresh != null) {
          // set both tokens
          authService.setSession(
            accessToken: fragmentAccessToken ?? '',
            refreshToken: fragmentRefresh,
            expiresIn: int.tryParse(fragMap['expires_in'] ?? ''),
          );
        }
      } catch (_) {
        fragmentAccessToken = null;
      }
    }

    final effectiveToken = token ?? fragmentAccessToken;

    if (effectiveToken != null) {
      // If we already set session with refresh token above, ensure access is set too
      if (authService.getAccessToken() == null) {
        authService.setSession(accessToken: effectiveToken);
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      return;
    }

    if (code != null) {
      // In a real app, exchange code for token via backend here.
      // For now store the code as a placeholder access token (not recommended).
      authService.setSession(accessToken: code);
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      return;
    }

    // No usable params: go to login (or show error)
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
