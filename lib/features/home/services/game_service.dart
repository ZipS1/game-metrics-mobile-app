import 'dart:convert';

import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/game.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';

Future<List<Game>> getGames(int activityId) async {
  final url = "$baseApiUrl/api/games?activity_id=$activityId";
  final response = await ClientService().get(url);
  final data = json.decode(response.body) as List;
  return data.map((e) => Game.fromJson(e)).toList();
}
