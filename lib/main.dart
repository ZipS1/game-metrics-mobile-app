import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/landing_page.dart';
import 'package:game_metrics_mobile_app/features/auth/services/client_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: ClientService().navigatorKey,
        debugShowCheckedModeBanner: false,
        home: LandingPage());
  }
}
