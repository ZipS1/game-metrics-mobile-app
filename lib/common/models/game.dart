import 'package:game_metrics_mobile_app/common/models/game_player.dart';

class Game {
  final int id;
  final DateTime startTime;
  final Duration duration;
  List<GamePlayer> players;

  Game(
      {required this.id,
      required this.startTime,
      required this.duration,
      required this.players});

  factory Game.fromJson(Map<String, dynamic> json) => Game(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      duration: Duration(microseconds: (json['duration'] as int) ~/ 1000),
      players: List.from(json["players"])
          .map((playerJson) => GamePlayer.fromJson(playerJson))
          .toList());
}
