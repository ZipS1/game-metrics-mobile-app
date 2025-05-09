import 'dart:convert';
import 'dart:io';

import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/common/models/game_player.dart';
import 'package:global_configuration/global_configuration.dart';

Future<Game> getGame(int gameId) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');

  final url = "$baseApiUrl/api/games/$gameId";
  final response = await ClientService().get(url);

  if (response.statusCode != HttpStatus.ok) {
    throw Exception('Failed to load game: ${response.statusCode} | $response');
  }

  Game game = Game.fromJson(json.decode(response.body));

  await Future.wait(game.players.map((gamePlayer) async {
    final url = "$baseApiUrl/api/players/${gamePlayer.playerId}";
    final response = await ClientService().get(url);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
          'Failed to load player with id ${gamePlayer.playerId}: ${response.statusCode} | $response');
    }

    gamePlayer.name = json.decode(utf8.decode(response.bodyBytes))["name"];
    return gamePlayer;
  }));

  return game;
}

Future<String> addPointsToPlayer(int gameId, int playerId, int points) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
  final environment = GlobalConfiguration().getValue('environment');

  final url = "$baseApiUrl/api/games/addPoints";

  final body = {
    "gameId": gameId,
    "playerId": playerId,
    "additionalPoints": points
  };

  final response = await ClientService().patch(url, body: jsonEncode(body));

  return response.statusCode == HttpStatus.ok
      ? "Очки успешно добавлены"
      : environment == "production"
          ? throw Exception("Ошибка при добавлении очков")
          : throw Exception(
              'Failed to add points: ${response.statusCode} | ${response.headers} | ${response.body}');
}

Future<String> finishGame(int gameId, List<GamePlayer> players) async {
  final baseApiUrl = GlobalConfiguration().getValue('baseApiUrl');
  final environment = GlobalConfiguration().getValue('environment');

  final url = "$baseApiUrl/api/games/finish";

  List<Object> playersDTO = [];
  for (var p in players) {
    playersDTO.add({"id": p.playerId, "endPoints": p.endPoints});
  }

  final body = {"gameId": gameId, "players": playersDTO};

  final response = await ClientService().put(url, body: jsonEncode(body));

  return response.statusCode == HttpStatus.ok
      ? "Игра успешно завершена"
      : environment == "production"
          ? throw Exception("Ошибка при завершении игры")
          : throw Exception(
              'Failed to finish game: ${response.statusCode} | ${response.headers} | ${response.body}');
}
