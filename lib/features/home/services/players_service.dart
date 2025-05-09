import 'dart:convert';
import 'dart:io';

import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:global_configuration/global_configuration.dart';

Future<List<Player>> getPlayers(int activityId) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');

  final url = "$baseApiUrl/api/players?activity_id=$activityId";
  final response = await ClientService().get(url);

  if (response.statusCode != HttpStatus.ok) {
    throw Exception(
        'Failed to load players: ${response.statusCode} | $response');
  }

  try {
    final decoded = json.decode(utf8.decode(response.bodyBytes));
    if (decoded is List) {
      return decoded
          .map((json) => Player.fromJson(json))
          .toList(growable: false);
    } else {
      throw Exception('Invalid response format: Expected a list');
    }
  } catch (e) {
    throw Exception('Failed to parse players: $e');
  }
}

Future<String> createPlayer(int activityId, String name) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
  final environment = GlobalConfiguration().getValue('environment');

  final url = "$baseApiUrl/api/players/";

  final body = {"activityId": activityId, "name": name};

  final response = await ClientService().post(url, body: jsonEncode(body));

  return response.statusCode == HttpStatus.created
      ? "Игрок успешно создан"
      : response.statusCode == HttpStatus.conflict
          ? throw Exception("Игрок с таким именем уже существует")
          : environment == "production"
              ? throw Exception("Ошибка создания игрока")
              : throw Exception(
                  'Failed to create player: ${response.statusCode} | ${response.headers} | ${response.body}');
}
