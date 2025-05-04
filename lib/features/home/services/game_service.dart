import 'dart:convert';
import 'dart:io';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';

Future<List<Game>> getGames(int activityId) async {
  final url = "$baseApiUrl/api/games?activity_id=$activityId";
  final response = await ClientService().get(url);

  if (response.statusCode != HttpStatus.ok) {
    throw Exception('Failed to load games: ${response.statusCode} | $response');
  }

  try {
    final decoded = json.decode(response.body);
    if (decoded is List) {
      return decoded.map((e) => Game.fromJson(e)).toList(growable: false);
    } else {
      throw Exception('Invalid response format: Expected a list');
    }
  } catch (e) {
    throw Exception('Failed to parse games: $e');
  }
}
