import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';
import 'package:http/http.dart' as http;

Future<String> login(
    BuildContext context, String email, String password) async {
  const String url = "$baseApiUrl/api/auth/login";
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
        .timeout(const Duration(seconds: responseTimeoutSeconds));

    if (response.statusCode == 200) {
      return "Успешный вход";
    } else {
      return "Неверный логин или пароль";
    }
  } on TimeoutException catch (_) {
    return "Превышено время ожидания запроса";
  } catch (error) {
    return "Неизвестная ошибка: $error";
  }
}
