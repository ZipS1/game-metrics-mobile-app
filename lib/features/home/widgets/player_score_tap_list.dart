import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/models/player.dart';
import 'package:game_metrics_mobile_app/features/home/widgets/player_score_row.dart';

class PlayerTapList extends StatelessWidget {
  final List<Player> players;
  final Function onTap;

  const PlayerTapList({
    super.key,
    required this.players,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return const Center(child: Text('Нет игроков'));
    }

    return ListView.separated(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return InkWell(
          onTap: () => onTap(player.id),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: playerScoreRow(player.name, player.score),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        thickness: 1,
        height: 16,
      ),
    );
  }
}
