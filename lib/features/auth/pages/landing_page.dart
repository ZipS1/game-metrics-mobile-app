// landing_page.dart
import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/features/auth/services/client_service.dart';
import 'login_page.dart';
import 'sample_secured_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final navigator = Navigator.of(context);

    final isAuth = await ClientService().isAuthenticated();
    if (isAuth) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const SampleSecuredPage()),
      );
    } else {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
