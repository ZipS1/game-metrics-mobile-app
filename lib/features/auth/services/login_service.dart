import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<String> login(String email, String password) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
  final responseTimeoutSeconds =
      GlobalConfiguration().getValue('responseTimeoutSeconds');

  String url = "$baseApiUrl/api/auth/login";
  final Map<String, String> headers = {"Content-Type": "application/json"};
  final Map<String, String> requestBody = {
    "email": email,
    "password": password,
  };

  try {
    final response = await http
        .post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
        )
        .timeout(Duration(seconds: responseTimeoutSeconds));

    switch (response.statusCode) {
      case HttpStatus.ok:
        await ClientService().handleLogin(jsonDecode(response.body));
        return "Успешный вход";
      case HttpStatus.badRequest:
        throw Exception("Неверные данные");
      case HttpStatus.unauthorized:
        throw Exception("Неверный логин или пароль");
      case HttpStatus.internalServerError:
        throw Exception("Ошибка на стороне сервера");
      default:
        throw Exception("Неизвестный статус ответа");
    }
  } on TimeoutException catch (_) {
    throw Exception("Превышено время ожидания запроса");
  } catch (error) {
    throw Exception("Неизвестная ошибка: $error");
  }
}
