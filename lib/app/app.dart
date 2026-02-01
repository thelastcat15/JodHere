import 'package:flutter/material.dart';
import 'router.dart';

class JodHereApp extends StatelessWidget {
  const JodHereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JodHere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.deepPurple,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.main,
    );
  }
}
