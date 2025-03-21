import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/login_page.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/sample_secured_page.dart';
import 'package:http/http.dart' as http;

class ClientService {
  static final ClientService _instance = ClientService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late http.Client _client;

  factory ClientService() => _instance;

  ClientService._internal() {
    _client = _AuthenticatedClient(
      storage: _storage,
      navigatorKey: navigatorKey,
    );
  }

  Future<http.Response> get(String url) async => _client.get(Uri.parse(url));
  Future<http.Response> post(String url, {dynamic body}) async =>
      _client.post(Uri.parse(url),
          body: body, headers: {'Content-Type': 'application/json'});

  Future<void> handleLogin(Map<String, dynamic> body) async {
    await _storage.write(key: 'access_token', value: body['access_token']);
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SampleSecuredPage()),
        (Route<dynamic> route) => false);
  }

  Future<void> handleLogout(String token) async {
    await _storage.delete(key: 'access_token');
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}

class _AuthenticatedClient extends http.BaseClient {
  final FlutterSecureStorage storage;
  final GlobalKey<NavigatorState> navigatorKey;
  final http.Client _inner = http.Client();

  _AuthenticatedClient({
    required this.storage,
    required this.navigatorKey,
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await storage.read(key: 'access_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == HttpStatus.unauthorized) {
      await storage.delete(key: 'access_token');
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (Route<dynamic> route) => false);
    }

    return response;
  }
}
