import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/global/route_observer.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/landing_page.dart';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
        navigatorKey: ClientService().navigatorKey,
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        home: LandingPage());
  }
}
