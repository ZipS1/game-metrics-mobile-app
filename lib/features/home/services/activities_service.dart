import 'dart:convert';
import 'dart:io';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/activity.dart' as model;
import 'package:game_metrics_mobile_app/config/environment.dart';

Future<List<model.Activity>> getActivities() async {
  const String url = "$baseApiUrl/api/activities";
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
