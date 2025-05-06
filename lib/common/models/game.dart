class Game {
  final int id;
  final DateTime startTime;
  final Duration duration;

  Game({required this.id, required this.startTime, required this.duration});

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json['id'],
        startTime: DateTime.parse(json['startTime']),
        duration: Duration(microseconds: (json['duration'] as int) ~/ 1000),
      );
}
