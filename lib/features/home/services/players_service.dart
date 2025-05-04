import 'dart:convert';
import 'dart:io';

import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';

Future<List<Player>> getPlayers(int activityId) async {
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
