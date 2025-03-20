import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';
import 'package:http/http.dart' as http;

Future<String> register(
    BuildContext context, String email, String password) async {
  const String url = "$baseApiUrl/api/auth/register";
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

    switch (response.statusCode) {
      case HttpStatus.created:
        return "Пользователь зарегистрирован";
      case HttpStatus.badRequest:
        return "Неверные данные";
      case HttpStatus.conflict:
        return "Пользователь с таким e-mail уже зарегистрирован";
      case HttpStatus.internalServerError:
        return "Ошибка на стороне сервера";
      default:
        return "Неизвестный статус ответа";
    }
  } on TimeoutException catch (_) {
    return "Превышено время ожидания запроса";
  } catch (error) {
    return "Неизвестная ошибка: $error";
  }
}
