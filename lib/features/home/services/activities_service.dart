import 'dart:convert';
import 'dart:io';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart' as model;
import 'package:global_configuration/global_configuration.dart';

Future<List<model.Activity>> getActivities() async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');

  String url = "$baseApiUrl/api/activities";
  final response = await ClientService().get(url);

  if (response.statusCode != HttpStatus.ok) {
    throw Exception(
        'Failed to load activities: ${response.statusCode} | $response');
  }

  try {
    final decoded = json.decode(response.body);
    if (decoded is List) {
      return decoded
          .map((json) => model.Activity.fromJson(json))
          .toList(growable: false);
    } else {
      throw Exception('Invalid response format: Expected a list');
    }
  } catch (e) {
    throw Exception('Failed to parse activities: $e');
  }
}

Future<String> createActivity(String name) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
  final environment = GlobalConfiguration().getValue('environment');

  final url = "$baseApiUrl/api/activities/";

  final body = {"name": name};

  final response = await ClientService().post(url, body: jsonEncode(body));

  return response.statusCode == HttpStatus.created
      ? "Активность успешно создана"
      : response.statusCode == HttpStatus.conflict
          ? throw Exception("Активность с таким именем уже существует")
          : environment == "production"
              ? throw Exception("Ошибка создания активности")
              : throw Exception(
                  'Failed to create activity: ${response.statusCode} | ${response.headers} | ${response.body}');
}
