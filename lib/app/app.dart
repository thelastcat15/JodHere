import 'package:flutter/material.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.deepPurple,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.main,
    );
  }
}
