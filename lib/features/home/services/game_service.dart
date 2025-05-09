import 'dart:convert';
import 'dart:io';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:global_configuration/global_configuration.dart';

Future<List<Game>> getGames(int activityId) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');

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

Future<(String, int)> createGame(
    int activityId, List<Player> players, int entryPoints) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
  final environment = GlobalConfiguration().getValue('environment');

  final url = "$baseApiUrl/api/games/";

  var gamePlayers =
      players.map((p) => {"id": p.id, "entryPoints": entryPoints}).toList();

  final body = {"activityId": activityId, "players": gamePlayers};

  final response = await ClientService().post(url, body: jsonEncode(body));

  int gameId = 0;
  if (response.statusCode == HttpStatus.created) {
    gameId = jsonDecode(response.body)["id"];
  }

  return response.statusCode == HttpStatus.created
      ? ("Игра успешно создана", gameId)
      : environment == "production"
          ? throw Exception("Ошибка создания игры")
          : throw Exception(
              'Failed to create game: ${response.statusCode} | ${response.headers} | ${response.body}');
}
