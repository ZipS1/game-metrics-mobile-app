import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:game_metrics_mobile_app/common/service_pages/server_unavailable_page.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/login_page.dart';
import 'package:game_metrics_mobile_app/features/home/pages/home.dart';
import 'package:global_configuration/global_configuration.dart';
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
        onUnauthorizedCallback: _handleUnauthorized,
        onServerUnavailableCallback: _handleServiceUnavailable);
  }

  Future<http.Response> get(String url) async => _client.get(Uri.parse(url));
  Future<http.Response> post(String url, {dynamic body}) async =>
      _client.post(Uri.parse(url),
          body: body, headers: {'Content-Type': 'application/json'});
  Future<http.Response> put(String url, {dynamic body}) async =>
      _client.put(Uri.parse(url),
          body: body, headers: {'Content-Type': 'application/json'});
  Future<http.Response> patch(String url, {dynamic body}) async =>
      _client.patch(Uri.parse(url),
          body: body, headers: {'Content-Type': 'application/json'});

  Future<void> handleLogin(Map<String, dynamic> body) async {
    await _storage.write(key: 'access_token', value: body['access_token']);
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (Route<dynamic> route) => false);
  }

  Future<void> handleLogout() async {
    await _handleUnauthorized();
  }

  Future<(bool, String)> ensureAuth() async {
    final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
    final environment = GlobalConfiguration().getValue('environment');
    final responseTimeoutSeconds =
        GlobalConfiguration().getValue('responseTimeoutSeconds');

    try {
      final response = await get("$baseApiUrl/api/auth/check")
          .timeout(Duration(seconds: responseTimeoutSeconds));
      return response.statusCode == HttpStatus.ok
          ? (true, "Сервер снова доступен")
          : environment == "production"
              ? (false, "Сервер недоступен")
              : (
                  false,
                  "${response.statusCode} | ${response.body.toString()} | Server URL: $baseApiUrl"
                );
    } catch (e) {
      _handleServiceUnavailable();
      return environment == "production"
          ? (false, "Сервер недоступен")
          : (false, "Ошибка: ${e.toString()} | Server URL: $baseApiUrl");
    }
  }

  Future<void> _handleUnauthorized() async {
    await _storage.delete(key: 'access_token');
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  void _handleServiceUnavailable() {
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      final currentRoute = ModalRoute.of(currentContext);
      if (currentRoute != null &&
          currentRoute.settings.name == 'serverUnavailableRoute') {
        return;
      }
    }
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const ServerUnavailablePage(),
        settings: const RouteSettings(name: 'serverUnavailableRoute'),
      ),
    );
  }
}

class _AuthenticatedClient extends http.BaseClient {
  final FlutterSecureStorage storage;
  final GlobalKey<NavigatorState> navigatorKey;
  final http.Client _inner = http.Client();
  final Function onUnauthorizedCallback;
  final Function onServerUnavailableCallback;

  _AuthenticatedClient(
      {required this.storage,
      required this.navigatorKey,
      required this.onUnauthorizedCallback,
      required this.onServerUnavailableCallback});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await storage.read(key: 'access_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == HttpStatus.unauthorized) {
      await onUnauthorizedCallback();
    } else if (response.statusCode == HttpStatus.serviceUnavailable) {
      onServerUnavailableCallback();
    }

    return response;
  }
}
