import 'dart:convert';
import 'dart:io';

import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';

Future<Game> getGame(int gameId) async {
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
