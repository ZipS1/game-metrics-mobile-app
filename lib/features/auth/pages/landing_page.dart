import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/sample_secured_page.dart';
import 'package:game_metrics_mobile_app/features/auth/services/client_service.dart';

final RouteObserver<ModalRoute<dynamic>> routeObserver =
    RouteObserver<ModalRoute<dynamic>>();

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    _ensureAuth();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _ensureAuth();
  }

  Future<void> _ensureAuth() async {
    final isAuthenticated = await ClientService().ensureAuth();
    if (!mounted) return;
    if (!isAuthenticated) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SampleSecuredPage()),
      (Route<dynamic> route) => false,
    );
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
