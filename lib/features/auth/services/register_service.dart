import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<String> register(String email, String password) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
  final responseTimeoutSeconds =
      GlobalConfiguration().getValue('responseTimeoutSeconds');

  String url = "$baseApiUrl/api/auth/register";
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
      case HttpStatus.created:
        return "Пользователь зарегистрирован";
      case HttpStatus.badRequest:
        throw Exception("Неверные данные");
      case HttpStatus.conflict:
        throw Exception("Пользователь с таким e-mail уже зарегистрирован");
      case HttpStatus.internalServerError:
        throw Exception("Ошибка на стороне сервера");
      default:
        throw Exception("Неизвестный статус ответа");
    }
  } on TimeoutException catch (_) {
    throw Exception("Превышено время ожидания запроса");
  } catch (error) {
    return throw Exception("Неизвестная ошибка: $error");
  }
}
