class GamePlayer {
  final int? gameId;
  final int playerId;
  String? name;
  final int entryPoints;
  final int additionalPoints;
  final int endPoints;

  GamePlayer(
      {required this.playerId,
      required this.entryPoints,
      required this.additionalPoints,
      required this.endPoints,
      this.gameId});

  factory GamePlayer.fromJson(Map<String, dynamic> json) => GamePlayer(
        playerId: json['id'],
        entryPoints: json['entryPoints'],
        additionalPoints: json['additionalPoints'],
        endPoints: json['endPoints'],
      );
}
