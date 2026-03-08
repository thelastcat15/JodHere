import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';

class JodHereApp extends StatelessWidget {
  const JodHereApp({super.key});

  // Global navigator key so other modules (e.g., auth listener) can navigate
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JodHere',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      locale: const Locale('th', 'TH'),
      supportedLocales: const [
        Locale('th', 'TH'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.deepPurple,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.main,
    );
  }
}
