import 'package:flutter/material.dart';
import 'package:jodhere/app/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jodhere/shared/services/auth.dart';
import 'package:jodhere/app/router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('th_TH');
  Intl.defaultLocale = 'th_TH';

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final currentSession = Supabase.instance.client.auth.currentSession;
  if (currentSession != null) {
    try {
      final access = currentSession.accessToken;
      final refresh = currentSession.refreshToken;
      authService.setSession(accessToken: access, refreshToken: refresh);
    } catch (_) {}
  }

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final session = data.session;
    if (session != null) {
      authService.setSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      JodHereApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.main,
        (route) => false,
      );
    } else {
      authService.logout();
      JodHereApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  });

  runApp(const JodHereApp());
}
