import 'dart:convert';

import 'package:game_metrics_mobile_app/common/global/client_service.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';

Future<List<Player>> getPlayers(int activityId) async {
  final url = "$baseApiUrl/api/players?activity_id=$activityId";
  final response = await ClientService().get(url);
  final data = json.decode(utf8.decode(response.bodyBytes)) as List;
  return data.map((e) => Player.fromJson(e)).toList();
}
