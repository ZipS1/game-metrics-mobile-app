class Player {
  final int id;
  final String name;
  final int score;

  Player({required this.id, required this.name, required this.score});

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'],
        name: json['name'],
        score: json['score'],
      );
}
